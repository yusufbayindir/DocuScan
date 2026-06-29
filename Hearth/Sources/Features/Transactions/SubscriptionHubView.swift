import SwiftUI

struct SubscriptionHubView: View {
    @Environment(AppState.self) private var appState
    @Environment(\.dismiss) private var dismiss

    private var subscriptions: [Transaction] {
        let subCatId = appState.categories.first { $0.name == "Subscriptions" }?.id
        return appState.transactions
            .filter { $0.categoryId == subCatId }
            .sorted { $0.amount > $1.amount }
    }

    private var totalMonthly: Double { subscriptions.reduce(0) { $0 + $1.amount } }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: HS.xl) {
                    summaryCard
                    subscriptionList
                }
                .padding(.bottom, HS.xxl)
            }
            .background(Color.backgroundPrimary)
            .navigationTitle("Subscriptions")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") { dismiss() }.foregroundColor(.hearthTerracotta)
                }
            }
        }
    }

    private var summaryCard: some View {
        VStack(spacing: HS.md) {
            Text("Total Monthly")
                .font(.hearthCaption1)
                .foregroundColor(.textTertiary)
            Text(totalMonthly, format: .currency(code: "USD"))
                .font(.hearthAmount)
                .foregroundColor(.textPrimary)
            Text("\(subscriptions.count) active subscriptions")
                .font(.hearthFootnote)
                .foregroundColor(.textSecondary)
        }
        .frame(maxWidth: .infinity)
        .padding(HS.xl)
        .hearthCard()
        .padding(.horizontal, HS.lg)
        .padding(.top, HS.lg)
    }

    private var subscriptionList: some View {
        VStack(spacing: 0) {
            ForEach(subscriptions) { sub in
                HStack(spacing: HS.md) {
                    ZStack {
                        RoundedRectangle(cornerRadius: HR.sm)
                            .fill(Color.hearthTerracotta.opacity(0.12))
                            .frame(width: 40, height: 40)
                        Image(systemName: "repeat.circle.fill")
                            .font(.system(size: 20))
                            .foregroundColor(.hearthTerracotta)
                    }
                    VStack(alignment: .leading, spacing: 2) {
                        Text(sub.merchantName)
                            .font(.hearthBody)
                            .foregroundColor(.textPrimary)
                        if sub.isSplit, let split = sub.splitAmount {
                            Text("Your share: \(split.formatted(.currency(code: "USD")))")
                                .font(.hearthCaption2)
                                .foregroundColor(.hearthAmber)
                        }
                    }
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
}
