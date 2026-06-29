// swiftlint:disable file_length
import SwiftUI
import AppTrackingTransparency

// MARK: - Onboarding Page Model

private enum OnboardingPage: Int, CaseIterable {
    case valueProp = 0
    case cameraScan = 1
    case tracking = 2
    case paywall = 3
}

// MARK: - OnboardingViewModel

@MainActor
final class OnboardingViewModel: ObservableObject {
    @Published var currentPage: Int = 0
    @Published var isPurchasing: Bool = false
    @Published var purchaseError: String?
    @Published var showPurchaseError: Bool = false
    @AppStorage("hasCompletedOnboarding") var hasCompletedOnboarding: Bool = false
    @AppStorage("isPremium") var isPremium: Bool = false

    var isLastPage: Bool {
        currentPage == OnboardingPage.allCases.count - 1
    }

    func advance() {
        let nextPage = currentPage + 1
        if nextPage < OnboardingPage.allCases.count {
            withAnimation {
                currentPage = nextPage
            }
        } else {
            complete()
        }
    }

    func complete() {
        hasCompletedOnboarding = true
    }

    func requestTrackingIfNeeded() {
        Task { @MainActor in
            let status = ATTrackingManager.trackingAuthorizationStatus
            guard status == .notDetermined else { return }
            _ = await ATTrackingManager.requestTrackingAuthorization()
        }
    }

    func purchasePremium(iapService: IAPService) {
        guard !isPurchasing else { return }
        isPurchasing = true
        Task { @MainActor [weak self] in
            guard let self else { return }
            do {
                try await iapService.purchase()
                if self.isPremium { self.complete() }
            } catch {
                purchaseError = error.localizedDescription
                showPurchaseError = true
            }
            self.isPurchasing = false
        }
    }

    func restorePurchases(iapService: IAPService) {
        guard !isPurchasing else { return }
        isPurchasing = true
        Task { @MainActor [weak self] in
            guard let self else { return }
            do {
                try await iapService.restore()
                if self.isPremium { self.complete() }
            } catch {
                purchaseError = error.localizedDescription
                showPurchaseError = true
            }
            self.isPurchasing = false
        }
    }
}

// MARK: - OnboardingView

struct OnboardingView: View {
    @StateObject private var viewModel = OnboardingViewModel()
    @EnvironmentObject private var appEnvironment: AppEnvironment

