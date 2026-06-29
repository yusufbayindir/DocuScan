import SwiftUI
import Charts

struct MonthlyReportView: View {
    @Environment(AppState.self) private var appState
    @Environment(\.dismiss) private var dismiss

    private var monthName: String {
        let fmt = DateFormatter()
        fmt.dateFormat = "MMMM yyyy"
        return fmt.string(from: Date())
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: HS.xl) {
                    headerSection
                    netWorthCard
                    spendingByCategoryChart
                    goalProgressSection
                    topTransactionsSection
                }
                .padding(.bottom, HS.xxl)
            }
            .background(Color.backgroundPrimary)
            .navigationTitle("\(monthName) Report")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") { dismiss() }.foregroundColor(.hearthTerracotta)
                }
            }
        }
    }

    private var headerSection: some View {
        ZStack {
            LinearGradient(
                colors: [Color.hearthTerracotta, Color.hearthSienna],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            VStack(spacing: HS.sm) {
                Text("📊 \(monthName)")
                    .font(.hearthHeadline)
                    .foregroundColor(.white)
                Text("Financial Report")
                    .font(.hearthTitle2)
                    .foregroundColor(.white)
                StackedPartnerAvatars(
                    nameA: appState.currentUser.name,
                    nameB: appState.partner?.name,
                    size: .md
                )
                .padding(.top, HS.sm)
            }
            .padding(.vertical, HS.xl)
        }
        .clipShape(RoundedRectangle(cornerRadius: HR.xl))
        .padding(.horizontal, HS.lg)
        .padding(.top, HS.lg)
        .shadowMedium()
    }

    private var netWorthCard: some View {
        HStack(spacing: 0) {
            VStack(alignment: .leading, spacing: 4) {
                Text("Net Worth")
                    .font(.hearthCaption2)
                    .foregroundColor(.textTertiary)
                Text(appState.combinedBalance, format: .currency(code: "USD"))
                    .font(.hearthMediumAmount)
                    .foregroundColor(.textPrimary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            Divider().frame(height: 40)

            VStack(alignment: .trailing, spacing: 4) {
                Text("Total Spent")
                    .font(.hearthCaption2)
                    .foregroundColor(.textTertiary)
                Text(appState.totalMonthlySpend(), format: .currency(code: "USD"))
                    .font(.hearthMediumAmount)
                    .foregroundColor(.semanticErrorFg)
            }
            .frame(maxWidth: .infinity, alignment: .trailing)
        }
        .padding(HS.lg)
        .hearthCard()
        .padding(.horizontal, HS.lg)
    }

    private var spendingByCategoryChart: some View {
        VStack(alignment: .leading, spacing: HS.md) {
            SectionHeader(title: "Spending Breakdown")

            let data = appState.spendByCategory()
            if !data.isEmpty {
                Chart(data, id: \.0.id) { (cat, amount) in
                    BarMark(
                        x: .value("Amount", amount),
                        y: .value("Category", cat.name)
                    )
                    .foregroundStyle(Color(hex: cat.colorHex).gradient)
                    .annotation(position: .trailing) {
                        Text(amount.formatted(.currency(code: "USD").precision(.fractionLength(0))))
                            .font(.hearthCaption2)
                            .foregroundColor(.textTertiary)
                    }
                }
                .chartXAxis(.hidden)
                .frame(height: CGFloat(data.count) * 40)
                .padding(.horizontal, HS.lg)
            }
        }
    }

    private var goalProgressSection: some View {
        VStack(spacing: HS.md) {
            SectionHeader(title: "Goal Progress")
            ForEach(appState.goals) { goal in
                HStack {
                    Text(goal.emoji).font(.system(size: 20))
                    Text(goal.name).font(.hearthBody).foregroundColor(.textPrimary)
                    Spacer()
                    let progress = (goal.partnerAContribution + goal.partnerBContribution) / goal.targetAmount
                    Text("\(Int(progress * 100))%")
                        .font(.hearthCaption1.weight(.semibold))
                        .foregroundColor(.hearthTerracotta)
                }
                .padding(.horizontal, HS.lg)
                HearthProgressBar(
                    value: goal.partnerAContribution + goal.partnerBContribution,
                    total: goal.targetAmount,
                    height: 6
                )
                .padding(.horizontal, HS.lg)
            }
        }
    }

    private var topTransactionsSection: some View {
        VStack(spacing: 0) {
            SectionHeader(title: "Top Transactions")
            ForEach(appState.transactions.filter { !$0.isIncome }.sorted { $0.amount > $1.amount }.prefix(5)) { tx in
                TransactionRow(
                    transaction: tx,
                    category: appState.category(for: tx.categoryId)
                )
                Divider().padding(.horizontal, HS.lg)
            }
        }
    }
}
