import SwiftUI
import PDFKit

// MARK: - ViewerSource

enum ViewerSource {
    case processed(PDFDocument, suggestedName: String)
    case saved(DocuScanDocument)
}

// MARK: - DocumentViewerView

struct DocumentViewerView: View {

    @EnvironmentObject var appEnvironment: AppEnvironment

    let source: ViewerSource

    @State private var isSaved: Bool = false
    @State private var isSaving: Bool = false
    @State private var showSavedOverlay: Bool = false
    @State private var errorMessage: String?
    @State private var isShowingError: Bool = false
    @State private var isShowingShareSheet: Bool = false
    @State private var shareURL: URL?

    private var navigationTitle: String {
        switch source {
        case .processed(_, let name):
            return name
        case .saved(let doc):
            return doc.name
        }
    }

    private var pdfDocument: PDFDocument? {
        switch source {
        case .processed(let pdf, _):
            return pdf
        case .saved(let doc):
            return PDFDocument(url: doc.url)
        }
    }

    private var isProcessedSource: Bool {
        if case .processed = source { return true }
        return false
    }

    var body: some View {
        ZStack {
            Color.dsBackground.ignoresSafeArea()

            if let pdf = pdfDocument {
                PDFViewRepresentable(document: pdf)
                    .ignoresSafeArea(edges: .bottom)
            } else {
                unavailableView
            }

            if showSavedOverlay {
                savedConfirmationOverlay
            }
        }
        .navigationTitle(navigationTitle)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar { toolbarContent }
        .alert(
            String(localized: "error.title"),
            isPresented: $isShowingError,
            presenting: errorMessage
        ) { _ in
            Button(String(localized: "button.ok")) {
                isShowingError = false
            }
        } message: { msg in
            Text(msg)
        }
        .sheet(isPresented: $isShowingShareSheet) {
            if let url = shareURL {
                ShareSheet(activityItems: [url])
                    .ignoresSafeArea()
            }
        }
    }

    // MARK: Unavailable placeholder

    private var unavailableView: some View {
        VStack(spacing: Spacing.md) {
            Image(systemName: "doc.fill.badge.ellipsis")
                .font(.system(size: 56))
                .foregroundStyle(Color.dsTextTertiary)
            Text(String(localized: "viewer.document_unavailable"))
                .font(.dsHeadline)
                .foregroundStyle(Color.dsTextSecondary)
                .multilineTextAlignment(.center)
        }
        .padding(Spacing.xl)
    }

    // MARK: Saved confirmation overlay

    private var savedConfirmationOverlay: some View {
        VStack {
            Spacer()
            HStack(spacing: Spacing.sm) {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundStyle(Color.dsSuccess)
                Text(String(localized: "viewer.saved_confirmation"))
                    .font(.dsHeadline)
                    .foregroundStyle(Color.dsTextPrimary)
            }
            .padding(.horizontal, Spacing.lg)
            .padding(.vertical, Spacing.md)
            .background(Color.dsSurface)
            .clipShape(RoundedRectangle(cornerRadius: Spacing.CornerRadius.card))
            .shadow(color: Color.black.opacity(0.12), radius: 12, x: 0, y: 4)
            .padding(.bottom, Spacing.xl)
        }
        .transition(.move(edge: .bottom).combined(with: .opacity))
        .animation(.spring(response: 0.4, dampingFraction: 0.75), value: showSavedOverlay)
    }

    // MARK: Toolbar

    @ToolbarContentBuilder
    private var toolbarContent: some ToolbarContent {
        ToolbarItemGroup(placement: .navigationBarTrailing) {
            if isProcessedSource && !isSaved {
                Button {
                    saveDocument()
                } label: {
                    if isSaving {
                        ProgressView()
                            .tint(Color.dsPrimary)
                    } else {
                        Label(
                            String(localized: "viewer.toolbar.save"),
                            systemImage: "square.and.arrow.down"
                        )
                        .foregroundStyle(Color.dsPrimary)
                    }
                }
                .disabled(isSaving)
            }

            Button {
                prepareShare()
            } label: {
                Label(
                    String(localized: "viewer.toolbar.share"),
                    systemImage: "square.and.arrow.up"
                )
                .foregroundStyle(Color.dsPrimary)
            }
        }
    }

    // MARK: Actions

    private func saveDocument() {
        guard case .processed(let pdf, let name) = source else { return }
        isSaving = true
        Task { @MainActor in
            do {
                _ = try appEnvironment.documentStore.save(pdfDocument: pdf, name: name)
                isSaved = true
                withAnimation {
                    showSavedOverlay = true
                }
                try? await Task.sleep(nanoseconds: 2_500_000_000)
                withAnimation {
                    showSavedOverlay = false
                }
            } catch {
                errorMessage = error.localizedDescription
                isShowingError = true
            }
            isSaving = false
        }
    }

    private func prepareShare() {
        switch source {
        case .processed(let pdf, let name):
            let tempURL = FileManager.default.temporaryDirectory
                .appendingPathComponent("\(name).pdf")
            guard let data = pdf.dataRepresentation() else { return }
            try? data.write(to: tempURL)
            shareURL = tempURL
            isShowingShareSheet = true
        case .saved(let doc):
            shareURL = doc.url
            isShowingShareSheet = true
        }
    }
}

// MARK: - PDFViewRepresentable

struct PDFViewRepresentable: UIViewRepresentable {

    let document: PDFDocument

    func makeUIView(context: Context) -> PDFView {
        let pdfView = PDFView()
        pdfView.autoScales = true
        pdfView.displayMode = .singlePageContinuous
        pdfView.displayDirection = .vertical
        pdfView.backgroundColor = UIColor(Color.dsBackground)
        pdfView.document = document
        return pdfView
    }

    func updateUIView(_ uiView: PDFView, context: Context) {
        if uiView.document !== document {
            uiView.document = document
        }
    }
}

// MARK: - ShareSheet

private struct ShareSheet: UIViewControllerRepresentable {

    let activityItems: [Any]

    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}
