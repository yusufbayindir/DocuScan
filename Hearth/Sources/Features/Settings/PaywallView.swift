import SwiftUI

struct PaywallView: View {
    @Environment(AppState.self) private var appState
    @Environment(\.dismiss) private var dismiss
    @State private var selectedPlan: PaywallPlan = .annual

    enum PaywallPlan { case monthly, annual }

    private let features = [
        ("Unlimited account connections", "link.circle.fill"),
        ("AI Coach insights & analysis", "brain.head.profile"),
        ("Shared goal tracking & milestones", "target"),
        ("Split expense management", "arrow.triangle.branch"),
        ("Monthly financial reports", "doc.text.fill"),
        ("Bill reminders & calendar", "calendar.badge.clock"),
    ]

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: HS.xl) {
                    heroSection
                    featuresSection
                    planSelector
                    ctaSection
                    footerLinks
                }
                .padding(.bottom, HS.xxl)
            }
            .background(
                LinearGradient(
                    colors: [Color.hearthSienna.opacity(0.15), Color.backgroundPrimary],
                    startPoint: .top,
                    endPoint: .init(x: 0.5, y: 0.4)
                )
                .ignoresSafeArea()
            )
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: { dismiss() }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 22))
                            .foregroundColor(.textTertiary)
                    }
                }
            }
        }
    }

    private var heroSection: some View {
        VStack(spacing: HS.md) {
            Text("✨").font(.system(size: 56)).padding(.top, HS.xl)
            Text("Hearth Premium")
                .font(.hearthTitle1)
                .foregroundColor(.textPrimary)
            Text("Everything you need to manage money as a couple.")
                .font(.hearthBody)
                .foregroundColor(.textSecondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, HS.xl)
        }
    }

    private var featuresSection: some View {
        VStack(alignment: .leading, spacing: HS.md) {
            ForEach(features, id: \.0) { (feature, icon) in
                HStack(spacing: HS.md) {
                    Image(systemName: icon)
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.hearthTerracotta)
                        .frame(width: 28)
                    Text(feature)
                        .font(.hearthBody)
                        .foregroundColor(.textPrimary)
                }
            }
        }
        .padding(HS.lg)
        .hearthCard()
        .padding(.horizontal, HS.lg)
    }

    private var planSelector: some View {
        HStack(spacing: HS.md) {
            planCard(
                plan: .annual,
                title: "Annual",
                price: "$59.99",
                period: "/year",
                badge: "Save 50%"
            )
            planCard(
                plan: .monthly,
                title: "Monthly",
                price: "$9.99",
                period: "/month",
                badge: nil
            )
        }
        .padding(.horizontal, HS.lg)
    }

    private func planCard(plan: PaywallPlan, title: String, price: String, period: String, badge: String?) -> some View {
        Button(action: { selectedPlan = plan }) {
            VStack(spacing: HS.sm) {
                if let badge {
                    Text(badge)
                        .font(.hearthCaption2.weight(.bold))
                        .foregroundColor(.white)
                        .padding(.horizontal, HS.sm)
                        .padding(.vertical, 4)
                        .background(Color.hearthTerracotta)
                        .clipShape(Capsule())
                }
                Text(title)
                    .font(.hearthSubheadline)
                    .foregroundColor(.textPrimary)
                HStack(alignment: .firstTextBaseline, spacing: 2) {
                    Text(price)
                        .font(.hearthTitle3)
                        .foregroundColor(.textPrimary)
                    Text(period)
                        .font(.hearthCaption2)
                        .foregroundColor(.textTertiary)
                }
            }
            .frame(maxWidth: .infinity)
            .padding(HS.lg)
            .background(Color.backgroundCard)
            .clipShape(RoundedRectangle(cornerRadius: HR.lg))
            .overlay(
                RoundedRectangle(cornerRadius: HR.lg)
                    .stroke(selectedPlan == plan ? Color.hearthTerracotta : Color.borderSubtle, lineWidth: selectedPlan == plan ? 2 : 1)
            )
        }
        .buttonStyle(ScaleButtonStyle(scale: 0.97))
    }

    private var ctaSection: some View {
        VStack(spacing: HS.md) {
            HearthPrimaryButton(title: "Start 14-Day Free Trial") {
                appState.currentUser.subscriptionTier = .trial
                dismiss()
            }
            .padding(.horizontal, HS.lg)

            Text("No payment required during trial")
                .font(.hearthCaption2)
                .foregroundColor(.textTertiary)
        }
    }

    private var footerLinks: some View {
        HStack(spacing: HS.lg) {
            Button("Restore Purchase") {}
                .font(.hearthCaption2)
                .foregroundColor(.textTertiary)
            Text("•").foregroundColor(.textTertiary)
            Button("Terms") {}
                .font(.hearthCaption2)
                .foregroundColor(.textTertiary)
            Text("•").foregroundColor(.textTertiary)
            Button("Privacy") {}
                .font(.hearthCaption2)
                .foregroundColor(.textTertiary)
        }
    }
}
