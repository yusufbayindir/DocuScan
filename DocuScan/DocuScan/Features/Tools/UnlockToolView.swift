import SwiftUI
import PDFKit

struct UnlockToolView: View {
    let sourceURL: URL

    @EnvironmentObject private var appEnvironment: AppEnvironment

    @State private var password: String = ""
    @State private var isProcessing: Bool = false
    @State private var wrongPassword: Bool = false
    @State private var resultDocument: DocuScanDocument?
    @State private var showSuccess: Bool = false
    @State private var generalError: String?
    @State private var showGeneralError: Bool = false
    @State private var navigateToViewer: Bool = false

    private var fileName: String {
        sourceURL.deletingPathExtension().lastPathComponent
    }

    private var documentStore: DocumentStore { appEnvironment.documentStore }

    var body: some View {
        NavigationStack {
            ZStack {
                Color.dsBackground.ignoresSafeArea()

                ScrollView {
                    VStack(spacing: Spacing.lg) {
                        fileInfoCard
                        passwordSection
                        Spacer(minLength: Spacing.xl)
                        unlockButton
                    }
                    .padding(.horizontal, Spacing.md)
                    .padding(.top, Spacing.lg)
                    .padding(.bottom, Spacing.xl)
                }

                if showSuccess {
                    successOverlay
                }
            }
            .navigationTitle(String(localized: "unlock_tool.nav_title"))
            .navigationBarTitleDisplayMode(.inline)
            .alert(
                String(localized: "unlock_tool.error.general_title"),
                isPresented: $showGeneralError,
                actions: {
                    Button(String(localized: "common.ok"), role: .cancel) {}
                },
                message: {
                    if let error = generalError {
                        Text(error)
                    }
                }
            )
            .navigationDestination(isPresented: $navigateToViewer) {
                if let doc = resultDocument {
                    DocumentViewerView(source: .saved(doc))
                }
            }
        }
    }

    // MARK: - File Info Card

    private var fileInfoCard: some View {
        HStack(spacing: Spacing.md) {
            ZStack {
                RoundedRectangle(cornerRadius: Spacing.CornerRadius.small)
                    .fill(Color.dsError.opacity(0.1))
                    .frame(width: 52, height: 60)

                VStack(spacing: 2) {
                    Image(systemName: "lock.doc.fill")
                        .font(.system(size: 24, weight: .medium))
                        .foregroundStyle(Color.dsError)
                }
            }

            VStack(alignment: .leading, spacing: Spacing.xs) {
                Text(String(localized: "unlock_tool.file_label"))
                    .font(.dsCaption1)
                    .foregroundStyle(Color.dsTextSecondary)

                Text(fileName)
                    .font(.dsSubheadline)
                    .fontWeight(.semibold)
                    .foregroundStyle(Color.dsTextPrimary)
                    .lineLimit(2)

                HStack(spacing: Spacing.xs) {
                    Image(systemName: "lock.fill")
                        .font(.system(size: 10, weight: .medium))
                        .foregroundStyle(Color.dsError)
                    Text(String(localized: "unlock_tool.protected_badge"))
                        .font(.dsCaption1)
                        .foregroundStyle(Color.dsError)
                }
            }

            Spacer(minLength: 0)
        }
        .padding(Spacing.md)
        .cardStyle()
    }

    // MARK: - Password Section

    private var passwordSection: some View {
        VStack(alignment: .leading, spacing: Spacing.sm) {
            Text(String(localized: "unlock_tool.password_section_title"))
                .font(.dsHeadline)
                .foregroundStyle(Color.dsTextPrimary)

            Text(String(localized: "unlock_tool.password_section_subtitle"))
                .font(.dsBody)
                .foregroundStyle(Color.dsTextSecondary)

            VStack(alignment: .leading, spacing: Spacing.xs) {
                HStack {
                    Image(systemName: "key.fill")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundStyle(wrongPassword ? Color.dsError : Color.dsPrimary)

                    SecureField(
                        String(localized: "unlock_tool.password_placeholder"),
                        text: $password
                    )
                    .font(.dsBody)
                    .textContentType(.password)
                    .submitLabel(.go)
                    .onSubmit {
                        guard !password.isEmpty, !isProcessing else { return }
                        performUnlock()
                    }
                    .onChange(of: password) { _ in
                        if wrongPassword { wrongPassword = false }
                    }
                }
                .padding(Spacing.md)
                .background(Color.dsSurface)
                .clipShape(RoundedRectangle(cornerRadius: Spacing.CornerRadius.button))
                .overlay(
                    RoundedRectangle(cornerRadius: Spacing.CornerRadius.button)
                        .stroke(
                            wrongPassword ? Color.dsError : Color.dsSeparator,
                            lineWidth: wrongPassword ? 1.5 : 1
                        )
                )

                if wrongPassword {
                    HStack(spacing: Spacing.xs) {
                        Image(systemName: "exclamationmark.circle.fill")
                            .font(.system(size: 12))
                            .foregroundStyle(Color.dsError)

                        Text(String(localized: "unlock_tool.error.wrong_password"))
                            .font(.dsCaption1)
                            .foregroundStyle(Color.dsError)
                    }
                    .transition(.opacity.combined(with: .move(edge: .top)))
                }
            }
            .animation(.easeInOut(duration: 0.2), value: wrongPassword)
        }
    }

