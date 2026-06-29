// swiftlint:disable file_length
import SwiftUI
import VisionKit
import UniformTypeIdentifiers

// MARK: - Tool Model

struct PDFTool: Identifiable {
    let id: UUID = UUID()
    let nameKey: String
    let descriptionKey: String
    let icon: String
    let color: Color
    let kind: ToolKind

    enum ToolKind {
        case merge
        case split
        case compress
        case rotate
        case scan
        case wordToPDF
        case excelToPDF
        case imagesToPDF
        case sign
        case protect
        case unlock
        case extractPages
    }
}

// MARK: - ToolDestination

enum ToolDestination: Hashable {
    case merge([URL])
    case split(URL)
    case compress(URL)
    case rotate(URL)
    case protect(URL)
    case unlock(URL)
    case extractPages(URL)
    case imagesToPDF([URL])
    case convertToPDF(URL)
    case documentViewer(DocuScanDocument)
}

// MARK: - ToolsViewModel

@MainActor
final class ToolsViewModel: ObservableObject {

    // MARK: State

    @Published var isShowingScanner = false
    @Published var isProcessingScan = false
    @Published var isShowingFilePicker = false
    @Published var filePickerPurpose: FilePickerPurpose = .importPDF
    @Published var errorMessage: String?
    @Published var isShowingError = false
    @Published var navigationPath = NavigationPath()
    @Published var pendingDestination: ToolDestination?

    // MARK: File picker purposes

    enum FilePickerPurpose {
        case importPDF
        case wordToPDF
        case excelToPDF
        case imagesToPDF
        case merge
        case compress
        case rotate
        case split
        case protect
        case unlock
        case sign
        case extractPages

        var allowedTypes: [UTType] {
            switch self {
            case .importPDF, .merge, .compress, .rotate,
                 .split, .protect, .unlock, .sign, .extractPages:
                return [.pdf]
            case .wordToPDF:
                let types: [UTType] = [
                    UTType("org.openxmlformats.wordprocessingml.document") ?? .data,
                    UTType("com.microsoft.word.doc") ?? .data,
                    .pdf
                ]
                return types
            case .excelToPDF:
                let types: [UTType] = [
                    UTType("org.openxmlformats.spreadsheetml.sheet") ?? .data,
                    UTType("com.microsoft.excel.xls") ?? .data,
                    .pdf
                ]
                return types
            case .imagesToPDF:
                return [.image]
            }
        }

        var allowsMultiple: Bool {
            switch self {
            case .merge, .imagesToPDF: return true
            default: return false
            }
        }
    }

    // MARK: All tools

    let tools: [PDFTool] = [
        PDFTool(
            nameKey: "tool.merge.name",
            descriptionKey: "tool.merge.description",
            icon: "arrow.triangle.merge",
            color: .dsPrimary,
            kind: .merge
        ),
        PDFTool(
            nameKey: "tool.split.name",
            descriptionKey: "tool.split.description",
            icon: "scissors",
            color: Color(hex: "#4B9FE1"),
            kind: .split
        ),
        PDFTool(
            nameKey: "tool.compress.name",
            descriptionKey: "tool.compress.description",
            icon: "archivebox.fill",
            color: Color(hex: "#34C759"),
            kind: .compress
        ),
        PDFTool(
            nameKey: "tool.rotate.name",
            descriptionKey: "tool.rotate.description",
            icon: "rotate.right.fill",
            color: Color(hex: "#FF9F0A"),
            kind: .rotate
        ),
        PDFTool(
            nameKey: "tool.scan.name",
            descriptionKey: "tool.scan.description",
            icon: "doc.viewfinder.fill",
            color: .dsAccent,
            kind: .scan
        ),
        PDFTool(
            nameKey: "tool.word_to_pdf.name",
            descriptionKey: "tool.word_to_pdf.description",
            icon: "doc.richtext.fill",
            color: Color(hex: "#185ABD"),
            kind: .wordToPDF
        ),
        PDFTool(
            nameKey: "tool.excel_to_pdf.name",
            descriptionKey: "tool.excel_to_pdf.description",
            icon: "tablecells.fill",
            color: Color(hex: "#217346"),
            kind: .excelToPDF
        ),
        PDFTool(
            nameKey: "tool.images_to_pdf.name",
            descriptionKey: "tool.images_to_pdf.description",
            icon: "photo.stack.fill",
            color: Color(hex: "#BF5AF2"),
            kind: .imagesToPDF
        ),
        PDFTool(
            nameKey: "tool.sign.name",
            descriptionKey: "tool.sign.description",
            icon: "pencil.and.scribble",
            color: Color(hex: "#FF2D55"),
            kind: .sign
        ),
        PDFTool(
            nameKey: "tool.protect.name",
            descriptionKey: "tool.protect.description",
            icon: "lock.fill",
            color: Color(hex: "#5856D6"),
            kind: .protect
        ),
        PDFTool(
            nameKey: "tool.unlock.name",
            descriptionKey: "tool.unlock.description",
            icon: "lock.open.fill",
            color: Color(hex: "#30D158"),
            kind: .unlock
        ),
        PDFTool(
            nameKey: "tool.extract_pages.name",
            descriptionKey: "tool.extract_pages.description",
            icon: "doc.on.doc.fill",
            color: Color(hex: "#FF6B35"),
            kind: .extractPages
        )
    ]