    var body: some View {
        ZStack {
            Color.dsBackground.ignoresSafeArea()

            TabView(selection: $viewModel.currentPage) {
                ValuePropPage(viewModel: viewModel)
                    .tag(OnboardingPage.valueProp.rawValue)

                CameraScanPage(viewModel: viewModel)
                    .tag(OnboardingPage.cameraScan.rawValue)

                TrackingPage(viewModel: viewModel)
                    .tag(OnboardingPage.tracking.rawValue)

                PaywallPage(viewModel: viewModel, iapService: appEnvironment.iapService)
                    .tag(OnboardingPage.paywall.rawValue)
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .animation(.easeInOut, value: viewModel.currentPage)
        }
        .overlay(alignment: .bottom) {
            PageIndicator(
                count: OnboardingPage.allCases.count,
                current: viewModel.currentPage
            )
            .padding(.bottom, Spacing.xl)
        }
        .task {
            await appEnvironment.iapService.loadProducts()
            await appEnvironment.iapService.refreshEntitlements()
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
}

// MARK: - Page Indicator

private struct PageIndicator: View {
    let count: Int
    let current: Int

    var body: some View {
        HStack(spacing: Spacing.sm) {
            ForEach(0..<count, id: \.self) { index in
                Capsule()
                    .fill(index == current ? Color.dsPrimary : Color.dsPrimary.opacity(0.25))
                    .frame(width: index == current ? 24 : 8, height: 8)
                    .animation(.easeInOut, value: current)
            }
        }
    }
}

// MARK: - Page 1: Value Prop

private struct ValuePropPage: View {
    @ObservedObject var viewModel: OnboardingViewModel

    var body: some View {
        VStack(spacing: 0) {
            Spacer()

            VStack(spacing: Spacing.lg) {
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [Color.dsPrimary.opacity(0.15), Color.dsPrimary.opacity(0.05)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 140, height: 140)

                    Image(systemName: "doc.fill")
                        .font(.system(size: 60, weight: .medium))
                        .foregroundStyle(Color.dsPrimary)
                }

                VStack(spacing: Spacing.sm) {
                    Text(String(localized: "onboarding.value_prop.title"))
                        .font(.dsTitle1)
                        .foregroundStyle(Color.dsTextPrimary)
                        .multilineTextAlignment(.center)

                    Text(String(localized: "onboarding.value_prop.subtitle"))
                        .font(.dsBody)
                        .foregroundStyle(Color.dsTextSecondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, Spacing.xl)
                }
            }

            Spacer()
            Spacer()

            VStack(spacing: Spacing.md) {
                PrimaryButton(String(localized: "onboarding.button.get_started"), icon: "arrow.right") {
                    viewModel.advance()
                }

                Text(String(localized: "onboarding.value_prop.legal_note"))
                    .font(.dsCaption1)
                    .foregroundStyle(Color.dsTextTertiary)
                    .multilineTextAlignment(.center)
            }
            .padding(.horizontal, Spacing.lg)
            .padding(.bottom, Spacing.xxl)
        }
    }
}

// MARK: - Page 2: Camera Scan

private struct CameraScanPage: View {
    @ObservedObject var viewModel: OnboardingViewModel

    var body: some View {
        ZStack(alignment: .topTrailing) {
            VStack(spacing: 0) {
                Spacer()

                VStack(spacing: Spacing.lg) {
                    ZStack {
                        RoundedRectangle(cornerRadius: Spacing.CornerRadius.large)
                            .fill(
                                LinearGradient(
                                    colors: [Color.dsAccent.opacity(0.15), Color.dsAccent.opacity(0.05)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 140, height: 140)

                        Image(systemName: "camera.viewfinder")
                            .font(.system(size: 60, weight: .medium))
                            .foregroundStyle(Color.dsAccent)
                    }

                    VStack(spacing: Spacing.sm) {
                        Text(String(localized: "onboarding.camera_scan.title"))
                            .font(.dsTitle1)
                            .foregroundStyle(Color.dsTextPrimary)
                            .multilineTextAlignment(.center)

                        Text(String(localized: "onboarding.camera_scan.subtitle"))
                            .font(.dsBody)
                            .foregroundStyle(Color.dsTextSecondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, Spacing.xl)
                    }

                    VStack(spacing: Spacing.md) {
                        FeatureRow(
                            icon: "doc.text.viewfinder",
                            color: Color.dsPrimary,
                            title: String(localized: "onboarding.camera_scan.feature1_title"),
                            subtitle: String(localized: "onboarding.camera_scan.feature1_subtitle")
                        )
                        FeatureRow(
                            icon: "wand.and.stars",
                            color: Color.dsAccent,
                            title: String(localized: "onboarding.camera_scan.feature2_title"),
                            subtitle: String(localized: "onboarding.camera_scan.feature2_subtitle")
                        )
                        FeatureRow(
                            icon: "lock.shield.fill",
                            color: Color.dsSuccess,
                            title: String(localized: "onboarding.camera_scan.feature3_title"),
                            subtitle: String(localized: "onboarding.camera_scan.feature3_subtitle")
                        )
                    }
                    .padding(.horizontal, Spacing.lg)
                }

                Spacer()
                Spacer()

                PrimaryButton(String(localized: "onboarding.button.next"), icon: "arrow.right") {
                    viewModel.advance()
                }
                .padding(.horizontal, Spacing.lg)
                .padding(.bottom, Spacing.xxl)
            }

            Button {
                viewModel.complete()
            } label: {
                Text(String(localized: "onboarding.button.skip"))
                    .font(.dsCallout)
                    .foregroundStyle(Color.dsTextSecondary)
                    .padding(Spacing.md)
            }
        }
    }
}

private struct FeatureRow: View {
    let icon: String
    let color: Color
    let title: String
    let subtitle: String

    var body: some View {
        HStack(spacing: Spacing.md) {
            ZStack {
                Circle()
                    .fill(color.opacity(0.12))
                    .frame(width: 44, height: 44)

                Image(systemName: icon)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundStyle(color)
            }

            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.dsSubheadline)
                    .fontWeight(.semibold)
                    .foregroundStyle(Color.dsTextPrimary)

                Text(subtitle)
                    .font(.dsCaption1)
                    .foregroundStyle(Color.dsTextSecondary)
            }

            Spacer()
        }
        .padding(Spacing.md)
        .cardStyle()
    }
}

// MARK: - Page 3: Tracking / ATT Pre-Prompt

private struct TrackingPage: View {
    @ObservedObject var viewModel: OnboardingViewModel

    var body: some View {
        VStack(spacing: 0) {
            Spacer()

            VStack(spacing: Spacing.lg) {
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [Color.dsPrimary.opacity(0.15), Color.dsPrimary.opacity(0.05)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 140, height: 140)

                    Image(systemName: "hand.raised.fill")
                        .font(.system(size: 60, weight: .medium))
                        .foregroundStyle(Color.dsPrimary)
                }

                VStack(spacing: Spacing.sm) {
                    Text(String(localized: "onboarding.tracking.title"))
                        .font(.dsTitle1)
                        .foregroundStyle(Color.dsTextPrimary)
                        .multilineTextAlignment(.center)

                    Text(String(localized: "onboarding.tracking.subtitle"))
                        .font(.dsBody)
                        .foregroundStyle(Color.dsTextSecondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, Spacing.lg)
                }

                VStack(spacing: Spacing.md) {
                    TrackingBullet(
                        icon: "chart.bar.fill",
                        text: String(localized: "onboarding.tracking.bullet1")
                    )
                    TrackingBullet(
                        icon: "rectangle.3.group.fill",
                        text: String(localized: "onboarding.tracking.bullet2")
                    )
                    TrackingBullet(
                        icon: "person.fill.xmark",
                        text: String(localized: "onboarding.tracking.bullet3")
                    )
                }
                .padding(.horizontal, Spacing.lg)
            }

            Spacer()
            Spacer()

            VStack(spacing: Spacing.sm) {
                PrimaryButton(String(localized: "onboarding.tracking.button.continue")) {
                    viewModel.requestTrackingIfNeeded()
                    viewModel.advance()
                }

                Text(String(localized: "onboarding.tracking.footer"))
                    .font(.dsCaption1)
                    .foregroundStyle(Color.dsTextTertiary)
                    .multilineTextAlignment(.center)
            }
            .padding(.horizontal, Spacing.lg)
            .padding(.bottom, Spacing.xxl)
        }
    }
}

private struct TrackingBullet: View {
    let icon: String
    let text: String

