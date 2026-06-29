// swiftlint:disable file_length
import SwiftUI
import PDFKit
import UniformTypeIdentifiers

// MARK: - ImagesToPDFToolView

// swiftlint:disable:next type_body_length
struct ImagesToPDFToolView: View {

    // MARK: Environment

    @EnvironmentObject var appEnvironment: AppEnvironment

    // MARK: State

    @State private var imageURLs: [URL]
    @State private var isProcessing = false
    @State private var resultDocument: DocuScanDocument?
    @State private var showImagePicker = false
    @State private var errorMessage: String?
    @State private var isShowingError = false
    @State private var navigateToViewer = false

    // MARK: Grid layout

    private let columns = [
        GridItem(.flexible(), spacing: Spacing.md),
        GridItem(.flexible(), spacing: Spacing.md)
    ]

    // MARK: Init

    init(imageURLs: [URL] = []) {
        _imageURLs = State(initialValue: imageURLs)
    }

    // MARK: Body

    var body: some View {
        NavigationStack {
            ZStack {
                Color.dsBackground.ignoresSafeArea()

                VStack(spacing: 0) {
                    if imageURLs.isEmpty {
                        emptyState
                    } else {
                        imageGrid
                    }

                    Spacer(minLength: 0)
                    bottomBar
                }
            }
            .navigationTitle(String(localized: "images_to_pdf.navigation_title"))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar { toolbarContent }
            .fileImporter(
                isPresented: $showImagePicker,
                allowedContentTypes: [.image],
                allowsMultipleSelection: true
            ) { result in
                handlePickerResult(result)
            }
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
            .navigationDestination(isPresented: $navigateToViewer) {
                if let doc = resultDocument {
                    DocumentViewerView(source: .saved(doc))
                }
            }
        }
        .withAdBanner()
    }

    // MARK: - Empty State

    private var emptyState: some View {
        VStack(spacing: Spacing.lg) {
            Spacer()

            Image(systemName: "photo.stack.fill")
                .font(.system(size: 64, weight: .light))
                .foregroundStyle(Color.dsPrimary.opacity(0.4))

            VStack(spacing: Spacing.sm) {
                Text(String(localized: "images_to_pdf.empty_title"))
                    .font(.dsTitle3)
                    .foregroundStyle(Color.dsTextPrimary)
                    .multilineTextAlignment(.center)

                Text(String(localized: "images_to_pdf.empty_subtitle"))
                    .font(.dsBody)
                    .foregroundStyle(Color.dsTextSecondary)
                    .multilineTextAlignment(.center)
            }

            Button {
                showImagePicker = true
            } label: {
                HStack(spacing: Spacing.sm) {
                    Image(systemName: "plus.circle.fill")
                        .font(.system(size: 18, weight: .semibold))
                    Text(String(localized: "images_to_pdf.add_images_button"))
                        .font(.dsHeadline)
                }
                .frame(maxWidth: 240)
                .frame(height: 50)
                .background(Color.dsPrimary)
                .foregroundStyle(.white)
                .clipShape(RoundedRectangle(cornerRadius: Spacing.CornerRadius.button))
            }
            .buttonStyle(.plain)

            Spacer()
        }
        .padding(.horizontal, Spacing.xl)
    }

    // MARK: - Image Grid