    // MARK: - Unlock Button

    private var unlockButton: some View {
        Button {
            guard !password.isEmpty, !isProcessing else { return }
            performUnlock()
        } label: {
            HStack(spacing: Spacing.sm) {
                if isProcessing {
                    ProgressView()
                        .progressViewStyle(.circular)
                        .tint(.white)
                        .scaleEffect(0.85)
                } else {
                    Image(systemName: "lock.open.fill")
                        .font(.system(size: 16, weight: .semibold))
                }

                Text(
                    isProcessing
                        ? String(localized: "unlock_tool.button.processing")
                        : String(localized: "unlock_tool.button.unlock")
                )
                .font(.dsHeadline)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 50)
            .background(
                password.isEmpty || isProcessing
                    ? Color.dsPrimary.opacity(0.5)
                    : Color.dsPrimary
            )
            .foregroundStyle(.white)
            .clipShape(RoundedRectangle(cornerRadius: Spacing.CornerRadius.button))
        }
        .buttonStyle(.plain)
        .disabled(password.isEmpty || isProcessing)
        .animation(.easeInOut(duration: 0.15), value: isProcessing)
    }

    // MARK: - Success Overlay

    private var successOverlay: some View {
        ZStack {
            Color.black.opacity(0.35)
                .ignoresSafeArea()

            VStack(spacing: Spacing.md) {
                ZStack {
                    Circle()
                        .fill(Color.dsSuccess.opacity(0.15))
                        .frame(width: 88, height: 88)

                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 48, weight: .medium))
                        .foregroundStyle(Color.dsSuccess)
                        .symbolRenderingMode(.hierarchical)
                }

                Text(String(localized: "unlock_tool.success.title"))
                    .font(.dsTitle3)
                    .fontWeight(.semibold)
                    .foregroundStyle(Color.dsTextPrimary)

                Text(String(localized: "unlock_tool.success.subtitle"))
                    .font(.dsBody)
                    .foregroundStyle(Color.dsTextSecondary)
                    .multilineTextAlignment(.center)
            }
            .padding(Spacing.xl)
            .background(Color.dsBackground)
            .clipShape(RoundedRectangle(cornerRadius: Spacing.CornerRadius.large))
            .padding(.horizontal, Spacing.xl)
            .transition(.scale(scale: 0.85).combined(with: .opacity))
        }
        .transition(.opacity)
    }

    // MARK: - Actions

    private func performUnlock() {
        isProcessing = true
        wrongPassword = false

        Task { @MainActor in
            do {
                let unlockedPDF = try await PDFToolsService.shared.unlock(
                    pdf: sourceURL,
                    password: password
                )

                let saveName = "Unlocked_\(fileName)"
                let saved = try documentStore.save(pdfDocument: unlockedPDF, name: saveName)
                resultDocument = saved

                withAnimation(.spring(response: 0.4, dampingFraction: 0.75)) {
                    showSuccess = true
                }

                try? await Task.sleep(nanoseconds: 1_500_000_000)

                withAnimation(.easeOut(duration: 0.2)) {
                    showSuccess = false
                }

                try? await Task.sleep(nanoseconds: 200_000_000)
                navigateToViewer = true

            } catch DocumentError.passwordRequired {
                withAnimation { wrongPassword = true }
            } catch {
                generalError = error.localizedDescription
                showGeneralError = true
            }

            isProcessing = false
        }
    }
}