    var body: some View {
        HStack(spacing: Spacing.md) {
            Image(systemName: icon)
                .font(.system(size: 16, weight: .semibold))
                .foregroundStyle(Color.dsPrimary)
                .frame(width: 32)

            Text(text)
                .font(.dsCallout)
                .foregroundStyle(Color.dsTextSecondary)
                .fixedSize(horizontal: false, vertical: true)

            Spacer()
        }
    }
}

// MARK: - Page 4: Paywall

private struct PaywallPage: View {
    @ObservedObject var viewModel: OnboardingViewModel
    let iapService: IAPService

    var body: some View {
        VStack(spacing: 0) {
            Spacer()

            VStack(spacing: Spacing.lg) {
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [Color.dsAccent.opacity(0.2), Color.dsAccent.opacity(0.05)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 140, height: 140)

                    Image(systemName: "crown.fill")
                        .font(.system(size: 60, weight: .medium))
                        .foregroundStyle(Color.dsAccent)
                }

                VStack(spacing: Spacing.sm) {
                    Text(String(localized: "onboarding.paywall.title"))
                        .font(.dsTitle1)
                        .foregroundStyle(Color.dsTextPrimary)
                        .multilineTextAlignment(.center)

                    Text(String(localized: "onboarding.paywall.subtitle"))
                        .font(.dsBody)
                        .foregroundStyle(Color.dsTextSecondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, Spacing.xl)
                }

                VStack(spacing: Spacing.sm) {
                    PaywallBenefit(icon: "xmark.circle.fill", text: String(localized: "onboarding.paywall.benefit1"))
                    PaywallBenefit(icon: "bolt.fill", text: String(localized: "onboarding.paywall.benefit2"))
                    PaywallBenefit(
                        icon: "arrow.clockwise.heart.fill",
                        text: String(localized: "onboarding.paywall.benefit3")
                    )
                }
                .padding(.horizontal, Spacing.lg)

                // Price badge
                HStack(spacing: Spacing.xs) {
                    Text(String(localized: "onboarding.paywall.price_label"))
                        .font(.dsFootnote)
                        .foregroundStyle(Color.dsTextSecondary)

                    Text(String(localized: "onboarding.paywall.price"))
                        .font(.dsHeadline)
                        .foregroundStyle(Color.dsPrimary)
                        .fontWeight(.bold)

                    Text(String(localized: "onboarding.paywall.price_period"))
                        .font(.dsFootnote)
                        .foregroundStyle(Color.dsTextSecondary)
                }
                .padding(.horizontal, Spacing.lg)
                .padding(.vertical, Spacing.sm)
                .background(Color.dsPrimary.opacity(0.08))
                .clipShape(Capsule())
            }

            Spacer()
            Spacer()

            VStack(spacing: Spacing.sm) {
                PrimaryButton(
                    String(localized: "onboarding.paywall.button.buy"),
                    icon: "crown.fill"
                ) {
                    viewModel.purchasePremium(iapService: iapService)
                }
                .disabled(viewModel.isPurchasing)
                .opacity(viewModel.isPurchasing ? 0.6 : 1)

                HStack(spacing: Spacing.lg) {
                    Button {
                        viewModel.restorePurchases(iapService: iapService)
                    } label: {
                        Text(String(localized: "onboarding.paywall.button.restore"))
                            .font(.dsCallout)
                            .foregroundStyle(Color.dsPrimary)
                    }

                    Text("·")
                        .foregroundStyle(Color.dsTextTertiary)

                    Button {
                        viewModel.complete()
                    } label: {
                        Text(String(localized: "onboarding.paywall.button.skip"))
                            .font(.dsCallout)
                            .foregroundStyle(Color.dsTextSecondary)
                    }
                }
            }
            .padding(.horizontal, Spacing.lg)
            .padding(.bottom, Spacing.xxl)
        }
    }
}

private struct PaywallBenefit: View {
    let icon: String
    let text: String

    var body: some View {
        HStack(spacing: Spacing.md) {
            Image(systemName: icon)
                .font(.system(size: 18, weight: .semibold))
                .foregroundStyle(Color.dsAccent)
                .frame(width: 28)

            Text(text)
                .font(.dsCallout)
                .foregroundStyle(Color.dsTextPrimary)

            Spacer()
        }
        .padding(.vertical, Spacing.xs)
    }
}
