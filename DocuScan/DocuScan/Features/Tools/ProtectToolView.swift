import SwiftUI
import PDFKit

// MARK: - Password Strength

private enum PasswordStrength {
    case weak, medium, strong

    init(password: String) {
        switch password.count {
        case 0 ..< 6:  self = .weak
        case 6 ... 10: self = .medium
        default:        self = .strong
        }
    }

    var label: String {
        switch self {
        case .weak:   return String(localized: "protect.strength.weak")
        case .medium: return String(localized: "protect.strength.medium")
        case .strong: return String(localized: "protect.strength.strong")
        }
    }

    var color: Color {
        switch self {
        case .weak:   return .dsError
        case .medium: return .dsWarning
        case .strong: return .dsSuccess
        }
    }

    var filledSegments: Int {
        switch self {
        case .weak:   return 1
        case .medium: return 2
        case .strong: return 3
        }
    }
}

// MARK: - ProtectToolView

// swiftlint:disable:next type_body_length
struct ProtectToolView: View {

    // MARK: Input

    let sourceURL: URL

    // MARK: Environment

    @EnvironmentObject var appEnvironment: AppEnvironment
    @Environment(\.dismiss) private var dismiss

    // MARK: State

    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var isProcessing = false
    @State private var resultDocument: DocuScanDocument?
    @State private var showSuccessOverlay = false
    @State private var errorMessage: String?
    @State private var showError = false
    @State private var navigateToViewer = false

    // MARK: Computed

    private var sourceFileName: String {
        sourceURL.deletingPathExtension().lastPathComponent
    }

    private var strength: PasswordStrength {
        PasswordStrength(password: password)
    }

    private var passwordsMatch: Bool {
        !password.isEmpty && password == confirmPassword
    }

    private var isValid: Bool {
        password.count >= 4 && passwordsMatch
    }

    private var mismatchMessage: String? {
        guard !confirmPassword.isEmpty, !passwordsMatch else { return nil }
        return String(localized: "protect.error.mismatch")
    }

    // MARK: Body

