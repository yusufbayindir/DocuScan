import XCTest
import PDFKit
import UIKit
@testable import DocuScan

// MARK: - PDFToolsService Extended Tests

final class PDFToolsServiceExtendedTests: XCTestCase {
    // swiftlint:disable implicitly_unwrapped_optional
    var sut: PDFToolsService!
    var tempDir: URL!
    // swiftlint:enable implicitly_unwrapped_optional

    override func setUpWithError() throws {
        sut = PDFToolsService.shared
        tempDir = FileManager.default.temporaryDirectory
            .appendingPathComponent(UUID().uuidString)
        try FileManager.default.createDirectory(at: tempDir, withIntermediateDirectories: true)
    }

    override func tearDownWithError() throws {
        try? FileManager.default.removeItem(at: tempDir)
    }

    // MARK: scanToPDF

    func testScanToPDFWithSingleImage() async throws {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 100, height: 100))
        let image = renderer.image { ctx in
            UIColor.white.setFill()
            ctx.fill(CGRect(x: 0, y: 0, width: 100, height: 100))
        }
        let pdf = try await sut.scanToPDF(images: [image])
        XCTAssertEqual(pdf.pageCount, 1)
    }

    func testScanToPDFWithMultipleImages() async throws {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 100, height: 100))
        let images = (0..<3).map { _ in
            renderer.image { ctx in
                UIColor.lightGray.setFill()
                ctx.fill(CGRect(x: 0, y: 0, width: 100, height: 100))
            }
        }
        let pdf = try await sut.scanToPDF(images: images)
        XCTAssertEqual(pdf.pageCount, 3)
    }

    func testScanToPDFWithEmptyImagesThrows() async {
        do {
            _ = try await sut.scanToPDF(images: [])
            XCTFail("Expected error not thrown")
        } catch {
            XCTAssertTrue(error is DocumentError)
        }
    }

    // MARK: compress

    func testCompressReducesOrMaintainsPageCount() async throws {
        let pdf = PDFDocument()
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 612, height: 792))
        let image = renderer.image { ctx in
            UIColor.white.setFill()
            ctx.fill(CGRect(x: 0, y: 0, width: 612, height: 792))
        }
        guard let page = PDFPage(image: image) else {
            throw XCTSkip("PDFPage(image:) unavailable in test environment")
        }
        pdf.insert(page, at: 0)
        let url = tempDir.appendingPathComponent("compress_test.pdf")
        guard pdf.write(to: url) else { throw DocumentError.saveFailed }

        let compressed = try await sut.compress(pdf: url, quality: .low)
        XCTAssertEqual(compressed.pageCount, 1)
    }

    // MARK: merge edge cases

    func testMergeEmptyArrayThrows() async {
        do {
            _ = try await sut.merge(pdfs: [])
            XCTFail("Expected error not thrown")
        } catch {
            XCTAssertTrue(error is DocumentError)
        }
    }

    func testMergeSinglePDFReturnsAllPages() async throws {
        let url = try makePDF(pageCount: 4)
        let merged = try await sut.merge(pdfs: [url])
        XCTAssertEqual(merged.pageCount, 4)
    }

    // MARK: split edge cases

    func testSplitClampsOutOfBoundsRange() async throws {
        let url = try makePDF(pageCount: 3)
        let parts = try await sut.split(pdf: url, ranges: [0...10])
        XCTAssertEqual(parts.count, 1)
        XCTAssertEqual(parts[0].pageCount, 3)
    }

    // MARK: rotate

    func testRotate360IsNoop() async throws {
        let url = try makePDF(pageCount: 1)
        let rotated = try await sut.rotate(pdf: url, pageIndices: [0], degrees: 360)
        XCTAssertEqual(rotated.page(at: 0)?.rotation, 0)
    }

    func testRotateNegativeNormalises() async throws {
        let url = try makePDF(pageCount: 1)
        let rotated = try await sut.rotate(pdf: url, pageIndices: [0], degrees: -90)
        // -90 → ((-90 % 360) + 360) % 360 = 270
        XCTAssertEqual(rotated.page(at: 0)?.rotation, 270)
    }

    // MARK: extract edge cases

    func testExtractOutOfBoundsIndicesReturnsEmpty() async {
        do {
            let url = try makePDF(pageCount: 2)
            _ = try await sut.extractPages(pdf: url, pageIndices: [99])
            XCTFail("Expected error not thrown")
        } catch {
            XCTAssertTrue(error is DocumentError)
        }
    }

    // MARK: Helpers

    private func makePDF(pageCount: Int) throws -> URL {
        let pdf = PDFDocument()
        for _ in 0..<pageCount {
            let page = PDFPage()
            pdf.insert(page, at: pdf.pageCount)
        }
        let url = tempDir.appendingPathComponent("\(UUID().uuidString).pdf")
        guard pdf.write(to: url) else { throw DocumentError.saveFailed }
        return url
    }
}

// MARK: - IAPError Tests

final class IAPErrorTests: XCTestCase {
    func testFailedVerificationHasDescription() {
        let error = IAPError.failedVerification
        XCTAssertNotNil(error.errorDescription)
        XCTAssertFalse(error.errorDescription?.isEmpty ?? true)
    }

    func testProductUnavailableHasDescription() {
        let error = IAPError.productUnavailable
        XCTAssertNotNil(error.errorDescription)
        XCTAssertFalse(error.errorDescription?.isEmpty ?? true)
    }

    func testErrorDescriptionsAreDifferent() {
        XCTAssertNotEqual(
            IAPError.failedVerification.errorDescription,
            IAPError.productUnavailable.errorDescription
        )
    }
}

// MARK: - IAPService Init Tests

@MainActor
final class IAPServiceInitTests: XCTestCase {
    func testInitialStateIsEmpty() {
        let adService = AdService()
        let iap = IAPService(adService: adService)
        XCTAssertNil(iap.monthlyProduct)
        XCTAssertFalse(iap.isPurchasing)
        XCTAssertFalse(iap.isRestoring)
    }

    func testProductIDConstant() {
        XCTAssertEqual(IAPService.monthlyProductID, "com.docuscan.premium.monthly")
    }
}

// MARK: - DocumentStore Extended Tests

final class DocumentStoreExtendedTests: XCTestCase {
    func testInitialDocumentsAreEmpty() async {
        let store = await DocumentStore()
        let docs = await store.recentDocuments
        XCTAssertTrue(docs.isEmpty)
    }

    func testFavoritesInitiallyEmpty() async {
        let store = await DocumentStore()
        let favs = await store.favoriteDocuments
        XCTAssertTrue(favs.isEmpty)
    }

    func testToggleFavoriteAddsDocument() async {
        let store = await DocumentStore()
        let doc = DocuScanDocument(
            id: UUID(),
            name: "Extended Test",
            url: URL(fileURLWithPath: "/tmp/extended.pdf"),
            createdAt: Date(),
            pageCount: 2
        )
        await store.toggleFavorite(doc)
        let isFav = await store.favoriteDocuments.contains { $0.id == doc.id }
        XCTAssertTrue(isFav)
    }

    func testToggleFavoriteRemovesDocument() async {
        let store = await DocumentStore()
        let doc = DocuScanDocument(
            id: UUID(),
            name: "Remove Test",
            url: URL(fileURLWithPath: "/tmp/remove.pdf"),
            createdAt: Date(),
            pageCount: 1
        )
        await store.toggleFavorite(doc)
        await store.toggleFavorite(doc)
        let isFav = await store.favoriteDocuments.contains { $0.id == doc.id }
        XCTAssertFalse(isFav)
    }
}