    // MARK: Actions

    // swiftlint:disable:next cyclomatic_complexity
    func didTapTool(_ tool: PDFTool) {
        switch tool.kind {
        case .scan:
            isShowingScanner = true
        case .wordToPDF:
            filePickerPurpose = .wordToPDF
            isShowingFilePicker = true
        case .excelToPDF:
            filePickerPurpose = .excelToPDF
            isShowingFilePicker = true
        case .imagesToPDF:
            filePickerPurpose = .imagesToPDF
            isShowingFilePicker = true
        case .merge:
            filePickerPurpose = .merge
            isShowingFilePicker = true
        case .compress:
            filePickerPurpose = .compress
            isShowingFilePicker = true
        case .rotate:
            filePickerPurpose = .rotate
            isShowingFilePicker = true
        case .split:
            filePickerPurpose = .split
            isShowingFilePicker = true
        case .protect:
            filePickerPurpose = .protect
            isShowingFilePicker = true
        case .unlock:
            filePickerPurpose = .unlock
            isShowingFilePicker = true
        case .sign:
            filePickerPurpose = .sign
            isShowingFilePicker = true
        case .extractPages:
            filePickerPurpose = .extractPages
            isShowingFilePicker = true
        }
    }

    func didTapImportPDF() {
        filePickerPurpose = .importPDF
        isShowingFilePicker = true
    }

    // swiftlint:disable:next cyclomatic_complexity
    func handleImportedURLs(_ urls: [URL]) {
        switch filePickerPurpose {
        case .merge:
            pendingDestination = .merge(urls)
        case .split:
            guard let first = urls.first else { return }
            pendingDestination = .split(first)
        case .compress:
            guard let first = urls.first else { return }
            pendingDestination = .compress(first)
        case .rotate:
            guard let first = urls.first else { return }
            pendingDestination = .rotate(first)
        case .protect:
            guard let first = urls.first else { return }
            pendingDestination = .protect(first)
        case .unlock:
            guard let first = urls.first else { return }
            pendingDestination = .unlock(first)
        case .sign:
            // Sign not yet implemented — show error
            showError(String(localized: "error.feature_coming_soon"))
        case .extractPages:
            guard let first = urls.first else { return }
            pendingDestination = .extractPages(first)
        case .imagesToPDF:
            pendingDestination = .imagesToPDF(urls)
        case .wordToPDF:
            guard let first = urls.first else { return }
            pendingDestination = .convertToPDF(first)
        case .excelToPDF:
            guard let first = urls.first else { return }
            pendingDestination = .convertToPDF(first)
        case .importPDF:
            // importPDF needs a DocuScanDocument — skip navigation for now
            break
        }
    }

    func handleScan(_ images: [UIImage], store: DocumentStore) {
        guard !images.isEmpty else { return }
        isProcessingScan = true
        Task { @MainActor [weak self] in
            guard let self else { return }
            defer { self.isProcessingScan = false }
            do {
                let pdf = try await PDFToolsService.shared.scanToPDF(images: images)
                let name = "Scan_\(Self.scanTimestamp())"
                let doc = try store.save(pdfDocument: pdf, name: name)
                self.pendingDestination = .documentViewer(doc)
            } catch {
                self.showError(error.localizedDescription)
            }
        }
    }

    private static func scanTimestamp() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd_HH-mm-ss"
        return formatter.string(from: Date())
    }

    func showError(_ message: String) {
        errorMessage = message
        isShowingError = true
    }
}

// MARK: - ToolsView

struct ToolsView: View {

    @EnvironmentObject var appEnvironment: AppEnvironment
    @StateObject private var viewModel = ToolsViewModel()

    // Camera coordinator is held as state so it survives re-renders.
    @State private var scannerCoordinator: ScannerCoordinator?

    private let columns = [
        GridItem(.flexible(), spacing: Spacing.md),
        GridItem(.flexible(), spacing: Spacing.md)
    ]

