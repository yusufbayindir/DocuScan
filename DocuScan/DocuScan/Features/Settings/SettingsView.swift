// swiftlint:disable file_length
import SwiftUI
import StoreKit
import SafariServices

// MARK: - SettingsViewModel

@MainActor
final class SettingsViewModel: ObservableObject {
    @AppStorage("isPremium") var isPremium: Bool = false
    @Published var showShareSheet = false
    @Published var purchaseError: String?
    @Published var showPurchaseError = false

    private let reviewCooldownDays: Double = 7
    private let lastReviewRequestKey = "settings.lastReviewRequestDate"

    // MARK: - Rate Us

    func requestReviewIfAppropriate(scene: UIWindowScene) {
        let now = Date()
        let lastRequestDate = UserDefaults.standard.object(forKey: lastReviewRequestKey) as? Date

        if let lastDate = lastRequestDate {
            let daysSinceLast = now.timeIntervalSince(lastDate) / 86_400
            guard daysSinceLast >= reviewCooldownDays else { return }
        }

        SKStoreReviewController.requestReview(in: scene)
        UserDefaults.standard.set(now, forKey: lastReviewRequestKey)
    }

    // MARK: - Language

    func openLanguageSettings() {
        guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
        UIApplication.shared.open(url)
    }

    // MARK: - Share

    var appStoreURL: URL {
        // Replace with real App Store URL when live
        URL(string: "https://apps.apple.com/app/docuscan/id000000000") ?? fallbackURL
    }

    // MARK: - Legal URLs

    var privacyPolicyURL: URL {
        URL(string: "https://docuscan.app/privacy") ?? fallbackURL
    }

    var termsOfUseURL: URL {
        URL(string: "https://docuscan.app/terms") ?? fallbackURL
    }

    private var fallbackURL: URL {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "apple.com"
        return components.url ?? URL(fileURLWithPath: "/")
    }

    // MARK: - App Version

    var appVersion: String {
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0"
        let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "1"
        return "\(version) (\(build))"
    }
}

// MARK: - SettingsView

struct SettingsView: View {
    @StateObject private var viewModel = SettingsViewModel()
    @EnvironmentObject private var appEnvironment: AppEnvironment
    @State private var showShareSheet = false
    @State private var showPrivacyPolicy = false
    @State private var showTermsOfUse = false

    var body: some View {
        NavigationStack {
            List {
                // MARK: Section 1: Premium
                premiumSection

                // MARK: Section 2: App
                appSection

                // MARK: Section 3: Legal
                legalSection

                // MARK: Section 4: About
                aboutSection
            }
            .listStyle(.insetGrouped)
            .navigationTitle(String(localized: "settings.title"))
            .navigationBarTitleDisplayMode(.large)
            .sheet(isPresented: $showShareSheet) {
                ShareSheet(items: [viewModel.appStoreURL])
            }
            .sheet(isPresented: $showPrivacyPolicy) {
                SafariView(url: viewModel.privacyPolicyURL)
                    .ignoresSafeArea()
            }
            .sheet(isPresented: $showTermsOfUse) {
                SafariView(url: viewModel.termsOfUseURL)
                    .ignoresSafeArea()
            }
            .alert(
                String(localized: "error.title"),
                isPresented: $viewModel.showPurchaseError,
                presenting: viewModel.purchaseError
            ) { _ in
                Button(String(localized: "button.ok")) {
                    viewModel.showPurchaseError = false
                }
            } message: { msg in
                Text(msg)
            }
        }
        .task {
            await appEnvironment.iapService.loadProducts()
            await appEnvironment.iapService.refreshEntitlements()
        }
    }

    // MARK: - Premium Section

    private var premiumSection: some View {
        Section {
            if viewModel.isPremium {
                HStack {
                    SettingsRowIcon(systemName: "crown.fill", color: Color.dsAccent)

                    Text(String(localized: "settings.premium.active_title"))
                        .font(.dsBody)
                        .foregroundStyle(Color.dsTextPrimary)

                    Spacer()

                    Text(String(localized: "settings.premium.active_badge"))
                        .font(.dsCaption1)
                        .fontWeight(.semibold)
                        .foregroundStyle(.white)
                        .padding(.horizontal, Spacing.sm)
                        .padding(.vertical, Spacing.xs)
                        .background(Color.dsSuccess)
                        .clipShape(Capsule())
                }
            } else {
                HStack {
                    SettingsRowIcon(systemName: "crown.fill", color: Color.dsAccent)

                    VStack(alignment: .leading, spacing: 2) {
                        Text(String(localized: "settings.premium.remove_ads_title"))
                            .font(.dsBody)
                            .foregroundStyle(Color.dsTextPrimary)

                        Text(String(localized: "settings.premium.remove_ads_subtitle"))
                            .font(.dsCaption1)
                            .foregroundStyle(Color.dsTextSecondary)
                    }

                    Spacer()

                    Button {
                        Task {
                            do {
                                try await appEnvironment.iapService.purchase()
                            } catch {
                                viewModel.purchaseError = error.localizedDescription
                                viewModel.showPurchaseError = true
                            }
                        }
                    } label: {
                        Group {
                            if appEnvironment.iapService.isPurchasing {
                                ProgressView()
                                    .tint(.white)
                                    .scaleEffect(0.75)
                            } else {
                                Text(appEnvironment.iapService.monthlyProduct?.displayPrice
                                    ?? String(localized: "settings.premium.price"))
                                    .font(.dsCallout)
                                    .fontWeight(.semibold)
                                    .foregroundStyle(.white)
                            }
                        }
                        .frame(minWidth: 60)
                        .padding(.horizontal, Spacing.sm)
                        .padding(.vertical, Spacing.xs)
                        .background(Color.dsPrimary)
                        .clipShape(Capsule())
                    }
                    .buttonStyle(.plain)
                    .disabled(appEnvironment.iapService.isPurchasing)
                }
            }
        } header: {
            Text(String(localized: "settings.section.premium"))
                .font(.dsCaption1)
                .foregroundStyle(Color.dsTextSecondary)
                .textCase(.uppercase)
        }
    }

