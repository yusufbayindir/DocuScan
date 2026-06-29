// swiftlint:disable file_length
import SwiftUI
import PDFKit

// MARK: - SplitToolView

// swiftlint:disable:next type_body_length
struct SplitToolView: View {

    // MARK: Input

    let sourceURL: URL

    // MARK: Environment

    @EnvironmentObject var appEnvironment: AppEnvironment

    // MARK: State

    @State private var rangeText: String = ""
    @State private var savedParts: [DocuScanDocument] = []
    @State private var isProcessing: Bool = false
    @State private var parseError: String?
    @State private var operationError: String?
    @State private var isShowingError: Bool = false
    @State private var shareItem: DocuScanDocument?
    @State private var isShowingShareSheet: Bool = false
    @State private var pageCount: Int = 0

    // MARK: Computed

    private var fileName: String { sourceURL.lastPathComponent }

    private var splitButtonDisabled: Bool {
        rangeText.trimmingCharacters(in: .whitespaces).isEmpty || parseError != nil || isProcessing
    }

    // MARK: Body

    var body: some View {
        ZStack {
            ScrollView {
                VStack(alignment: .leading, spacing: Spacing.lg) {
                    sourceInfoCard
                    rangeInputCard
                    if !savedParts.isEmpty {
                        savedPartsSection
                    }
                }
                .padding(.horizontal, Spacing.md)
                .padding(.top, Spacing.md)
                .padding(.bottom, Spacing.xl)
            }
            .background(Color.dsBackground)

            if isProcessing {
                processingOverlay
            }
        }
        .navigationTitle(String(localized: "split_tool.nav_title"))
        .navigationBarTitleDisplayMode(.inline)
        .alert(
            String(localized: "error.title"),
            isPresented: $isShowingError,
            presenting: operationError
        ) { _ in
            Button(String(localized: "button.ok")) { isShowingError = false }
        } message: { msg in
            Text(msg)
        }
        .sheet(isPresented: $isShowingShareSheet) {
            if let doc = shareItem {
                ShareSheet(activityItems: [doc.url])
            }
        }
        .task {
            await loadPageCount()
        }
    }

    // MARK: Source Info Card

    private var sourceInfoCard: some View {
        VStack(alignment: .leading, spacing: Spacing.sm) {
            Label(String(localized: "split_tool.source_file_label"), systemImage: "doc.fill")
                .font(.dsCaption1)
                .foregroundStyle(Color.dsTextSecondary)

            HStack(spacing: Spacing.md) {
                ZStack {
                    RoundedRectangle(cornerRadius: Spacing.CornerRadius.small)
                        .fill(Color.dsPrimary.opacity(0.12))
                        .frame(width: 44, height: 44)
                    Image(systemName: "scissors")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundStyle(Color.dsPrimary)
                }

                VStack(alignment: .leading, spacing: Spacing.xs) {
                    Text(fileName)
                        .font(.dsHeadline)
                        .foregroundStyle(Color.dsTextPrimary)
                        .lineLimit(2)

                    if pageCount > 0 {
                        Text("\(pageCount) pages")
                            .font(.dsCaption1)
                            .foregroundStyle(Color.dsTextSecondary)
                    } else {
                        Text(String(localized: "split_tool.loading_pages"))
                            .font(.dsCaption1)
                            .foregroundStyle(Color.dsTextTertiary)
                    }
                }

                Spacer()
            }
        }
        .padding(Spacing.md)
        .cardStyle()
    }

    // MARK: Range Input Card