    private var imageGrid: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: Spacing.md) {
                hintBanner
                imageThumbnailGrid
            }
            .padding(.horizontal, Spacing.md)
            .padding(.top, Spacing.md)
            .padding(.bottom, Spacing.lg)
        }
    }

    private var hintBanner: some View {
        HStack(spacing: Spacing.sm) {
            Image(systemName: "info.circle.fill")
                .font(.system(size: 14))
                .foregroundStyle(Color.dsPrimary)

            Text(String(localized: "images_to_pdf.order_hint"))
                .font(.dsCaption1)
                .foregroundStyle(Color.dsTextSecondary)

            Spacer()

            countBadge
        }
        .padding(.horizontal, Spacing.md)
        .padding(.vertical, Spacing.sm)
        .background(Color.dsPrimary.opacity(0.08))
        .clipShape(RoundedRectangle(cornerRadius: Spacing.CornerRadius.small))
    }

    private var countBadge: some View {
        Text("\(imageURLs.count) image\(imageURLs.count == 1 ? "" : "s")")
        .font(.dsCaption1)
        .fontWeight(.semibold)
        .foregroundStyle(.white)
        .padding(.horizontal, Spacing.sm)
        .padding(.vertical, Spacing.xs)
        .background(Color.dsPrimary)
        .clipShape(Capsule())
    }

    private var imageThumbnailGrid: some View {
        LazyVGrid(columns: columns, spacing: Spacing.md) {
            ForEach(Array(imageURLs.enumerated()), id: \.element) { index, url in
                ImageThumbnailCell(url: url, index: index + 1) {
                    removeImage(at: index)
                }
                .contextMenu {
                    Button(role: .destructive) {
                        removeImage(at: index)
                    } label: {
                        Label(
                            String(localized: "images_to_pdf.remove_image"),
                            systemImage: "trash"
                        )
                    }
                }
            }
        }
    }

    // MARK: - Bottom Bar

    private var bottomBar: some View {
        VStack(spacing: Spacing.sm) {
            Divider()

            VStack(spacing: Spacing.sm) {
                if !imageURLs.isEmpty {
                    Button {
                        showImagePicker = true
                    } label: {
                        HStack(spacing: Spacing.sm) {
                            Image(systemName: "plus.circle")
                                .font(.system(size: 16, weight: .medium))
                            Text(String(localized: "images_to_pdf.add_more_button"))
                                .font(.dsHeadline)
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
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

                Button {
                    convertToPDF()
                } label: {
                    HStack(spacing: Spacing.sm) {
                        if isProcessing {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                .scaleEffect(0.85)
                        } else {
                            Image(systemName: "doc.fill.badge.plus")
                                .font(.system(size: 16, weight: .semibold))
                        }
                        Text(
                            isProcessing
                                ? String(localized: "images_to_pdf.converting")
                                : String(localized: "images_to_pdf.convert_button")
                        )
                        .font(.dsHeadline)
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .background(
                        imageURLs.isEmpty || isProcessing
                            ? Color.dsPrimary.opacity(0.4)
                            : Color.dsPrimary
                    )
                    .foregroundStyle(.white)
                    .clipShape(RoundedRectangle(cornerRadius: Spacing.CornerRadius.button))
                }
                .buttonStyle(.plain)
                .disabled(imageURLs.isEmpty || isProcessing)
            }
            .padding(.horizontal, Spacing.md)
            .padding(.bottom, Spacing.md)
        }
        .background(Color.dsBackground)
    }

    // MARK: - Toolbar

    @ToolbarContentBuilder
    private var toolbarContent: some ToolbarContent {
        ToolbarItem(placement: .navigationBarTrailing) {
            Button {
                showImagePicker = true
            } label: {
                Image(systemName: "plus")
                    .foregroundStyle(Color.dsPrimary)
            }
        }
    }

    // MARK: - Actions

    private func removeImage(at index: Int) {
        guard index < imageURLs.count else { return }
        imageURLs.remove(at: index)
    }

    private func handlePickerResult(_ result: Result<[URL], Error>) {
        switch result {
        case .success(let urls):
            let newURLs = urls.filter { url in
                !imageURLs.contains(url)
            }
            imageURLs.append(contentsOf: newURLs)
        case .failure(let error):
            errorMessage = error.localizedDescription
            isShowingError = true
        }
    }

    private func convertToPDF() {
        guard !imageURLs.isEmpty, !isProcessing else { return }
        isProcessing = true

        let urls = imageURLs

        Task { @MainActor in
            do {
                let securedURLs = urls.map { url -> URL in
                    _ = url.startAccessingSecurityScopedResource()
                    return url
                }
                defer {
                    securedURLs.forEach { $0.stopAccessingSecurityScopedResource() }
                }

                let pdfDocument = try await PDFToolsService.shared.imagesToPDF(imageURLs: securedURLs)
                let saved = try appEnvironment.documentStore.save(
                    pdfDocument: pdfDocument,
                    name: String(localized: "images_to_pdf.default_filename")
                )
                resultDocument = saved
                isProcessing = false
                navigateToViewer = true
            } catch {
                isProcessing = false
                errorMessage = error.localizedDescription
                isShowingError = true
            }
        }
    }
}

// MARK: - ImageThumbnailCell

private struct ImageThumbnailCell: View {

    let url: URL
    let index: Int
    let onRemove: () -> Void

    @State private var loadedImage: UIImage?
    @State private var isLoaded = false

    var body: some View {
        ZStack(alignment: .topTrailing) {
            thumbnailImage
                .frame(maxWidth: .infinity)
                .aspectRatio(1, contentMode: .fit)
                .clipShape(RoundedRectangle(cornerRadius: Spacing.CornerRadius.card))
                .overlay(
                    RoundedRectangle(cornerRadius: Spacing.CornerRadius.card)
                        .stroke(Color.dsSeparator, lineWidth: 0.5)
                )
                .shadow(color: Color.black.opacity(0.08), radius: 4, x: 0, y: 2)

            // Index badge
            Text("\(index)")
                .font(.dsCaption2)
                .fontWeight(.bold)
                .foregroundStyle(.white)
                .frame(width: 22, height: 22)
                .background(Color.dsPrimary)
                .clipShape(Circle())
                .padding(Spacing.xs)

            // Remove button — bottom trailing
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Button(action: onRemove) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 22))
                            .foregroundStyle(.white)
                            .background(Color.black.opacity(0.45), in: Circle())
                    }
                    .buttonStyle(.plain)
                    .padding(Spacing.xs)
                }
            }
        }
        .task {
            await loadImage()
        }
    }

    private var thumbnailImage: some View {
        Group {
            if let image = loadedImage {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
            } else {
                ZStack {
                    Color.dsSurface
                    if isLoaded {
                        Image(systemName: "photo")
                            .font(.system(size: 32))
                            .foregroundStyle(Color.dsTextTertiary)
                    } else {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: Color.dsTextSecondary))
                    }
                }
            }
        }
    }

    private func loadImage() async {
        let targetURL = url
        let image = await Task.detached(priority: .userInitiated) { () -> UIImage? in
            _ = targetURL.startAccessingSecurityScopedResource()
            defer { targetURL.stopAccessingSecurityScopedResource() }
            guard let data = try? Data(contentsOf: targetURL) else { return nil }
            return UIImage(data: data)
        }.value
        await MainActor.run {
            loadedImage = image
            isLoaded = true
        }
    }
}
