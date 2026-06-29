import SwiftUI
import PDFKit

// MARK: - ExtractPagesToolView

// swiftlint:disable:next type_body_length
struct ExtractPagesToolView: View {

    // MARK: Inputs

    let sourceURL: URL

    // MARK: Environment

    @EnvironmentObject var appEnvironment: AppEnvironment

    // MARK: State

    @State private var pageText: String = ""
    @State private var pageCount: Int = 0
    @State private var extractCount: Int = 0
    @State private var isProcessing: Bool = false
    @State private var resultDocument: DocuScanDocument?
    @State private var parseError: String?
    @State private var operationError: String?
    @State private var isShowingError: Bool = false
    @State private var navigateToResult: Bool = false

    // MARK: Computed

    private var fileName: String { sourceURL.deletingPathExtension().lastPathComponent }

    private var parsedIndices: [Int]? {
        let indices = Self.parsePageInput(pageText, pageCount: pageCount)
        return indices.isEmpty ? nil : indices
    }

    private var isExtractDisabled: Bool {
        parsedIndices == nil || isProcessing
    }

    // MARK: Body

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: Spacing.lg) {
                    sourceInfoCard
                    inputSection
                    summaryRow
                    extractButton
                }
                .padding(.horizontal, Spacing.md)
                .padding(.top, Spacing.md)
                .padding(.bottom, Spacing.xl)
            }
            .background(Color.dsBackground)
            .navigationTitle(String(localized: "extract_pages.nav_title"))
            .navigationBarTitleDisplayMode(.inline)
            .alert(
                String(localized: "error.title"),
                isPresented: $isShowingError,
                presenting: operationError
            ) { _ in
                Button(String(localized: "button.ok")) {
                    isShowingError = false
                }
            } message: { msg in
                Text(msg)
            }
            .navigationDestination(isPresented: $navigateToResult) {
                if let doc = resultDocument {
                    DocumentViewerView(source: .saved(doc))
                }
            }
        }
        .task {
            await loadPageCount()
        }
        .onChange(of: pageText) { _ in
            updateExtractCount()
        }
        .withAdBanner()
    }

    // MARK: - Source Info Card

    private var sourceInfoCard: some View {
        HStack(spacing: Spacing.md) {
            ZStack {
                RoundedRectangle(cornerRadius: Spacing.CornerRadius.small)
                    .fill(Color.dsAccent.opacity(0.12))
                    .frame(width: 48, height: 56)
                VStack(spacing: 2) {
                    Image(systemName: "doc.on.doc.fill")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundStyle(Color.dsAccent)
                    Text("PDF")
                        .font(.dsCaption2)
                        .fontWeight(.bold)
                        .foregroundStyle(Color.dsAccent)
                }
            }

            VStack(alignment: .leading, spacing: Spacing.xs) {
                Text(fileName)
                    .font(.dsSubheadline)
                    .fontWeight(.semibold)
                    .foregroundStyle(Color.dsTextPrimary)
                    .lineLimit(2)

                if pageCount > 0 {
                    Text(
                        String(
                            localized: "extract_pages.page_count_label",
                            defaultValue: "\(pageCount) pages total"
                        )
                    )
                    .font(.dsCaption1)
                    .foregroundStyle(Color.dsTextSecondary)
                } else {
                    Text(String(localized: "extract_pages.loading_pages"))
                        .font(.dsCaption1)
                        .foregroundStyle(Color.dsTextTertiary)
                }
            }

            Spacer(minLength: 0)
        }
        .padding(Spacing.md)
        .cardStyle()
    }

    // MARK: - Input Section

    private var inputSection: some View {
        VStack(alignment: .leading, spacing: Spacing.sm) {
            Text(String(localized: "extract_pages.input_section_title"))
                .font(.dsHeadline)
                .foregroundStyle(Color.dsTextPrimary)

            Text(String(localized: "extract_pages.input_hint"))
                .font(.dsCaption1)
                .foregroundStyle(Color.dsTextSecondary)

            TextField(
                String(localized: "extract_pages.input_placeholder"),
                text: $pageText
            )
            .font(.dsBody)
            .keyboardType(.numbersAndPunctuation)
            .autocorrectionDisabled(true)
            .padding(Spacing.md)
            .background(Color.dsSurface)
            .clipShape(RoundedRectangle(cornerRadius: Spacing.CornerRadius.button))
            .overlay(
                RoundedRectangle(cornerRadius: Spacing.CornerRadius.button)
                    .stroke(
                        parseError != nil ? Color.dsError : Color.dsSeparator,
                        lineWidth: 1
                    )
            )

            if let parseError {
                Text(parseError)
                    .font(.dsCaption1)
                    .foregroundStyle(Color.dsError)
            }
        }
    }

    // MARK: - Summary Row

    private var summaryRow: some View {
        Group {
            if extractCount > 0 {
                HStack(spacing: Spacing.sm) {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundStyle(Color.dsSuccess)
                        .font(.system(size: 16))

                    Text(
                        String(
                            localized: "extract_pages.summary_label",
                            defaultValue: "\(extractCount) page\(extractCount == 1 ? "" : "s") will be extracted"
                        )
                    )
                    .font(.dsSubheadline)
                    .foregroundStyle(Color.dsTextPrimary)

                    Spacer(minLength: 0)
                }
                .padding(Spacing.md)
                .background(Color.dsSuccess.opacity(0.08))
                .clipShape(RoundedRectangle(cornerRadius: Spacing.CornerRadius.card))
                .overlay(
                    RoundedRectangle(cornerRadius: Spacing.CornerRadius.card)
                        .stroke(Color.dsSuccess.opacity(0.2), lineWidth: 1)
                )
            }
        }
    }

    // MARK: - Extract Button

    private var extractButton: some View {
        Button {
            performExtract()
        } label: {
            HStack(spacing: Spacing.sm) {
                if isProcessing {
                    ProgressView()
                        .progressViewStyle(.circular)
                        .tint(.white)
                        .scaleEffect(0.85)
                } else {
                    Image(systemName: "doc.on.doc.fill")
                        .font(.system(size: 16, weight: .semibold))
                }
                Text(
                    isProcessing
                        ? String(localized: "extract_pages.button_processing")
                        : String(localized: "extract_pages.button_extract")
                )
                .font(.dsHeadline)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 52)
            .background {
                if isExtractDisabled {
                    Color.dsPrimary.opacity(0.4)
                } else {
                    LinearGradient(
                        colors: [Color.dsAccent, Color.dsAccent.opacity(0.85)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                }
            }
            .foregroundStyle(.white)
            .clipShape(RoundedRectangle(cornerRadius: Spacing.CornerRadius.button))
            .shadow(
                color: isExtractDisabled ? .clear : Color.dsAccent.opacity(0.35),
                radius: 8,
                x: 0,
                y: 4
            )
        }
        .buttonStyle(.plain)
        .disabled(isExtractDisabled)
        .animation(.easeInOut(duration: 0.2), value: isExtractDisabled)
    }

    // MARK: - Actions

    private func loadPageCount() async {
        let url = sourceURL
        let count = await Task.detached(priority: .userInitiated) {
            PDFDocument(url: url)?.pageCount ?? 0
        }.value
        pageCount = count
        updateExtractCount()
    }

    private func updateExtractCount() {
        guard pageCount > 0 else {
            extractCount = 0
            parseError = nil
            return
        }
        let trimmed = pageText.trimmingCharacters(in: .whitespaces)
        guard !trimmed.isEmpty else {
            extractCount = 0
            parseError = nil
            return
        }
        let indices = Self.parsePageInput(pageText, pageCount: pageCount)
        if indices.isEmpty && !trimmed.isEmpty {
            parseError = String(localized: "extract_pages.parse_error")
            extractCount = 0
        } else {
            parseError = nil
            extractCount = indices.count
        }
    }

    private func performExtract() {
        guard let indices = parsedIndices, !indices.isEmpty else { return }
        isProcessing = true
        let url = sourceURL
        let store = appEnvironment.documentStore

        Task { @MainActor in
            do {
                let pdf = try await PDFToolsService.shared.extractPages(pdf: url, pageIndices: indices)
                let saved = try store.save(pdfDocument: pdf, name: "Extracted_Pages")
                resultDocument = saved
                navigateToResult = true
            } catch {
                operationError = error.localizedDescription
                isShowingError = true
            }
            isProcessing = false
        }
    }

    // MARK: - Page Input Parser

    /// Parses a human-readable page string like "1, 3, 5-7" (1-indexed) into
    /// sorted unique 0-indexed page indices, clamped to [0, pageCount).
    static func parsePageInput(_ input: String, pageCount: Int) -> [Int] {
        guard pageCount > 0 else { return [] }
        var result = Set<Int>()
        let tokens = input.split(separator: ",").map { $0.trimmingCharacters(in: .whitespaces) }
        for token in tokens {
            if token.contains("-") {
                let parts = token.split(separator: "-", maxSplits: 1).map {
                    $0.trimmingCharacters(in: .whitespaces)
                }
                guard parts.count == 2,
                      let lower = Int(parts[0]),
                      let upper = Int(parts[1]),
                      lower >= 1, upper >= lower else { continue }
                let clampedLo = max(1, lower)
                let clampedHi = min(pageCount, upper)
                guard clampedLo <= clampedHi else { continue }
                for page in clampedLo...clampedHi {
                    result.insert(page - 1)
                }
            } else if let page = Int(token), page >= 1, page <= pageCount {
                result.insert(page - 1)
            }
        }
        return result.sorted()
    }
}