    private var rangeInputCard: some View {
        VStack(alignment: .leading, spacing: Spacing.md) {
            Text(String(localized: "split_tool.range_section_title"))
                .font(.dsTitle3)
                .foregroundStyle(Color.dsTextPrimary)

            Text(String(localized: "split_tool.range_hint"))
                .font(.dsBody)
                .foregroundStyle(Color.dsTextSecondary)

            TextField(
                String(localized: "split_tool.range_placeholder"),
                text: $rangeText
            )
            .font(.dsBody)
            .keyboardType(.numbersAndPunctuation)
            .autocorrectionDisabled()
            .padding(Spacing.md)
            .background(Color.dsSurface)
            .clipShape(RoundedRectangle(cornerRadius: Spacing.CornerRadius.small))
            .overlay(
                RoundedRectangle(cornerRadius: Spacing.CornerRadius.small)
                    .stroke(parseError != nil ? Color.dsError : Color.dsSeparator, lineWidth: 1)
            )
            .onChange(of: rangeText) { newValue in
                validateRangeText(newValue)
            }

            if let error = parseError {
                HStack(spacing: Spacing.xs) {
                    Image(systemName: "exclamationmark.circle.fill")
                        .font(.dsCaption1)
                        .foregroundStyle(Color.dsError)
                    Text(error)
                        .font(.dsCaption1)
                        .foregroundStyle(Color.dsError)
                }
            }

            splitButton
        }
        .padding(Spacing.md)
        .cardStyle()
    }

    // MARK: Split Button

