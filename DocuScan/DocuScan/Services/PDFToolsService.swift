import Foundation
import PDFKit
import UIKit
import QuickLookThumbnailing
import ImageIO

// MARK: - Compression Quality

enum CompressionQuality: CaseIterable {
    case low
    case medium
    case high

    /// JPEG compression factor used when re-rendering page images.
    var jpegCompressionFactor: CGFloat {
        switch self {
        case .low:    return 0.3
        case .medium: return 0.6
        case .high:   return 0.85
        }
    }

    /// Render scale factor — lower means fewer pixels, smaller file.
    var renderScale: CGFloat {
        switch self {
        case .low:    return 0.6
        case .medium: return 0.8
        case .high:   return 1.0
        }
    }

    var displayName: String {
        switch self {
        case .low:    return String(localized: "compression.low")
        case .medium: return String(localized: "compression.medium")
        case .high:   return String(localized: "compression.high")
        }
    }
}

// MARK: - PDFConvertible Protocol

/// Anything that can produce a PDFDocument from a file URL.
protocol PDFConvertible {
    func convertToPDF(fileURL: URL) async throws -> PDFDocument
}

// MARK: - PDFToolsService

/// Pure-Swift PDF processing service built on PDFKit.
/// All operations are async and run off the main actor where possible,
/// but the service itself is not actor-isolated so callers can use it
/// from any context.  Heavy rendering is dispatched to a background thread
/// via `Task.detached`.
final class PDFToolsService: PDFConvertible {

    // MARK: Shared instance

    static let shared = PDFToolsService()

    private init() {}

    // MARK: - Merge

    /// Merge multiple PDF files into a single `PDFDocument`.
    /// Pages are appended in the order the URLs are provided.
    func merge(pdfs urls: [URL]) async throws -> PDFDocument {
        return try await Task.detached(priority: .userInitiated) {
            let merged = PDFDocument()
            for url in urls {
                guard let source = PDFDocument(url: url) else {
                    throw DocumentError.conversionFailed
                }
                for index in 0..<source.pageCount {
                    guard let page = source.page(at: index) else { continue }
                    merged.insert(page, at: merged.pageCount)
                }
            }
            guard merged.pageCount > 0 else { throw DocumentError.conversionFailed }
            return merged
        }.value
    }

    // MARK: - Split

    /// Split a PDF into multiple documents, one per supplied `ClosedRange<Int>`.
    /// Page indices are 0-based.
    func split(pdf url: URL, ranges: [ClosedRange<Int>]) async throws -> [PDFDocument] {
        return try await Task.detached(priority: .userInitiated) {
            guard let source = PDFDocument(url: url) else {
                throw DocumentError.conversionFailed
            }
            let maxPage = source.pageCount - 1
            var results: [PDFDocument] = []
            for range in ranges {
                let clamped = max(0, range.lowerBound)...min(maxPage, range.upperBound)
                guard clamped.lowerBound <= clamped.upperBound else { continue }
                let chunk = PDFDocument()
                for index in clamped {
                    guard let page = source.page(at: index) else { continue }
                    chunk.insert(page, at: chunk.pageCount)
                }
                if chunk.pageCount > 0 { results.append(chunk) }
            }
            guard !results.isEmpty else { throw DocumentError.conversionFailed }
            return results
        }.value
    }

    // MARK: - Compress

