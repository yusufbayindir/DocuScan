import SwiftUI

struct AICoachDetailView: View {
    @Environment(AppState.self) private var appState
    @Environment(\.dismiss) private var dismiss
    let insight: AIInsight

    private var iconName: String {
        switch insight.type {
        case .proactiveWarning:  return "exclamationmark.triangle.fill"
        case .positiveInsight:   return "star.fill"
        case .subscriptionAlert: return "repeat.circle.fill"
        case .monthlyRecap:      return "chart.bar.fill"
        case .goalProgress:      return "target"
        }
    }

    private var accentColor: Color {
        switch insight.severity {
        case .low:      return .semanticSuccessFg
        case .medium:   return .hearthAmber
        case .high:     return .hearthTerracotta
        case .critical: return .semanticErrorFg
        }
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: HS.xl) {
                    iconHeader
                    messageCard
                    if insight.type == .subscriptionAlert {
                        subscriptionsSection
                    }
                    actionSection
                }
                .padding(.bottom, HS.xxl)
            }
            .background(Color.backgroundPrimary)
            .navigationTitle("AI Coach")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") { dismiss() }.foregroundColor(.hearthTerracotta)
                }
            }
        }
    }

    private var iconHeader: some View {
        VStack(spacing: HS.md) {
            ZStack {
                Circle()
                    .fill(accentColor.opacity(0.15))
                    .frame(width: 80, height: 80)
                Image(systemName: iconName)
                    .font(.system(size: 36, weight: .medium))
                    .foregroundColor(accentColor)
            }
            .padding(.top, HS.xl)

            Text(insight.type.displayName)
                .font(.hearthCaption1)
                .foregroundColor(accentColor)
                .padding(.horizontal, HS.md)
                .padding(.vertical, 6)
                .background(accentColor.opacity(0.12))
                .clipShape(Capsule())
        }
    }

    private var messageCard: some View {
        Text(insight.message)
            .font(.hearthBody)
            .foregroundColor(.textPrimary)
            .multilineTextAlignment(.center)
            .padding(HS.xl)
            .hearthCard()
            .padding(.horizontal, HS.lg)
    }

    private var subscriptionsSection: some View {
        let subCatId = appState.categories.first { $0.name == "Subscriptions" }?.id
        let subs = appState.transactions.filter { $0.categoryId == subCatId }

        return VStack(spacing: 0) {
            SectionHeader(title: "Your Subscriptions")
            ForEach(subs) { sub in
                HStack {
                    Text(sub.merchantName)
                        .font(.hearthBody)
                        .foregroundColor(.textPrimary)
                    Spacer()
                    Text(sub.amount, format: .currency(code: "USD"))
                        .font(.hearthSmallAmount)
                        .foregroundColor(.textPrimary)
                }
                .padding(.horizontal, HS.lg)
                .padding(.vertical, HS.md)
                Divider().padding(.horizontal, HS.lg)
            }
        }
    }

    private var actionSection: some View {
        VStack(spacing: HS.md) {
            if let label = insight.actionLabel {
                HearthPrimaryButton(title: label) { dismiss() }
                    .padding(.horizontal, HS.lg)
            }
            Button(action: {
                appState.dismissInsight(insight)
                dismiss()
            }) {
                Text("Dismiss")
                    .font(.hearthFootnote)
                    .foregroundColor(.textTertiary)
            }
        }
    }
}

extension InsightType {
    var displayName: String {
        switch self {
        case .proactiveWarning:  return "Spending Alert"
        case .positiveInsight:   return "Great News"
        case .subscriptionAlert: return "Subscription Review"
        case .monthlyRecap:      return "Monthly Recap"
        case .goalProgress:      return "Goal Update"
        }
    }
}
