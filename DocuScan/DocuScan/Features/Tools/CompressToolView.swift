import SwiftUI
import PDFKit

// MARK: - CompressToolView

// swiftlint:disable:next type_body_length
struct CompressToolView: View {

    // MARK: Inputs

    let url: URL

    // MARK: Environment

    @EnvironmentObject var appEnvironment: AppEnvironment

    // MARK: State

    @State private var quality: CompressionQuality = .medium
    @State private var isProcessing = false
    @State private var resultDocument: DocuScanDocument?
    @State private var originalSize: Int64 = 0
    @State private var compressedSize: Int64 = 0
    @State private var errorMessage: String?
    @State private var showError = false
    @State private var showShareSheet = false
    @State private var shareItem: URL?

    // MARK: Computed

    private var documentStore: DocumentStore { appEnvironment.documentStore }

    private var fileName: String { url.deletingPathExtension().lastPathComponent }

    private var formattedOriginalSize: String {
        ByteCountFormatter.string(fromByteCount: originalSize, countStyle: .file)
    }

    private var formattedCompressedSize: String {
        ByteCountFormatter.string(fromByteCount: compressedSize, countStyle: .file)
    }

    private var savingsPercent: Int {
        guard originalSize > 0 else { return 0 }
        let saved = originalSize - compressedSize
        return max(0, Int(Double(saved) / Double(originalSize) * 100))
    }

    // MARK: Body

    var body: some View {
        ScrollView {
            VStack(spacing: Spacing.lg) {
                fileInfoCard
                qualityPickerSection
                if resultDocument != nil {
                    resultCard
                    actionButtons
                } else {
                    compressButton
                }
            }
            .padding(.horizontal, Spacing.md)
            .padding(.top, Spacing.md)
            .padding(.bottom, Spacing.xl)
        }
        .background(Color.dsBackground)
        .navigationTitle(String(localized: "compress.nav_title"))
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await loadOriginalFileSize()
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
        .sheet(isPresented: $showShareSheet) {
            if let shareItem {
                ShareSheet(url: shareItem)
            }
        }
    }

    // MARK: File Info Card

    private var fileInfoCard: some View {
        HStack(spacing: Spacing.md) {
            ZStack {
                RoundedRectangle(cornerRadius: Spacing.CornerRadius.small)
                    .fill(Color.dsPrimary.opacity(0.10))
                    .frame(width: 48, height: 56)

                VStack(spacing: 2) {
                    Image(systemName: "doc.fill")
                        .font(.system(size: 22, weight: .medium))
                        .foregroundStyle(Color.dsPrimary)
                    Text("PDF")
                        .font(.dsCaption2)
                        .fontWeight(.bold)
                        .foregroundStyle(Color.dsPrimary)
                }
            }

            VStack(alignment: .leading, spacing: Spacing.xs) {
                Text(fileName)
                    .font(.dsSubheadline)
                    .fontWeight(.semibold)
                    .foregroundStyle(Color.dsTextPrimary)
                    .lineLimit(2)

                Text(formattedOriginalSize)
                    .font(.dsCaption1)
                    .foregroundStyle(Color.dsTextSecondary)
            }

            Spacer(minLength: 0)
        }
        .padding(Spacing.md)
        .cardStyle()
    }

    // MARK: Quality Picker Section

    private var qualityPickerSection: some View {
        VStack(alignment: .leading, spacing: Spacing.sm) {
            Text(String(localized: "compress.quality_label"))
                .font(.dsHeadline)
                .foregroundStyle(Color.dsTextPrimary)

            Picker(String(localized: "compress.quality_label"), selection: $quality) {
                Text(String(localized: "compress.quality.low")).tag(CompressionQuality.low)
                Text(String(localized: "compress.quality.medium")).tag(CompressionQuality.medium)
                Text(String(localized: "compress.quality.high")).tag(CompressionQuality.high)
            }
            .pickerStyle(.segmented)

            Text(qualityDescription)
                .font(.dsCaption1)
                .foregroundStyle(Color.dsTextSecondary)
                .padding(.top, Spacing.xs)
        }
        .padding(Spacing.md)
        .cardStyle()
    }

    private var qualityDescription: String {
        switch quality {
        case .low:
            return String(localized: "compress.quality.low.description")
        case .medium:
            return String(localized: "compress.quality.medium.description")
        case .high:
            return String(localized: "compress.quality.high.description")
        }
    }

    // MARK: Compress Button