    var body: some View {
        NavigationStack(path: $viewModel.navigationPath) {
            ScrollView {
                VStack(alignment: .leading, spacing: Spacing.lg) {
                    quickActionsStrip
                    toolGrid
                }
                .padding(.horizontal, Spacing.md)
                .padding(.top, Spacing.sm)
                .padding(.bottom, Spacing.lg)
            }
            .background(Color.dsBackground)
            .navigationTitle(String(localized: "app.name"))
            .navigationBarTitleDisplayMode(.large)
            .toolbar { toolbarContent }
            .navigationDestination(for: ToolDestination.self) { destination in
                destinationView(for: destination)
            }
            .fileImporter(
                isPresented: $viewModel.isShowingFilePicker,
                allowedContentTypes: viewModel.filePickerPurpose.allowedTypes,
                allowsMultipleSelection: viewModel.filePickerPurpose.allowsMultiple
            ) { result in
                switch result {
                case .success(let urls):
                    viewModel.handleImportedURLs(urls)
                case .failure(let error):
                    viewModel.showError(error.localizedDescription)
                }
            }
            .onChange(of: viewModel.pendingDestination) { destination in
                if let dest = destination {
                    viewModel.navigationPath.append(dest)
                    viewModel.pendingDestination = nil
                }
            }
            .sheet(isPresented: $viewModel.isShowingScanner) {
                if VNDocumentCameraViewController.isSupported {
                    DocumentScannerView { scan in
                        viewModel.isShowingScanner = false
                        let images = (0..<scan.pageCount).map { scan.imageOfPage(at: $0) }
                        viewModel.handleScan(images, store: appEnvironment.documentStore)
                    } onCancel: {
                        viewModel.isShowingScanner = false
                    }
                    .ignoresSafeArea()
                } else {
                    unsupportedScannerView
                }
            }
            .alert(
                String(localized: "error.title"),
                isPresented: $viewModel.isShowingError,
                presenting: viewModel.errorMessage
            ) { _ in
                Button(String(localized: "button.ok")) {
                    viewModel.isShowingError = false
                }
            } message: { msg in
                Text(msg)
            }
        }
        .overlay {
            if viewModel.isProcessingScan {
                scanProcessingOverlay
            }
        }
        .withAdBanner()
    }

    // MARK: Navigation destination builder

    @ViewBuilder
    private func destinationView(for destination: ToolDestination) -> some View {
        switch destination {
        case .merge(let urls):
            MergeToolView(initialURLs: urls)
        case .split(let url):
            SplitToolView(sourceURL: url)
        case .compress(let url):
            CompressToolView(url: url)
        case .rotate(let url):
            RotateToolView(sourceURL: url)
        case .protect(let url):
            ProtectToolView(sourceURL: url)
        case .unlock(let url):
            UnlockToolView(sourceURL: url)
        case .extractPages(let url):
            ExtractPagesToolView(sourceURL: url)
        case .imagesToPDF(let urls):
            ImagesToPDFToolView(imageURLs: urls)
        case .convertToPDF(let url):
            ConvertToPDFToolView(sourceURL: url)
        case .documentViewer(let doc):
            DocumentViewerView(source: .saved(doc))
        }
    }

    // MARK: Quick Actions