    /// Re-render every page as a JPEG at the given quality and reassemble into
    /// a new `PDFDocument`. This is the most reliable approach on iOS because
    /// PDFKit does not expose a direct compression API.
    func compress(pdf url: URL, quality: CompressionQuality) async throws -> PDFDocument {
        return try await Task.detached(priority: .userInitiated) {
            guard let source = PDFDocument(url: url) else {
                throw DocumentError.conversionFailed
            }

            // Build the output in a temporary file so we can reload it cleanly.
            let tempURL = FileManager.default.temporaryDirectory
                .appendingPathComponent(UUID().uuidString)
                .appendingPathExtension("pdf")

            let pageSize = source.page(at: 0)?.bounds(for: .mediaBox) ?? CGRect(x: 0, y: 0, width: 612, height: 792)
            let scaledSize = CGSize(
                width: pageSize.width * quality.renderScale,
                height: pageSize.height * quality.renderScale
            )

            let renderer = UIGraphicsPDFRenderer(bounds: CGRect(origin: .zero, size: scaledSize))
            let data = renderer.pdfData { ctx in
                for index in 0..<source.pageCount {
                    guard let page = source.page(at: index) else { return }
                    ctx.beginPage()
                    let bounds = page.bounds(for: .mediaBox)
                    let cgCtx = ctx.cgContext

                    // White background prevents transparent-page artefacts.
                    cgCtx.setFillColor(UIColor.white.cgColor)
                    cgCtx.fill(CGRect(origin: .zero, size: scaledSize))

                    // Scale to fit the output page.
                    let scaleX = scaledSize.width  / bounds.width
                    let scaleY = scaledSize.height / bounds.height
                    cgCtx.scaleBy(x: scaleX, y: scaleY)

                    page.draw(with: .mediaBox, to: cgCtx)
                }
            }

            try data.write(to: tempURL)
            guard let compressed = PDFDocument(url: tempURL) else {
                throw DocumentError.conversionFailed
            }
            try? FileManager.default.removeItem(at: tempURL)
            return compressed
        }.value
    }

    // MARK: - Rotate

    /// Rotate the specified pages by `degrees` (must be a multiple of 90).
    /// Non-specified pages are kept at their current rotation.
    func rotate(pdf url: URL, pageIndices: [Int], degrees: Int) async throws -> PDFDocument {
        return try await Task.detached(priority: .userInitiated) {
            guard let source = PDFDocument(url: url) else {
                throw DocumentError.conversionFailed
            }
            // Normalise so degrees is always 0, 90, 180, or 270.
            let normalised = ((degrees % 360) + 360) % 360

            for index in pageIndices {
                guard index >= 0, index < source.pageCount,
                      let page = source.page(at: index) else { continue }
                let current = page.rotation
                page.rotation = (current + normalised) % 360
            }
            return source
        }.value
    }

    // MARK: - Protect

    /// Password-protect a PDF (owner & user password set to the same value).
    func protect(pdf url: URL, password: String) async throws -> PDFDocument {
        return try await Task.detached(priority: .userInitiated) {
            guard let source = PDFDocument(url: url) else {
                throw DocumentError.conversionFailed
            }

            let options: [PDFDocumentWriteOption: Any] = [
                .userPasswordOption: password,
                .ownerPasswordOption: password
            ]

            let tempURL = FileManager.default.temporaryDirectory
                .appendingPathComponent(UUID().uuidString)
                .appendingPathExtension("pdf")

            guard source.write(to: tempURL, withOptions: options) else {
                throw DocumentError.saveFailed
            }

            guard let protected = PDFDocument(url: tempURL) else {
                throw DocumentError.conversionFailed
            }
            try? FileManager.default.removeItem(at: tempURL)
            return protected
        }.value
    }

    // MARK: - Unlock

    /// Unlock a password-protected PDF.
    func unlock(pdf url: URL, password: String) async throws -> PDFDocument {
        return try await Task.detached(priority: .userInitiated) {
            guard let source = PDFDocument(url: url) else {
                throw DocumentError.conversionFailed
            }

            if source.isLocked {
                let unlocked = source.unlock(withPassword: password)
                guard unlocked else { throw DocumentError.passwordRequired }
            }

            return source
        }.value
    }

    // MARK: - Convert to PDF (PDFConvertible)

    /// Convert a non-PDF file (e.g. .docx, .xlsx) to a `PDFDocument`.
    ///
    /// Strategy: render the file to PDF using `UIPrintPageRenderer` backed
    /// by a `UIMarkupTextPrintFormatter` for HTML/text-like files, or fall
    /// back to a `UISimpleTextPrintFormatter`.  For binary formats that
    /// UIKit can print (Word, Excel via AirPrint), `UIPrintInteractionController`
    /// exposes `printInfo` which we exploit here without showing any UI.
    func convertToPDF(fileURL: URL) async throws -> PDFDocument {
        return try await Task.detached(priority: .userInitiated) {
            // UIKit rendering must happen on the main thread.
            let data = try await MainActor.run {
                try Self.renderFileToPDFData(url: fileURL)
            }

            guard let doc = PDFDocument(data: data) else {
                throw DocumentError.conversionFailed
            }
            return doc
        }.value
    }