    private var compressButton: some View {
        Button {
            Task { @MainActor in
                await performCompression()
            }
        } label: {
            HStack(spacing: Spacing.sm) {
                if isProcessing {
                    ProgressView()
                        .tint(.white)
                        .scaleEffect(0.85)
                } else {
                    Image(systemName: "archivebox.fill")
                        .font(.system(size: 16, weight: .semibold))
                }
                Text(
                    isProcessing
                        ? String(localized: "compress.processing")
                        : String(localized: "compress.button")
                )
                .font(.dsHeadline)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 52)
            .background {
                if isProcessing {
                    Color.dsPrimary.opacity(0.6)
                } else {
                    LinearGradient(
                        colors: [Color.dsPrimary, Color.dsPrimaryDark],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                }
            }
            .foregroundStyle(.white)
            .clipShape(RoundedRectangle(cornerRadius: Spacing.CornerRadius.button))
            .shadow(color: Color.dsPrimary.opacity(isProcessing ? 0 : 0.35), radius: 8, x: 0, y: 4)
        }
        .buttonStyle(.plain)
        .disabled(isProcessing)
    }

    // MARK: Result Card

    private var resultCard: some View {
        VStack(spacing: Spacing.md) {
            HStack {
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 22))
                    .foregroundStyle(Color.dsSuccess)
                Text(String(localized: "compress.result.title"))
                    .font(.dsHeadline)
                    .foregroundStyle(Color.dsTextPrimary)
                Spacer(minLength: 0)
            }

            Divider()

            HStack(spacing: 0) {
                sizeColumn(
                    label: String(localized: "compress.result.before"),
                    value: formattedOriginalSize
                )

                Image(systemName: "arrow.right")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundStyle(Color.dsTextTertiary)
                    .frame(maxWidth: .infinity)

                sizeColumn(
                    label: String(localized: "compress.result.after"),
                    value: formattedCompressedSize
                )
            }

            if savingsPercent > 0 {
                HStack(spacing: Spacing.xs) {
                    Image(systemName: "arrow.down.circle.fill")
                        .font(.system(size: 13))
                        .foregroundStyle(Color.dsSuccess)
                    Text(
                        String(
                            localized: "compress.result.savings",
                            defaultValue: "Saved \(savingsPercent)%"
                        )
                    )
                    .font(.dsCaption1)
                    .fontWeight(.medium)
                    .foregroundStyle(Color.dsSuccess)
                }
                .padding(.horizontal, Spacing.sm)
                .padding(.vertical, Spacing.xs)
                .background(Color.dsSuccess.opacity(0.10))
                .clipShape(Capsule())
            }
        }
        .padding(Spacing.md)
        .cardStyle()
    }

    private func sizeColumn(label: String, value: String) -> some View {
        VStack(spacing: Spacing.xs) {
            Text(label)
                .font(.dsCaption1)
                .foregroundStyle(Color.dsTextSecondary)
            Text(value)
                .font(.dsSubheadline)
                .fontWeight(.semibold)
                .foregroundStyle(Color.dsTextPrimary)
        }
        .frame(maxWidth: .infinity)
    }

    // MARK: Action Buttons

    private var actionButtons: some View {
        VStack(spacing: Spacing.sm) {
            if let saved = resultDocument {
                NavigationLink(destination: DocumentViewerView(source: .saved(saved))) {
                    HStack(spacing: Spacing.sm) {
                        Image(systemName: "eye.fill")
                            .font(.system(size: 16, weight: .semibold))
                        Text(String(localized: "compress.action.view"))
                            .font(.dsHeadline)
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 52)
                    .background(
                        LinearGradient(
                            colors: [Color.dsPrimary, Color.dsPrimaryDark],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .foregroundStyle(.white)
                    .clipShape(RoundedRectangle(cornerRadius: Spacing.CornerRadius.button))
                    .shadow(color: Color.dsPrimary.opacity(0.35), radius: 8, x: 0, y: 4)
                }
                .buttonStyle(.plain)

                Button {
                    shareItem = saved.url
                    showShareSheet = true
                } label: {
                    HStack(spacing: Spacing.sm) {
                        Image(systemName: "square.and.arrow.up")
                            .font(.system(size: 16, weight: .semibold))
                        Text(String(localized: "compress.action.share"))
                            .font(.dsHeadline)
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 52)
                    .background(Color.dsSurface)
                    .foregroundStyle(Color.dsPrimary)
                    .clipShape(RoundedRectangle(cornerRadius: Spacing.CornerRadius.button))
                    .overlay(
                        RoundedRectangle(cornerRadius: Spacing.CornerRadius.button)
                            .stroke(Color.dsPrimary.opacity(0.3), lineWidth: 1)
                    )
                }
                .buttonStyle(.plain)
            }
        }
    }

    // MARK: - Async Helpers

    private func loadOriginalFileSize() async {
        guard let values = try? url.resourceValues(forKeys: [.fileSizeKey]),
              let size = values.fileSize else { return }
        originalSize = Int64(size)
    }

    private func performCompression() async {
        isProcessing = true
        errorMessage = nil
        defer { isProcessing = false }

        do {
            let compressed = try await PDFToolsService.shared.compress(pdf: url, quality: quality)

            let saveName = "Compressed_\(fileName)"
            let saved = try documentStore.save(pdfDocument: compressed, name: saveName)

            if let values = try? saved.url.resourceValues(forKeys: [.fileSizeKey]),
               let size = values.fileSize {
                compressedSize = Int64(size)
            }

            resultDocument = saved
        } catch {
            errorMessage = error.localizedDescription
            showError = true
        }
    }
}

// MARK: - ShareSheet

private struct ShareSheet: UIViewControllerRepresentable {
    let url: URL

    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: [url], applicationActivities: nil)
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}
