import SwiftUI
import PDFKit

// MARK: - RotateToolView

// swiftlint:disable:next type_body_length
struct RotateToolView: View {

    // MARK: Input

    let sourceURL: URL

    // MARK: Environment

    @EnvironmentObject var appEnvironment: AppEnvironment
    @Environment(\.dismiss) private var dismiss

    // MARK: State

    @State private var rotateAll = true
    @State private var pageText = ""
    @State private var selectedDegrees = 90
    @State private var pageCount = 0
    @State private var isProcessing = false
    @State private var resultDocument: DocuScanDocument?
    @State private var errorMessage: String?
    @State private var isShowingError = false
    @State private var navigateToViewer = false

    // MARK: Constants

    private struct RotationOption {
        let label: String
        let icon: String
        let degrees: Int
    }

    private let rotationOptions: [RotationOption] = [
        RotationOption(label: String(localized: "rotate.ccw_90"), icon: "rotate.left.fill", degrees: -90),
        RotationOption(label: String(localized: "rotate.180"), icon: "arrow.uturn.right.fill", degrees: 180),
        RotationOption(label: String(localized: "rotate.cw_90"), icon: "rotate.right.fill", degrees: 90)
    ]

    // MARK: Body

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: Spacing.lg) {
                    fileInfoCard
                    pageSelectorCard
                    if !rotateAll {
                        pageInputCard
                    }
                    rotationPickerCard
                    actionButton
                }
                .padding(.horizontal, Spacing.md)
                .padding(.top, Spacing.md)
                .padding(.bottom, Spacing.xl)
            }
            .background(Color.dsBackground)
            .navigationTitle(String(localized: "rotate.nav_title"))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(String(localized: "button.cancel")) {
                        dismiss()
                    }
                    .foregroundStyle(Color.dsPrimary)
                }
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
        .task {
            await loadPageCount()
        }
    }

    // MARK: - Subviews

    private var fileInfoCard: some View {
        HStack(spacing: Spacing.md) {
            ZStack {
                RoundedRectangle(cornerRadius: Spacing.CornerRadius.small)
                    .fill(Color(hex: "#FF9F0A").opacity(0.12))
                    .frame(width: 48, height: 48)
                Image(systemName: "rotate.right.fill")
                    .font(.system(size: 22, weight: .semibold))
                    .foregroundStyle(Color(hex: "#FF9F0A"))
            }

            VStack(alignment: .leading, spacing: Spacing.xs) {
                Text(sourceURL.lastPathComponent)
                    .font(.dsHeadline)
                    .foregroundStyle(Color.dsTextPrimary)
                    .lineLimit(1)
                    .truncationMode(.middle)

                Text(pageCountLabel)
                    .font(.dsCaption1)
                    .foregroundStyle(Color.dsTextSecondary)
            }

            Spacer()
        }
        .padding(Spacing.md)
        .cardStyle()
    }

    private var pageCountLabel: String {
        if pageCount == 0 {
            return String(localized: "rotate.loading_pages")
        }
        return String(localized: "rotate.page_count \(pageCount)")
    }

    private var pageSelectorCard: some View {
        VStack(alignment: .leading, spacing: Spacing.sm) {
            Text(String(localized: "rotate.page_selection_title"))
                .font(.dsTitle3)
                .foregroundStyle(Color.dsTextPrimary)

            HStack(spacing: Spacing.sm) {
                pageScopeButton(
                    label: String(localized: "rotate.all_pages"),
                    isSelected: rotateAll
                ) {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        rotateAll = true
                    }
                }

                pageScopeButton(
                    label: String(localized: "rotate.specific_pages"),
                    isSelected: !rotateAll
                ) {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        rotateAll = false
                    }
                }
            }
        }
        .padding(Spacing.md)
        .cardStyle()
    }

    private var pageInputCard: some View {
        VStack(alignment: .leading, spacing: Spacing.sm) {
            Text(String(localized: "rotate.enter_pages_title"))
                .font(.dsTitle3)
                .foregroundStyle(Color.dsTextPrimary)

            Text(String(localized: "rotate.enter_pages_hint"))
                .font(.dsCaption1)
                .foregroundStyle(Color.dsTextSecondary)

            TextField(String(localized: "rotate.pages_placeholder"), text: $pageText)
                .font(.dsBody)
                .keyboardType(.numbersAndPunctuation)
                .padding(Spacing.sm)
                .background(Color.dsBackground)
                .clipShape(RoundedRectangle(cornerRadius: Spacing.CornerRadius.small))
                .overlay(
                    RoundedRectangle(cornerRadius: Spacing.CornerRadius.small)
                        .stroke(Color.dsSeparator, lineWidth: 1)
                )
        }
        .padding(Spacing.md)
        .cardStyle()
    }

    private var rotationPickerCard: some View {
        VStack(alignment: .leading, spacing: Spacing.sm) {
            Text(String(localized: "rotate.rotation_amount_title"))
                .font(.dsTitle3)
                .foregroundStyle(Color.dsTextPrimary)

            HStack(spacing: Spacing.sm) {
                ForEach(rotationOptions, id: \.degrees) { option in
                    rotationOptionButton(option: option)
                }
            }
        }
        .padding(Spacing.md)
        .cardStyle()
    }

    private var actionButton: some View {
        Button {
            guard !isProcessing else { return }
            Task { @MainActor in
                await performRotation()
            }
        } label: {
            HStack(spacing: Spacing.sm) {
                if isProcessing {
                    ProgressView()
                        .tint(.white)
                        .scaleEffect(0.85)
                } else {
                    Image(systemName: "rotate.right.fill")
                        .font(.system(size: 16, weight: .semibold))
                }
                Text(String(localized: "rotate.action_button"))
                    .font(.dsHeadline)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 50)
            .background(isProcessing ? Color.dsPrimary.opacity(0.6) : Color.dsPrimary)
            .foregroundStyle(.white)
            .clipShape(RoundedRectangle(cornerRadius: Spacing.CornerRadius.button))
        }
        .buttonStyle(.plain)
        .disabled(isProcessing || (pageCount == 0))
    }

    // MARK: - Helper Views

    private func pageScopeButton(label: String, isSelected: Bool, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(label)
                .font(.dsHeadline)
                .frame(maxWidth: .infinity)
                .frame(height: 40)
                .background(isSelected ? Color.dsPrimary : Color.dsBackground)
                .foregroundStyle(isSelected ? .white : Color.dsTextSecondary)
                .clipShape(RoundedRectangle(cornerRadius: Spacing.CornerRadius.small))
                .overlay(
                    RoundedRectangle(cornerRadius: Spacing.CornerRadius.small)
                        .stroke(isSelected ? Color.dsPrimary : Color.dsSeparator, lineWidth: 1)
                )
        }
        .buttonStyle(.plain)
    }

    private func rotationOptionButton(option: RotationOption) -> some View {
        let isSelected = selectedDegrees == option.degrees
        return Button {
            selectedDegrees = option.degrees
        } label: {
            VStack(spacing: Spacing.xs) {
                Image(systemName: option.icon)
                    .font(.system(size: 20, weight: .semibold))
                Text(option.label)
                    .font(.dsCaption1)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 64)
            .background(isSelected ? Color.dsPrimary.opacity(0.12) : Color.dsBackground)
            .foregroundStyle(isSelected ? Color.dsPrimary : Color.dsTextSecondary)
            .clipShape(RoundedRectangle(cornerRadius: Spacing.CornerRadius.small))
            .overlay(
                RoundedRectangle(cornerRadius: Spacing.CornerRadius.small)
                    .stroke(
                        isSelected ? Color.dsPrimary : Color.dsSeparator,
                        lineWidth: isSelected ? 2 : 1
                    )
            )
        }
        .buttonStyle(.plain)
    }

    // MARK: - Logic

    private func loadPageCount() async {
        let url = sourceURL
        let count = await Task.detached(priority: .userInitiated) {
            PDFDocument(url: url)?.pageCount ?? 0
        }.value
        pageCount = count
    }

    private func performRotation() async {
        isProcessing = true
        defer { isProcessing = false }

        let indices = resolvedPageIndices()
        guard !indices.isEmpty else {
            errorMessage = String(localized: "rotate.error_no_pages")
            isShowingError = true
            return
        }

        do {
            let rotated = try await PDFToolsService.shared.rotate(
                pdf: sourceURL,
                pageIndices: indices,
                degrees: selectedDegrees
            )
            let baseName = sourceURL.deletingPathExtension().lastPathComponent
            let savedDoc = try appEnvironment.documentStore.save(
                pdfDocument: rotated,
                name: String(localized: "rotate.saved_name \(baseName)")
            )
            resultDocument = savedDoc
            navigateToViewer = true
        } catch let docError as DocumentError {
            errorMessage = docError.errorDescription
            isShowingError = true
        } catch {
            errorMessage = error.localizedDescription
            isShowingError = true
        }
    }

    private func resolvedPageIndices() -> [Int] {
        if rotateAll {
            return Array(0..<pageCount)
        }
        return pageText
            .split(separator: ",")
            .compactMap { token -> Int? in
                let trimmed = token.trimmingCharacters(in: .whitespaces)
                guard let oneBased = Int(trimmed), oneBased >= 1, oneBased <= pageCount else {
                    return nil
                }
                return oneBased - 1
            }
    }
}