    private var splitButton: some View {
        Button {
            performSplit()
        } label: {
            HStack(spacing: Spacing.sm) {
                Image(systemName: "scissors")
                    .font(.system(size: 16, weight: .semibold))
                Text(String(localized: "split_tool.split_button"))
                    .font(.dsHeadline)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 50)
            .background {
                if splitButtonDisabled {
                    Color.dsPrimary.opacity(0.4)
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
        }
        .buttonStyle(.plain)
        .disabled(splitButtonDisabled)
    }

    // MARK: Saved Parts Section

    private var savedPartsSection: some View {
        VStack(alignment: .leading, spacing: Spacing.md) {
            HStack {
                Text(String(localized: "split_tool.results_title"))
                    .font(.dsTitle3)
                    .foregroundStyle(Color.dsTextPrimary)
                Spacer()
                Text("\(savedParts.count) parts")
                    .font(.dsCaption1)
                .foregroundStyle(Color.dsTextSecondary)
            }

            VStack(spacing: Spacing.sm) {
                ForEach(Array(savedParts.enumerated()), id: \.element.id) { index, doc in
                    savedPartRow(doc: doc, index: index + 1)
                }
            }
        }
    }

    private func savedPartRow(doc: DocuScanDocument, index: Int) -> some View {
        HStack(spacing: Spacing.md) {
            ZStack {
                Circle()
                    .fill(Color.dsPrimary.opacity(0.12))
                    .frame(width: 36, height: 36)
                Text("\(index)")
                    .font(.dsHeadline)
                    .foregroundStyle(Color.dsPrimary)
            }

            VStack(alignment: .leading, spacing: Spacing.xs) {
                Text(doc.name)
                    .font(.dsHeadline)
                    .foregroundStyle(Color.dsTextPrimary)
                    .lineLimit(1)

                HStack(spacing: Spacing.xs) {
                    Text("\(doc.pageCount) pages")
                        .font(.dsCaption1)
                        .foregroundStyle(Color.dsTextSecondary)

                    Text("·")
                        .font(.dsCaption1)
                        .foregroundStyle(Color.dsTextTertiary)

                    Text(doc.fileSizeString)
                        .font(.dsCaption1)
                        .foregroundStyle(Color.dsTextSecondary)
                }
            }

            Spacer()

            Button {
                shareItem = doc
                isShowingShareSheet = true
            } label: {
                Image(systemName: "square.and.arrow.up")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundStyle(Color.dsPrimary)
                    .frame(width: 36, height: 36)
                    .background(Color.dsPrimary.opacity(0.08))
                    .clipShape(Circle())
            }
            .buttonStyle(.plain)
        }
        .padding(Spacing.md)
        .cardStyle()
    }

    // MARK: Processing Overlay

    private var processingOverlay: some View {
        ZStack {
            Color.black.opacity(0.35)
                .ignoresSafeArea()

            VStack(spacing: Spacing.md) {
                ProgressView()
                    .progressViewStyle(.circular)
                    .tint(.white)
                    .scaleEffect(1.4)

                Text(String(localized: "split_tool.processing"))
                    .font(.dsHeadline)
                    .foregroundStyle(.white)
            }
            .padding(Spacing.xl)
            .background(.ultraThinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: Spacing.CornerRadius.card))
        }
    }

    // MARK: Actions

    private func loadPageCount() async {
        let url = sourceURL
        let count = await Task.detached(priority: .userInitiated) {
            PDFDocument(url: url)?.pageCount ?? 0
        }.value
        pageCount = count
    }

    private func validateRangeText(_ text: String) {
        let trimmed = text.trimmingCharacters(in: .whitespaces)
        guard !trimmed.isEmpty else {
            parseError = nil
            return
        }

        let result = parseRanges(from: trimmed, pageCount: pageCount)
        switch result {
        case .success:
            parseError = nil
        case .failure(let error):
            parseError = error.message
        }
    }

    private func performSplit() {
        let trimmed = rangeText.trimmingCharacters(in: .whitespaces)
        guard !trimmed.isEmpty else { return }

        let result = parseRanges(from: trimmed, pageCount: pageCount)
        guard case .success(let ranges) = result else {
            validateRangeText(trimmed)
            return
        }

        isProcessing = true
        let url = sourceURL
        let store = appEnvironment.documentStore

        Task { @MainActor in
            do {
                let parts = try await PDFToolsService.shared.split(pdf: url, ranges: ranges)
                var newDocs: [DocuScanDocument] = []
                for (index, pdfDoc) in parts.enumerated() {
                    let partName = "SplitPart_\(index + 1)"
                    let saved = try store.save(pdfDocument: pdfDoc, name: partName)
                    newDocs.append(saved)
                }
                savedParts = newDocs
                isProcessing = false
            } catch let docError as DocumentError {
                operationError = docError.errorDescription
                isShowingError = true
                isProcessing = false
            } catch {
                operationError = error.localizedDescription
                isShowingError = true
                isProcessing = false
            }
        }
    }
}

// MARK: - Range Parsing

private struct SplitParseError: LocalizedError {
    let message: String
    var errorDescription: String? { message }
}

// swiftlint:disable:next cyclomatic_complexity
private func parseRanges(
    from input: String,
    pageCount: Int
) -> Result<[ClosedRange<Int>], SplitParseError> {
    let tokens = input.split(separator: ",").map { $0.trimmingCharacters(in: .whitespaces) }
    guard !tokens.isEmpty else {
        return .failure(SplitParseError(message: String(localized: "split_tool.error.empty_input")))
    }

    var ranges: [ClosedRange<Int>] = []

    for token in tokens {
        if token.contains("-") {
            let parts = token.split(separator: "-", maxSplits: 1).map { $0.trimmingCharacters(in: .whitespaces) }
            guard parts.count == 2,
                  let lower = Int(parts[0]),
                  let upper = Int(parts[1]) else {
                return .failure(SplitParseError(message: "Invalid range: \(token)"))
            }
            guard lower >= 1 else {
                return .failure(SplitParseError(message: String(localized: "split_tool.error.page_below_one")))
            }
            guard lower <= upper else {
                return .failure(SplitParseError(message: "Start must be ≤ end in range: \(token)"))
            }
            if pageCount > 0, upper > pageCount {
                return .failure(SplitParseError(message: "Page \(upper) exceeds document length (\(pageCount) pages)"))
            }
            ranges.append((lower - 1)...(upper - 1))
        } else {
            guard let page = Int(token) else {
                return .failure(SplitParseError(message: "Not a valid page number: \(token)"))
            }
            guard page >= 1 else {
                return .failure(SplitParseError(message: String(localized: "split_tool.error.page_below_one")))
            }
            if pageCount > 0, page > pageCount {
                return .failure(SplitParseError(message: "Page \(page) exceeds document length (\(pageCount) pages)"))
            }
            ranges.append((page - 1)...(page - 1))
        }
    }

    guard !ranges.isEmpty else {
        return .failure(SplitParseError(message: String(localized: "split_tool.error.empty_input")))
    }

    return .success(ranges)
}

// MARK: - ShareSheet

private struct ShareSheet: UIViewControllerRepresentable {

    let activityItems: [Any]

    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}
