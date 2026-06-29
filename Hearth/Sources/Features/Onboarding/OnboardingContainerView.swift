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
                        .transition(.move(edge: .top).combined(with: .opacity))
                }

                // Use ZStack + offset instead of TabView to avoid gesture conflicts
                GeometryReader { geo in
                    HStack(spacing: 0) {
                        WelcomeScreen(onAdvance: { vm.advance() })
                            .frame(width: geo.size.width)

                        YourNameScreen(vm: vm, onAdvance: { vm.advance() })
                            .frame(width: geo.size.width)

                        PartnerNameScreen(vm: vm, onAdvance: { vm.advance() })
                            .frame(width: geo.size.width)

                        PrivacyScreen(onAdvance: { vm.advance() })
                            .frame(width: geo.size.width)

                        HowItWorksScreen(onAdvance: { vm.advance() })
                            .frame(width: geo.size.width)

                        TrialScreen(onAdvance: { vm.advance() })
                            .frame(width: geo.size.width)

                        ReadyScreen(vm: vm)
                            .frame(width: geo.size.width)
                    }
                    .offset(x: -CGFloat(vm.currentStep) * geo.size.width)
                    .animation(.spring(response: 0.4, dampingFraction: 0.85), value: vm.currentStep)
                }
            }
        }
    }

    private var progressBar: some View {
        HStack(spacing: 4) {
            Button(action: { vm.back() }) {
                Image(systemName: "chevron.left")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.textSecondary)
                    .frame(width: 36, height: 36)
                    .contentShape(Rectangle())
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
        .padding(.bottom, HS.sm)
    }
}

// MARK: - Onboarding Screens

private struct WelcomeScreen: View {
    let onAdvance: () -> Void

    var body: some View {
        OnboardingPage(
            emoji: "🏠",
            title: "Welcome to Hearth",
            subtitle: "Where your money comes home.\nFinance designed for couples.",
            buttonLabel: "Get Started",
            showSkip: false,
            action: onAdvance
        )
    }
}

private struct YourNameScreen: View {
    @Bindable var vm: OnboardingViewModel
    let onAdvance: () -> Void

    var body: some View {
        OnboardingInputPage(
            emoji: "👋",
            title: "What's your name?",
            subtitle: "This is how your partner will see you in the app.",
            placeholder: "Your first name",
            text: $vm.yourName,
            buttonLabel: "Continue",
            canAdvance: vm.canAdvance,
            action: onAdvance
        )
    }
}

private struct PartnerNameScreen: View {
    @Bindable var vm: OnboardingViewModel
    let onAdvance: () -> Void

    var body: some View {
        OnboardingInputPage(
            emoji: "💑",
            title: "And your partner's name?",
            subtitle: "You can invite them later — just add their name for now.",
            placeholder: "Partner's first name",
            text: $vm.partnerName,
            buttonLabel: "Continue",
            canAdvance: vm.canAdvance,
            action: onAdvance
        )
    }
}

private struct PrivacyScreen: View {
    let onAdvance: () -> Void

    var body: some View {
        OnboardingPage(
            emoji: "🔒",
            title: "Your privacy, your rules",
            subtitle: "Choose which accounts to share, how much to reveal, and what stays private. Change anytime.",
            buttonLabel: "Sounds good",
            showSkip: false,
            action: onAdvance
        )
    }
}

private struct HowItWorksScreen: View {
    let onAdvance: () -> Void

    var body: some View {
        VStack(spacing: HS.xl) {
            Spacer()
            Text("🤝").font(.system(size: 64))
            Text("Together, better")
                .font(.hearthTitle1)
                .foregroundColor(.textPrimary)

            VStack(alignment: .leading, spacing: HS.lg) {
                featureRow(icon: "chart.bar.fill",     color: .hearthTerracotta,  text: "See all your accounts in one place")
                featureRow(icon: "arrow.triangle.branch", color: .hearthAmber,   text: "Split expenses fairly, automatically")
                featureRow(icon: "target",             color: .semanticSuccessFg, text: "Save toward shared goals together")
                featureRow(icon: "brain.head.profile", color: .hearthDustyRose,   text: "AI coach spots savings opportunities")
            }
            .padding(.horizontal, HS.xl)

            Spacer()

            HearthPrimaryButton(title: "Next", action: onAdvance)
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
    let onAdvance: () -> Void

    var body: some View {
        OnboardingPage(
            emoji: "✨",
            title: "Start your free trial",
            subtitle: "Try Hearth Premium free for 14 days.\nAll features unlocked, no commitment.",
            buttonLabel: "Start Free Trial",
            showSkip: true,
            action: onAdvance
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
            Text("You're all set\(vm.yourName.isEmpty ? "" : ", \(vm.yourName)")!")
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
                    Button("Maybe later", action: action)
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
    @FocusState private var isFocused: Bool

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
                .overlay(RoundedRectangle(cornerRadius: HR.lg).stroke(isFocused ? Color.hearthTerracotta : Color.borderDefault, lineWidth: isFocused ? 2 : 1))
                .padding(.horizontal, HS.lg)
                .focused($isFocused)
                .submitLabel(.done)
                .onSubmit { if canAdvance { action() } }

            Spacer()
            HearthPrimaryButton(title: buttonLabel, isDisabled: !canAdvance, action: action)
                .padding(.horizontal, HS.lg)
                .padding(.bottom, HS.xl)
        }
    }
}