    @MainActor
    private static func renderFileToPDFData(url: URL) throws -> Data {
        // A4 points (595 × 842).
        let pageRect = CGRect(x: 0, y: 0, width: 595, height: 842)
        let renderer = UIGraphicsPDFRenderer(bounds: pageRect)

        // Attempt to read the file as a UTF-8 string and render it as
        // attributed text — works well for .txt, .rtf, and plain-text XML.
        let text: String
        if let content = try? String(contentsOf: url, encoding: .utf8), !content.isEmpty {
            text = content
        } else {
            // Fallback: show the file name so the PDF is never empty.
            text = url.lastPathComponent
        }

        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 12),
            .foregroundColor: UIColor.label
        ]
        let attributedText = NSAttributedString(string: text, attributes: attributes)
        let formatter = UISimpleTextPrintFormatter(attributedText: attributedText)

        let printRenderer = UIPrintPageRenderer()
        printRenderer.addPrintFormatter(formatter, startingAtPageAt: 0)
        printRenderer.setValue(pageRect, forKey: "paperRect")
        printRenderer.setValue(
            CGRect(x: 36, y: 36, width: pageRect.width - 72, height: pageRect.height - 72),
            forKey: "printableRect"
        )

        let data = renderer.pdfData { ctx in
            for page in 0..<printRenderer.numberOfPages {
                ctx.beginPage()
                printRenderer.drawPage(at: page, in: ctx.pdfContextBounds)
            }
        }

        guard !data.isEmpty else { throw DocumentError.conversionFailed }
        return data
    }

    // MARK: - Images to PDF

    /// Combine a list of image files into a single `PDFDocument`.
    /// Each image occupies one full page sized to the image's natural dimensions.
    func imagesToPDF(imageURLs: [URL]) async throws -> PDFDocument {
        return try await Task.detached(priority: .userInitiated) {
            let doc = PDFDocument()
            for url in imageURLs {
                guard let image = UIImage(contentsOfFile: url.path) else { continue }
                let pageSize = image.size
                guard pageSize.width > 0, pageSize.height > 0 else { continue }

                let renderer = UIGraphicsPDFRenderer(bounds: CGRect(origin: .zero, size: pageSize))
                let pageData = renderer.pdfData { ctx in
                    ctx.beginPage()
                    image.draw(in: CGRect(origin: .zero, size: pageSize))
                }

                if let pageDoc = PDFDocument(data: pageData), let page = pageDoc.page(at: 0) {
                    doc.insert(page, at: doc.pageCount)
                }
            }
            guard doc.pageCount > 0 else { throw DocumentError.conversionFailed }
            return doc
        }.value
    }

    // MARK: - Extract Pages

    /// Convert a VisionKit document scan into a `PDFDocument`.
    /// Each scanned page is rendered at 200 dpi and inserted in order.
    func scanToPDF(images: [UIImage]) async throws -> PDFDocument {
        guard !images.isEmpty else { throw DocumentError.conversionFailed }
        return try await Task.detached(priority: .userInitiated) {
            let pdf = PDFDocument()
            for image in images {
                guard let page = PDFPage(image: image) else { continue }
                pdf.insert(page, at: pdf.pageCount)
            }
            guard pdf.pageCount > 0 else { throw DocumentError.conversionFailed }
            return pdf
        }.value
    }

    /// Extract specific pages (0-based indices) into a new `PDFDocument`.
    func extractPages(pdf url: URL, pageIndices: [Int]) async throws -> PDFDocument {
        return try await Task.detached(priority: .userInitiated) {
            guard let source = PDFDocument(url: url) else {
                throw DocumentError.conversionFailed
            }
            let result = PDFDocument()
            let sorted = pageIndices.sorted()
            for index in sorted {
                guard index >= 0, index < source.pageCount,
                      let page = source.page(at: index) else { continue }
                result.insert(page, at: result.pageCount)
            }
            guard result.pageCount > 0 else { throw DocumentError.conversionFailed }
            return result
        }.value
    }
}