    var body: some View {
        NavigationStack {
            ZStack {
                Color.dsBackground.ignoresSafeArea()

                ScrollView {
                    VStack(spacing: Spacing.lg) {
                        fileCard
                        passwordSection
                        confirmPasswordSection
                        if !password.isEmpty {
                            strengthIndicator
                        }
                        protectButton
                    }
                    .padding(.horizontal, Spacing.md)
                    .padding(.top, Spacing.md)
                    .padding(.bottom, Spacing.xl)
                }

                if showSuccessOverlay {
                    successOverlay
                }
            }
            .navigationTitle(String(localized: "protect.navigation.title"))
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
                isPresented: $showError,
                presenting: errorMessage
            ) { _ in
                Button(String(localized: "button.ok"), role: .cancel) {}
            } message: { msg in
                Text(msg)
            }
            .navigationDestination(isPresented: $navigateToViewer) {
                if let doc = resultDocument {
                    DocumentViewerView(source: .saved(doc))
                }
            }
            .disabled(isProcessing)
        }
    }

    // MARK: - File Card

    private var fileCard: some View {
        HStack(spacing: Spacing.md) {
            ZStack {
                RoundedRectangle(cornerRadius: Spacing.CornerRadius.small)
                    .fill(Color(hex: "#5856D6").opacity(0.12))
                    .frame(width: 48, height: 56)

                VStack(spacing: 2) {
                    Image(systemName: "doc.fill")
                        .font(.system(size: 22, weight: .medium))
                        .foregroundStyle(Color(hex: "#5856D6"))
                    Text("PDF")
                        .font(.dsCaption2)
                        .fontWeight(.bold)
                        .foregroundStyle(Color(hex: "#5856D6"))
                }
            }

            VStack(alignment: .leading, spacing: Spacing.xs) {
                Text(String(localized: "protect.source.label"))
                    .font(.dsCaption1)
                    .foregroundStyle(Color.dsTextTertiary)
                Text(sourceFileName)
                    .font(.dsSubheadline)
                    .fontWeight(.semibold)
                    .foregroundStyle(Color.dsTextPrimary)
                    .lineLimit(2)
            }

            Spacer(minLength: 0)

            Image(systemName: "lock.fill")
                .font(.system(size: 18, weight: .semibold))
                .foregroundStyle(Color(hex: "#5856D6").opacity(0.6))
        }
        .padding(Spacing.md)
        .cardStyle()
    }

    // MARK: - Password Section

    private var passwordSection: some View {
        VStack(alignment: .leading, spacing: Spacing.sm) {
            Text(String(localized: "protect.password.label"))
                .font(.dsSubheadline)
                .fontWeight(.semibold)
                .foregroundStyle(Color.dsTextPrimary)

            SecureField(String(localized: "protect.password.placeholder"), text: $password)
                .font(.dsBody)
                .padding(Spacing.md)
                .background(Color.dsSurface)
                .clipShape(RoundedRectangle(cornerRadius: Spacing.CornerRadius.card))
                .overlay(
                    RoundedRectangle(cornerRadius: Spacing.CornerRadius.card)
                        .stroke(passwordFieldBorderColor, lineWidth: 1)
                )
                .textContentType(.newPassword)
                .autocorrectionDisabled()

            if !password.isEmpty && password.count < 4 {
                Text(String(localized: "protect.error.min_length"))
                    .font(.dsCaption1)
                    .foregroundStyle(Color.dsError)
            }
        }
    }

    private var passwordFieldBorderColor: Color {
        if password.isEmpty { return Color.dsSeparator }
        if password.count < 4 { return Color.dsError.opacity(0.5) }
        return strength.color.opacity(0.5)
    }

    // MARK: - Confirm Password Section

    private var confirmPasswordSection: some View {
        VStack(alignment: .leading, spacing: Spacing.sm) {
            Text(String(localized: "protect.confirm_password.label"))
                .font(.dsSubheadline)
                .fontWeight(.semibold)
                .foregroundStyle(Color.dsTextPrimary)

            SecureField(String(localized: "protect.confirm_password.placeholder"), text: $confirmPassword)
                .font(.dsBody)
                .padding(Spacing.md)
                .background(Color.dsSurface)
                .clipShape(RoundedRectangle(cornerRadius: Spacing.CornerRadius.card))
                .overlay(
                    RoundedRectangle(cornerRadius: Spacing.CornerRadius.card)
                        .stroke(confirmFieldBorderColor, lineWidth: 1)
                )
                .textContentType(.newPassword)
                .autocorrectionDisabled()

            if let mismatch = mismatchMessage {
                Text(mismatch)
                    .font(.dsCaption1)
                    .foregroundStyle(Color.dsError)
            }
        }
    }

    private var confirmFieldBorderColor: Color {
        if confirmPassword.isEmpty { return Color.dsSeparator }
        return passwordsMatch ? Color.dsSuccess.opacity(0.5) : Color.dsError.opacity(0.5)
    }

    // MARK: - Strength Indicator

    private var strengthIndicator: some View {
        VStack(alignment: .leading, spacing: Spacing.sm) {
            HStack(spacing: Spacing.sm) {
                ForEach(0 ..< 3, id: \.self) { index in
                    RoundedRectangle(cornerRadius: 2)
                        .fill(index < strength.filledSegments ? strength.color : Color.dsSeparator)
                        .frame(maxWidth: .infinity)
                        .frame(height: 4)
                        .animation(.easeInOut(duration: 0.2), value: strength.filledSegments)
                }
            }

            Text(strength.label)
                .font(.dsCaption1)
                .foregroundStyle(strength.color)
                .animation(.easeInOut(duration: 0.15), value: strength.label)
        }
    }

    // MARK: - Protect Button

    private var protectButton: some View {
        Button {
            runProtect()
        } label: {
            HStack(spacing: Spacing.sm) {
                if isProcessing {
                    ProgressView()
                        .progressViewStyle(.circular)
                        .tint(.white)
                        .scaleEffect(0.85)
                } else {
                    Image(systemName: "lock.fill")
                        .font(.system(size: 16, weight: .semibold))
                }
                Text(
                    isProcessing
                        ? String(localized: "protect.button.processing")
                        : String(localized: "protect.button.protect")
                )
                .font(.dsHeadline)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 50)
            .background(isValid ? Color(hex: "#5856D6") : Color.dsTextTertiary)
            .foregroundStyle(.white)
            .clipShape(RoundedRectangle(cornerRadius: Spacing.CornerRadius.button))
            .animation(.easeInOut(duration: 0.15), value: isValid)
        }
        .buttonStyle(.plain)
        .disabled(!isValid || isProcessing)
        .padding(.top, Spacing.sm)
    }

    // MARK: - Success Overlay

    private var successOverlay: some View {
        ZStack {
            Color.black.opacity(0.45).ignoresSafeArea()

            VStack(spacing: Spacing.lg) {
                ZStack {
                    Circle()
                        .fill(Color(hex: "#5856D6").opacity(0.15))
                        .frame(width: 88, height: 88)

                    Image(systemName: "lock.fill")
                        .font(.system(size: 36, weight: .semibold))
                        .foregroundStyle(Color(hex: "#5856D6"))
                }

                VStack(spacing: Spacing.sm) {
                    Text(String(localized: "protect.success.title"))
                        .font(.dsTitle3)
                        .foregroundStyle(Color.dsTextPrimary)

                    Text(String(localized: "protect.success.subtitle"))
                        .font(.dsBody)
                        .foregroundStyle(Color.dsTextSecondary)
                        .multilineTextAlignment(.center)
                }
            }
            .padding(Spacing.xl)
            .background(Color.dsBackground)
            .clipShape(RoundedRectangle(cornerRadius: Spacing.CornerRadius.large))
            .padding(.horizontal, Spacing.xl)
        }
    }

    // MARK: - Actions

    private func runProtect() {
        guard isValid else { return }
        isProcessing = true

        Task { @MainActor in
            do {
                let protectedPDF = try await PDFToolsService.shared.protect(
                    pdf: sourceURL,
                    password: password
                )

                let saveName = "Protected_\(sourceFileName)"
                let doc = try appEnvironment.documentStore.save(pdfDocument: protectedPDF, name: saveName)

                resultDocument = doc
                isProcessing = false
                showSuccessOverlay = true

                try? await Task.sleep(nanoseconds: 1_500_000_000)

                showSuccessOverlay = false
                navigateToViewer = true
            } catch {
                isProcessing = false
                errorMessage = error.localizedDescription
                showError = true
            }
        }
    }
}
