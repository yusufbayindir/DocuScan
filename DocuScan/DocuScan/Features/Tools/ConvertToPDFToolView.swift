import SwiftUI
import PDFKit

// MARK: - ConvertToPDFToolView

struct ConvertToPDFToolView: View {

    // MARK: Input

    let sourceURL: URL

    // MARK: Environment

    @EnvironmentObject var appEnvironment: AppEnvironment

    // MARK: State

    @State private var isProcessing = false
    @State private var resultDocument: DocuScanDocument?
    @State private var fileSize: String = ""
    @State private var errorMessage: String?
    @State private var showError = false
    @State private var navigateToViewer = false

    // MARK: Computed helpers

    private var fileExtension: String {
        sourceURL.pathExtension.lowercased()
    }

    private var isWordFile: Bool {
        fileExtension == "doc" || fileExtension == "docx"
    }

    private var isExcelFile: Bool {
        fileExtension == "xls" || fileExtension == "xlsx"
    }

    private var isSupportedType: Bool {
        isWordFile || isExcelFile
    }

    private var fileIcon: String {
        if isWordFile { return "doc.richtext.fill" }
        if isExcelFile { return "tablecells.fill" }
        return "doc.fill"
    }

    private var fileIconColor: Color {
        if isWordFile { return Color(hex: "#185ABD") }
        if isExcelFile { return Color(hex: "#217346") }
        return Color.dsTextSecondary
    }

    private var outputName: String {
        sourceURL.deletingPathExtension().lastPathComponent
    }

    // MARK: Body

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: Spacing.lg) {
                    fileInfoCard
                    explanationCard
                    if !isSupportedType {
                        unsupportedTypeNotice
                    }
                    convertButton
                }
                .padding(.horizontal, Spacing.md)
                .padding(.top, Spacing.md)
                .padding(.bottom, Spacing.xl)
            }
            .background(Color.dsBackground)
            .navigationTitle(String(localized: "convert_to_pdf.nav_title"))
            .navigationBarTitleDisplayMode(.inline)
            .navigationDestination(isPresented: $navigateToViewer) {
                if let doc = resultDocument {
                    DocumentViewerView(source: .saved(doc))
                }
            }
            .alert(
                String(localized: "error.title"),
                isPresented: $showError,
                presenting: errorMessage
            ) { _ in
                Button(String(localized: "button.ok")) { showError = false }
            } message: { msg in
                Text(msg)
            }
            .task {
                computeFileSize()
            }
        }
    }

    // MARK: - File Info Card

    private var fileInfoCard: some View {
        HStack(spacing: Spacing.md) {
            ZStack {
                RoundedRectangle(cornerRadius: Spacing.CornerRadius.small)
                    .fill(fileIconColor.opacity(0.12))
                    .frame(width: 52, height: 52)

                Image(systemName: fileIcon)
                    .font(.system(size: 26, weight: .semibold))
                    .foregroundStyle(fileIconColor)
            }

            VStack(alignment: .leading, spacing: Spacing.xs) {
                Text(sourceURL.lastPathComponent)
                    .font(.dsHeadline)
                    .foregroundStyle(Color.dsTextPrimary)
                    .lineLimit(2)

                if !fileSize.isEmpty {
                    Text(fileSize)
                        .font(.dsCaption1)
                        .foregroundStyle(Color.dsTextSecondary)
                }
            }

            Spacer(minLength: 0)
        }
        .padding(Spacing.md)
        .cardStyle()
        .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
    }

    // MARK: - Explanation Card

    private var explanationCard: some View {
        HStack(alignment: .top, spacing: Spacing.sm) {
            Image(systemName: "info.circle.fill")
                .font(.system(size: 16))
                .foregroundStyle(Color.dsPrimary)
                .padding(.top, 1)

            Text(String(localized: "convert_to_pdf.explanation"))
                .font(.dsBody)
                .foregroundStyle(Color.dsTextSecondary)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(Spacing.md)
        .cardStyle()
    }

    // MARK: - Unsupported Type Notice

    private var unsupportedTypeNotice: some View {
        HStack(alignment: .top, spacing: Spacing.sm) {
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.system(size: 16))
                .foregroundStyle(Color.dsWarning)
                .padding(.top, 1)

            Text(String(localized: "convert_to_pdf.unsupported_type"))
                .font(.dsBody)
                .foregroundStyle(Color.dsTextSecondary)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(Spacing.md)
        .background(Color.dsWarning.opacity(0.08))
        .clipShape(RoundedRectangle(cornerRadius: Spacing.CornerRadius.card))
    }

    // MARK: - Convert Button

    private var convertButton: some View {
        Button {
            guard !isProcessing else { return }
            performConversion()
        } label: {
            ZStack {
                if isProcessing {
                    HStack(spacing: Spacing.sm) {
                        ProgressView()
                            .tint(.white)
                        Text(String(localized: "convert_to_pdf.converting"))
                            .font(.dsHeadline)
                            .foregroundStyle(.white)
                    }
                } else {
                    HStack(spacing: Spacing.sm) {
                        Image(systemName: "arrow.right.doc.on.clipboard")
                            .font(.system(size: 18, weight: .semibold))
                        Text(String(localized: "convert_to_pdf.button_title"))
                            .font(.dsHeadline)
                    }
                    .foregroundStyle(.white)
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 52)
            .background(
                Group {
                    if isSupportedType && !isProcessing {
                        LinearGradient(
                            colors: [Color.dsPrimary, Color.dsPrimaryDark],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    } else {
                        LinearGradient(
                            colors: [Color.dsTextTertiary, Color.dsTextTertiary],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    }
                }
            )
            .clipShape(RoundedRectangle(cornerRadius: Spacing.CornerRadius.button))
            .shadow(
                color: (isSupportedType && !isProcessing) ? Color.dsPrimary.opacity(0.35) : .clear,
                radius: 8,
                x: 0,
                y: 4
            )
        }
        .buttonStyle(.plain)
        .disabled(!isSupportedType || isProcessing)
        .animation(.easeInOut(duration: 0.2), value: isProcessing)
    }

    // MARK: - Actions

    private func computeFileSize() {
        guard let resourceValues = try? sourceURL.resourceValues(forKeys: [.fileSizeKey]),
              let bytes = resourceValues.fileSize else {
            fileSize = ""
            return
        }
        fileSize = ByteCountFormatter.string(fromByteCount: Int64(bytes), countStyle: .file)
    }

    private func performConversion() {
        isProcessing = true
        Task { @MainActor in
            defer { isProcessing = false }
            do {
                let pdfDocument = try await PDFToolsService.shared.convertToPDF(fileURL: sourceURL)
                let saved = try appEnvironment.documentStore.save(
                    pdfDocument: pdfDocument,
                    name: outputName
                )
                resultDocument = saved
                navigateToViewer = true
            } catch let documentError as DocumentError {
                errorMessage = documentError.errorDescription
                    ?? String(localized: "error.conversion_failed")
                showError = true
            } catch {
                errorMessage = error.localizedDescription
                showError = true
            }
        }
    }
}
