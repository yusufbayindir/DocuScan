import SwiftUI

struct OnboardingContainerView: View {
    @Environment(AppState.self) private var appState
    @State private var vm = OnboardingViewModel()

    var body: some View {
        ZStack {
            Color.backgroundPrimary.ignoresSafeArea()

            VStack(spacing: 0) {
                if vm.currentStep > 0 {
                    progressBar
                }

                TabView(selection: $vm.currentStep) {
                    WelcomeScreen().tag(0)
                    YourNameScreen(vm: vm).tag(1)
                    PartnerNameScreen(vm: vm).tag(2)
                    PrivacyScreen(vm: vm).tag(3)
                    HowItWorksScreen().tag(4)
                    TrialScreen().tag(5)
                    ReadyScreen(vm: vm).tag(6)
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                .animation(.spring(response: 0.4, dampingFraction: 0.85), value: vm.currentStep)
            }
        }
    }

    private var progressBar: some View {
        HStack(spacing: 4) {
            if vm.currentStep > 0 {
                Button(action: { vm.back() }) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.textSecondary)
                        .frame(width: 36, height: 36)
                }
            }
            ForEach(1..<vm.totalSteps, id: \.self) { step in
                RoundedRectangle(cornerRadius: 2)
                    .fill(step <= vm.currentStep ? Color.hearthTerracotta : Color.backgroundTertiary)
                    .frame(height: 4)
                    .animation(.easeInOut(duration: 0.3), value: vm.currentStep)
            }
        }
        .padding(.horizontal, HS.lg)
        .padding(.top, HS.md)
    }
}

// MARK: - Onboarding Screens

private struct WelcomeScreen: View {
    var body: some View {
        OnboardingPage(
            emoji: "🏠",
            title: "Welcome to Hearth",
            subtitle: "Where your money comes home.\nFinance designed for couples.",
            buttonLabel: "Get Started",
            showSkip: false,
            action: {}
        )
    }
}

private struct YourNameScreen: View {
    @Bindable var vm: OnboardingViewModel
    var body: some View {
        OnboardingInputPage(
            emoji: "👋",
            title: "What's your name?",
            subtitle: "This is how your partner will see you in the app.",
            placeholder: "Your first name",
            text: $vm.yourName,
            buttonLabel: "Continue",
            canAdvance: vm.canAdvance,
            action: { vm.advance() }
        )
    }
}

private struct PartnerNameScreen: View {
    @Bindable var vm: OnboardingViewModel
    var body: some View {
        OnboardingInputPage(
            emoji: "💑",
            title: "And your partner's name?",
            subtitle: "You can invite them later — just add their name for now.",
            placeholder: "Partner's first name",
            text: $vm.partnerName,
            buttonLabel: "Continue",
            canAdvance: vm.canAdvance,
            action: { vm.advance() }
        )
    }
}

private struct PrivacyScreen: View {
    @Bindable var vm: OnboardingViewModel
    var body: some View {
        OnboardingPage(
            emoji: "🔒",
            title: "Your privacy, your rules",
            subtitle: "Choose which accounts to share, how much to reveal, and what stays private. Change anytime.",
            buttonLabel: "Sounds good",
            showSkip: false,
            action: { vm.advance() }
        )
    }
}

private struct HowItWorksScreen: View {
    @Environment(AppState.self) private var appState
    @State private var vm: OnboardingViewModel?

    init() {}

    var body: some View {
        VStack(spacing: HS.xl) {
            Spacer()
            Text("🤝").font(.system(size: 64))
            Text("Together, better")
                .font(.hearthTitle1)
                .foregroundColor(.textPrimary)

            VStack(alignment: .leading, spacing: HS.lg) {
                featureRow(icon: "chart.bar.fill",   color: .hearthTerracotta, text: "See all your accounts in one place")
                featureRow(icon: "arrow.triangle.branch", color: .hearthAmber,     text: "Split expenses fairly, automatically")
                featureRow(icon: "target",            color: .semanticSuccessFg, text: "Save toward shared goals together")
                featureRow(icon: "brain.head.profile", color: .hearthDustyRose,  text: "AI coach spots savings opportunities")
            }
            .padding(.horizontal, HS.xl)

            Spacer()

            HearthPrimaryButton(title: "Next") {
                // advance handled by container's TabView
            }
            .padding(.horizontal, HS.lg)
            .padding(.bottom, HS.xl)
        }
    }

