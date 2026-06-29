import SwiftUI
import UniformTypeIdentifiers

struct MergeToolView: View {

    // MARK: - Environment

    @EnvironmentObject var appEnvironment: AppEnvironment

    // MARK: - State

    @State private var urls: [URL]
    @State private var isProcessing = false
    @State private var errorMessage: String?
    @State private var isShowingError = false
    @State private var isShowingFilePicker = false
    @State private var resultDocument: DocuScanDocument?
    @State private var navigateToResult = false

    // MARK: - Init

    init(initialURLs: [URL]) {
        _urls = State(initialValue: initialURLs)
    }

    // MARK: - Body

    var body: some View {
        ZStack {
            contentView

            if isProcessing {
                processingOverlay
            }
        }
        .navigationTitle(String(localized: "merge.navigation_title"))
        .navigationBarTitleDisplayMode(.inline)
        .fileImporter(
            isPresented: $isShowingFilePicker,
            allowedContentTypes: [UTType.pdf],
            allowsMultipleSelection: true
        ) { result in
            handleFileImport(result)
        }
        .alert(
            String(localized: "error.title"),
            isPresented: $isShowingError,
            presenting: errorMessage
        ) { _ in
            Button(String(localized: "button.ok")) {
                isShowingError = false
            }
        } message: { message in
            Text(message)
        }
        .background(
            NavigationLink(
                isActive: $navigateToResult,
                destination: { destinationView },
                label: { EmptyView() }
            )
            .hidden()
        )
        .task {}
    }

    // MARK: - Destination

    @ViewBuilder
    private var destinationView: some View {
        if let doc = resultDocument {
            DocumentViewerView(source: .saved(doc))
        } else {
            EmptyView()
        }
    }

    // MARK: - Content

    private var contentView: some View {
        VStack(spacing: 0) {
            fileCountHeader
            fileList
            Spacer(minLength: 0)
            bottomActions
        }
        .background(Color.dsBackground)
    }

    // MARK: - File Count Header

    private var fileCountHeader: some View {
        HStack {
            Text(
                urls.count == 1
                    ? String(localized: "merge.file_count_singular")
                    : String(localized: "merge.file_count_plural \(urls.count)")
            )
            .font(.dsSubheadline)
            .foregroundStyle(Color.dsTextSecondary)
            Spacer()
        }
        .padding(.horizontal, Spacing.md)
        .padding(.vertical, Spacing.sm)
    }

    // MARK: - File List

    private var fileList: some View {
        List {
            ForEach(urls, id: \.absoluteString) { url in
                fileRow(url: url)
            }
            .onDelete(perform: deleteFiles)

            addMoreButton
                .listRowInsets(EdgeInsets())
                .listRowBackground(Color.clear)
                .listRowSeparator(.hidden)
                .padding(.horizontal, Spacing.md)
                .padding(.vertical, Spacing.sm)
        }
        .listStyle(.plain)
        .scrollContentBackground(.hidden)
        .background(Color.dsBackground)
    }

    private func fileRow(url: URL) -> some View {
        HStack(spacing: Spacing.md) {
            ZStack {
                RoundedRectangle(cornerRadius: Spacing.CornerRadius.small)
                    .fill(Color.dsPrimary.opacity(0.12))
                    .frame(width: 40, height: 40)
                Image(systemName: "doc.fill")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundStyle(Color.dsPrimary)
            }
            VStack(alignment: .leading, spacing: Spacing.xs) {
                Text(url.lastPathComponent)
                    .font(.dsBody)
                    .foregroundStyle(Color.dsTextPrimary)
                    .lineLimit(1)
                Text(url.pathExtension.uppercased())
                    .font(.dsCaption1)
                    .foregroundStyle(Color.dsTextSecondary)
            }
            Spacer()
            Image(systemName: "line.3.horizontal")
                .font(.system(size: 14, weight: .medium))
                .foregroundStyle(Color.dsTextTertiary)
        }
        .padding(.vertical, Spacing.xs)
    }

    private var addMoreButton: some View {
        Button {
            isShowingFilePicker = true
        } label: {
            HStack(spacing: Spacing.sm) {
                Image(systemName: "plus.circle.fill")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundStyle(Color.dsPrimary)
                Text(String(localized: "merge.add_more_pdfs"))
                    .font(.dsHeadline)
                    .foregroundStyle(Color.dsPrimary)
                Spacer()
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, Spacing.sm)
            .padding(.horizontal, Spacing.md)
            .background(Color.dsPrimary.opacity(0.08))
            .clipShape(RoundedRectangle(cornerRadius: Spacing.CornerRadius.card))
            .overlay(
                RoundedRectangle(cornerRadius: Spacing.CornerRadius.card)
                    .stroke(Color.dsPrimary.opacity(0.2), lineWidth: 1)
            )
        }
        .buttonStyle(.plain)
    }

    // MARK: - Bottom Actions

    private var bottomActions: some View {
        VStack(spacing: Spacing.sm) {
            Divider()
                .background(Color.dsSeparator)

            Button {
                performMerge()
            } label: {
                HStack(spacing: Spacing.sm) {
                    Image(systemName: "arrow.triangle.merge")
                        .font(.system(size: 16, weight: .semibold))
                    Text(String(localized: "merge.merge_button"))
                        .font(.dsHeadline)
                }
                .frame(maxWidth: .infinity)
                .frame(height: 50)
                .background(urls.count < 2 ? Color.dsPrimary.opacity(0.4) : Color.dsPrimary)
                .foregroundStyle(.white)
                .clipShape(RoundedRectangle(cornerRadius: Spacing.CornerRadius.button))
            }
            .buttonStyle(.plain)
            .disabled(urls.count < 2 || isProcessing)
            .padding(.horizontal, Spacing.md)
            .padding(.bottom, Spacing.md)
        }
    }

    // MARK: - Processing Overlay

    private var processingOverlay: some View {
        ZStack {
            Color.black.opacity(0.4)
                .ignoresSafeArea()
            VStack(spacing: Spacing.md) {
                ProgressView()
                    .progressViewStyle(.circular)
                    .tint(.white)
                    .scaleEffect(1.4)
                Text(String(localized: "merge.processing"))
                    .font(.dsBody)
                    .foregroundStyle(.white)
            }
            .padding(Spacing.xl)
            .background(Color.dsSurface.opacity(0.95))
            .clipShape(RoundedRectangle(cornerRadius: Spacing.CornerRadius.card))
            .shadow(color: Color.black.opacity(0.2), radius: 16, x: 0, y: 8)
        }
    }

    // MARK: - Actions

    private func deleteFiles(at offsets: IndexSet) {
        urls.remove(atOffsets: offsets)
    }

    private func handleFileImport(_ result: Result<[URL], Error>) {
        switch result {
        case .success(let importedURLs):
            let newURLs = importedURLs.filter { new in
                !urls.contains(where: { $0.absoluteString == new.absoluteString })
            }
            urls.append(contentsOf: newURLs)
        case .failure(let error):
            errorMessage = error.localizedDescription
            isShowingError = true
        }
    }

    private func performMerge() {
        guard urls.count >= 2 else { return }
        isProcessing = true
        let urlsToMerge = urls
        let store = appEnvironment.documentStore
        Task { @MainActor in
            do {
                let merged = try await PDFToolsService.shared.merge(pdfs: urlsToMerge)
                let saved = try store.save(pdfDocument: merged, name: "Merged_PDF")
                resultDocument = saved
                isProcessing = false
                navigateToResult = true
            } catch {
                isProcessing = false
                errorMessage = error.localizedDescription
                isShowingError = true
            }
        }
    }
}