    // MARK: - App Section

    private var appSection: some View {
        Section {
            // Language
            Button {
                viewModel.openLanguageSettings()
            } label: {
                HStack {
                    SettingsRowIcon(systemName: "globe", color: Color.dsPrimary)

                    Text(String(localized: "settings.app.language"))
                        .font(.dsBody)
                        .foregroundStyle(Color.dsTextPrimary)

                    Spacer()

                    Image(systemName: "arrow.up.forward.app")
                        .font(.system(size: 13, weight: .medium))
                        .foregroundStyle(Color.dsTextTertiary)
                }
            }

            // Share App
            Button {
                showShareSheet = true
            } label: {
                HStack {
                    SettingsRowIcon(systemName: "square.and.arrow.up", color: Color.dsAccent)

                    Text(String(localized: "settings.app.share"))
                        .font(.dsBody)
                        .foregroundStyle(Color.dsTextPrimary)

                    Spacer()

                    Image(systemName: "chevron.right")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundStyle(Color.dsTextTertiary)
                }
            }

            // Rate Us
            RateUsButton(viewModel: viewModel)

        } header: {
            Text(String(localized: "settings.section.app"))
                .font(.dsCaption1)
                .foregroundStyle(Color.dsTextSecondary)
                .textCase(.uppercase)
        }
    }

    // MARK: - Legal Section

    private var legalSection: some View {
        Section {
            Button {
                showPrivacyPolicy = true
            } label: {
                HStack {
                    SettingsRowIcon(systemName: "hand.raised.fill", color: Color.dsPrimary)

                    Text(String(localized: "settings.legal.privacy_policy"))
                        .font(.dsBody)
                        .foregroundStyle(Color.dsTextPrimary)

                    Spacer()

                    Image(systemName: "chevron.right")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundStyle(Color.dsTextTertiary)
                }
            }

            Button {
                showTermsOfUse = true
            } label: {
                HStack {
                    SettingsRowIcon(systemName: "doc.text.fill", color: Color.dsPrimary)

                    Text(String(localized: "settings.legal.terms_of_use"))
                        .font(.dsBody)
                        .foregroundStyle(Color.dsTextPrimary)

                    Spacer()

                    Image(systemName: "chevron.right")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundStyle(Color.dsTextTertiary)
                }
            }
        } header: {
            Text(String(localized: "settings.section.legal"))
                .font(.dsCaption1)
                .foregroundStyle(Color.dsTextSecondary)
                .textCase(.uppercase)
        }
    }

    // MARK: - About Section

    private var aboutSection: some View {
        Section {
            HStack {
                SettingsRowIcon(systemName: "info.circle.fill", color: Color.dsTextTertiary)

                Text(String(localized: "settings.about.app_name"))
                    .font(.dsBody)
                    .foregroundStyle(Color.dsTextPrimary)

                Spacer()

                Text(viewModel.appVersion)
                    .font(.dsCallout)
                    .foregroundStyle(Color.dsTextSecondary)
            }
        } header: {
            Text(String(localized: "settings.section.about"))
                .font(.dsCaption1)
                .foregroundStyle(Color.dsTextSecondary)
                .textCase(.uppercase)
        }
    }
}

// MARK: - Rate Us Button (uses UIWindowScene for requestReview)

private struct RateUsButton: View {
    @ObservedObject var viewModel: SettingsViewModel
    @State private var windowScene: UIWindowScene?

    var body: some View {
        Button {
            if let scene = windowScene {
                viewModel.requestReviewIfAppropriate(scene: scene)
            }
        } label: {
            HStack {
                SettingsRowIcon(systemName: "star.fill", color: Color.dsWarning)

                Text(String(localized: "settings.app.rate_us"))
                    .font(.dsBody)
                    .foregroundStyle(Color.dsTextPrimary)

                Spacer()

                Image(systemName: "chevron.right")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(Color.dsTextTertiary)
            }
        }
        .onAppear {
            windowScene = UIApplication.shared.connectedScenes
                .compactMap { $0 as? UIWindowScene }
                .first { $0.activationState == .foregroundActive }
        }
    }
}

// MARK: - Settings Row Icon

private struct SettingsRowIcon: View {
    let systemName: String
    let color: Color

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 7)
                .fill(color)
                .frame(width: 30, height: 30)

            Image(systemName: systemName)
                .font(.system(size: 14, weight: .semibold))
                .foregroundStyle(.white)
        }
        .padding(.trailing, Spacing.xs)
    }
}

// MARK: - Share Sheet

private struct ShareSheet: UIViewControllerRepresentable {
    let items: [Any]

    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: items, applicationActivities: nil)
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}

// MARK: - Safari View

private struct SafariView: UIViewControllerRepresentable {
    let url: URL

    func makeUIViewController(context: Context) -> some UIViewController {
        let safariVC = SFSafariViewControllerWrapper(url: url)
        return safariVC
    }

    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}
}

// MARK: - SFSafariViewController wrapper

private final class SFSafariViewControllerWrapper: UIViewController {
    private let url: URL

    init(url: URL) {
        self.url = url
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) not supported")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        let safariVC = SFSafariViewController(url: url)
        addChild(safariVC)
        view.addSubview(safariVC.view)
        safariVC.view.frame = view.bounds
        safariVC.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        safariVC.didMove(toParent: self)
    }
}