    private var quickActionsStrip: some View {
        HStack(spacing: Spacing.md) {
            // Scan CTA — accent orange
            Button {
                viewModel.isShowingScanner = true
            } label: {
                HStack(spacing: Spacing.sm) {
                    Image(systemName: "doc.viewfinder.fill")
                        .font(.system(size: 18, weight: .semibold))
                    Text(String(localized: "quick_action.scan"))
                        .font(.dsHeadline)
                }
                .frame(maxWidth: .infinity)
                .frame(height: 52)
                .background(
                    LinearGradient(
                        colors: [Color.dsAccent, Color.dsAccent.opacity(0.8)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .foregroundStyle(.white)
                .clipShape(RoundedRectangle(cornerRadius: Spacing.CornerRadius.button))
                .shadow(color: Color.dsAccent.opacity(0.35), radius: 8, x: 0, y: 4)
            }
            .buttonStyle(.plain)

            // Import PDF — primary indigo
            Button {
                viewModel.didTapImportPDF()
            } label: {
                HStack(spacing: Spacing.sm) {
                    Image(systemName: "square.and.arrow.down.fill")
                        .font(.system(size: 18, weight: .semibold))
                    Text(String(localized: "quick_action.import"))
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
        }
    }

    // MARK: Tool Grid

    private var toolGrid: some View {
        VStack(alignment: .leading, spacing: Spacing.md) {
            Text(String(localized: "section.all_tools"))
                .font(.dsTitle3)
                .foregroundStyle(Color.dsTextPrimary)

            LazyVGrid(columns: columns, spacing: Spacing.md) {
                ForEach(viewModel.tools) { tool in
                    Button {
                        viewModel.didTapTool(tool)
                    } label: {
                        ToolCard(tool: tool)
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }

    // MARK: Toolbar

    @ToolbarContentBuilder
    private var toolbarContent: some ToolbarContent {
        ToolbarItem(placement: .navigationBarTrailing) {
            NavigationLink(destination: EmptyView()) {
                Image(systemName: "gearshape.fill")
                    .foregroundStyle(Color.dsPrimary)
            }
        }
    }

    // MARK: Scan-processing overlay

    private var scanProcessingOverlay: some View {
        ZStack {
            Color.black.opacity(0.4).ignoresSafeArea()
            VStack(spacing: Spacing.md) {
                ProgressView()
                    .progressViewStyle(.circular)
                    .tint(.white)
                    .scaleEffect(1.4)
                Text(String(localized: "scanner.processing"))
                    .font(.dsBody)
                    .foregroundStyle(.white)
            }
            .padding(Spacing.xl)
            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16))
        }
    }

    // MARK: Unsupported scanner fallback

    private var unsupportedScannerView: some View {
        VStack(spacing: Spacing.md) {
            Image(systemName: "camera.fill")
                .font(.system(size: 56))
                .foregroundStyle(Color.dsTextTertiary)
            Text(String(localized: "scanner.unavailable"))
                .font(.dsHeadline)
                .foregroundStyle(Color.dsTextSecondary)
                .multilineTextAlignment(.center)
            Button(String(localized: "button.close")) {
                viewModel.isShowingScanner = false
            }
            .buttonStyle(.plain)
            .foregroundStyle(Color.dsPrimary)
        }
        .padding(Spacing.xl)
        .presentationDetents([.medium])
    }
}

// MARK: - ToolCard

private struct ToolCard: View {
    let tool: PDFTool

    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.sm) {
            // Icon bubble
            ZStack {
                RoundedRectangle(cornerRadius: Spacing.CornerRadius.small)
                    .fill(tool.color.opacity(0.12))
                    .frame(width: 44, height: 44)

                Image(systemName: tool.icon)
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundStyle(tool.color)
            }

            Spacer(minLength: Spacing.xs)

            Text(String(localized: String.LocalizationValue(tool.nameKey)))
                .font(.dsHeadline)
                .foregroundStyle(Color.dsTextPrimary)
                .lineLimit(1)
                .minimumScaleFactor(0.85)

            Text(String(localized: String.LocalizationValue(tool.descriptionKey)))
                .font(.dsCaption1)
                .foregroundStyle(Color.dsTextSecondary)
                .lineLimit(2)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(Spacing.md)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.dsSurface)
        .clipShape(RoundedRectangle(cornerRadius: Spacing.CornerRadius.card))
        .overlay(
            RoundedRectangle(cornerRadius: Spacing.CornerRadius.card)
                .stroke(tool.color.opacity(0.15), lineWidth: 1)
        )
        .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
    }
}

// MARK: - DocumentScannerView (VisionKit wrapper)

private struct DocumentScannerView: UIViewControllerRepresentable {

    let onScan: (VNDocumentCameraScan) -> Void
    let onCancel: () -> Void

    func makeUIViewController(context: Context) -> VNDocumentCameraViewController {
        let controller = VNDocumentCameraViewController()
        controller.delegate = context.coordinator
        return controller
    }

    func updateUIViewController(_ uiViewController: VNDocumentCameraViewController, context: Context) {}

    func makeCoordinator() -> ScannerCoordinator {
        ScannerCoordinator(onScan: onScan, onCancel: onCancel)
    }
}

// MARK: - ScannerCoordinator

final class ScannerCoordinator: NSObject, VNDocumentCameraViewControllerDelegate {

    private let onScan: (VNDocumentCameraScan) -> Void
    private let onCancel: () -> Void

    init(onScan: @escaping (VNDocumentCameraScan) -> Void, onCancel: @escaping () -> Void) {
        self.onScan = onScan
        self.onCancel = onCancel
    }

    func documentCameraViewController(
        _ controller: VNDocumentCameraViewController,
        didFinishWith scan: VNDocumentCameraScan
    ) {
        onScan(scan)
    }

    func documentCameraViewControllerDidCancel(_ controller: VNDocumentCameraViewController) {
        onCancel()
    }

    func documentCameraViewController(
        _ controller: VNDocumentCameraViewController,
        didFailWithError error: Error
    ) {
        onCancel()
    }
}