    private func featureRow(icon: String, color: Color, text: String) -> some View {
        HStack(spacing: HS.md) {
            Image(systemName: icon)
                .font(.system(size: 18, weight: .medium))
                .foregroundColor(color)
                .frame(width: 36, height: 36)
                .background(color.opacity(0.12))
                .clipShape(RoundedRectangle(cornerRadius: HR.sm))
            Text(text)
                .font(.hearthBody)
                .foregroundColor(.textPrimary)
        }
    }
}

private struct TrialScreen: View {
    var body: some View {
        OnboardingPage(
            emoji: "✨",
            title: "Start your free trial",
            subtitle: "Try Hearth Premium free for 14 days.\nAll features unlocked, no commitment.",
            buttonLabel: "Start Free Trial",
            showSkip: true,
            action: {}
        )
    }
}

private struct ReadyScreen: View {
    @Bindable var vm: OnboardingViewModel
    @Environment(AppState.self) private var appState

    var body: some View {
        VStack(spacing: HS.xl) {
            Spacer()
            Text("🎉").font(.system(size: 72))
            Text("You're all set, \(vm.yourName.isEmpty ? "there" : vm.yourName)!")
                .font(.hearthTitle1)
                .foregroundColor(.textPrimary)
                .multilineTextAlignment(.center)
            Text("Hearth is ready.\nYour financial journey together starts now.")
                .font(.hearthBody)
                .foregroundColor(.textSecondary)
                .multilineTextAlignment(.center)
            Spacer()
            HearthPrimaryButton(title: "Enter Hearth") {
                vm.completeOnboarding(appState: appState)
            }
            .padding(.horizontal, HS.lg)
            .padding(.bottom, HS.xl)
        }
    }
}

// MARK: - Reusable page shells

private struct OnboardingPage: View {
    let emoji: String
    let title: String
    let subtitle: String
    let buttonLabel: String
    var showSkip: Bool = true
    let action: () -> Void

    var body: some View {
        VStack(spacing: HS.xl) {
            Spacer()
            Text(emoji).font(.system(size: 72))
            VStack(spacing: HS.md) {
                Text(title)
                    .font(.hearthTitle1)
                    .foregroundColor(.textPrimary)
                    .multilineTextAlignment(.center)
                Text(subtitle)
                    .font(.hearthBody)
                    .foregroundColor(.textSecondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, HS.xl)
            }
            Spacer()
            VStack(spacing: HS.md) {
                HearthPrimaryButton(title: buttonLabel, action: action)
                if showSkip {
                    Button("Maybe later") {}
                        .font(.hearthFootnote)
                        .foregroundColor(.textTertiary)
                }
            }
            .padding(.horizontal, HS.lg)
            .padding(.bottom, HS.xl)
        }
    }
}

private struct OnboardingInputPage: View {
    let emoji: String
    let title: String
    let subtitle: String
    let placeholder: String
    @Binding var text: String
    let buttonLabel: String
    let canAdvance: Bool
    let action: () -> Void

    var body: some View {
        VStack(spacing: HS.xl) {
            Spacer()
            Text(emoji).font(.system(size: 72))
            VStack(spacing: HS.md) {
                Text(title)
                    .font(.hearthTitle1)
                    .foregroundColor(.textPrimary)
                Text(subtitle)
                    .font(.hearthBody)
                    .foregroundColor(.textSecondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, HS.xl)
            }

            TextField(placeholder, text: $text)
                .font(.hearthTitle3)
                .foregroundColor(.textPrimary)
                .multilineTextAlignment(.center)
                .padding(HS.lg)
                .background(Color.backgroundCard)
                .clipShape(RoundedRectangle(cornerRadius: HR.lg))
                .overlay(RoundedRectangle(cornerRadius: HR.lg).stroke(Color.borderDefault, lineWidth: 1))
                .padding(.horizontal, HS.lg)

            Spacer()
            HearthPrimaryButton(title: buttonLabel, isDisabled: !canAdvance, action: action)
                .padding(.horizontal, HS.lg)
                .padding(.bottom, HS.xl)
        }
    }
}
