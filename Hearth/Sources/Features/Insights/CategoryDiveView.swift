import SwiftUI
import Charts

struct CategoryDiveView: View {
    @Environment(AppState.self) private var appState
    @Environment(\.dismiss) private var dismiss
    let category: Category

    private var transactions: [Transaction] {
        appState.transactionsFor(category: category.id).sorted { $0.date > $1.date }
    }

    private var totalSpend: Double { transactions.filter { !$0.isIncome }.reduce(0) { $0 + $1.amount } }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: HS.xl) {
                    headerCard
                    trendChart
                    transactionList
                }
                .padding(.bottom, HS.xxl)
            }
            .background(Color.backgroundPrimary)
            .navigationTitle(category.name)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") { dismiss() }.foregroundColor(.hearthTerracotta)
                }
            }
        }
    }

    private var headerCard: some View {
        VStack(spacing: HS.md) {
            Text(category.emoji).font(.system(size: 48))
            Text(totalSpend, format: .currency(code: "USD"))
                .font(.hearthAmount)
                .foregroundColor(.textPrimary)
            Text("Spent this month in \(category.name)")
                .font(.hearthCaption1)
                .foregroundColor(.textTertiary)
        }
        .frame(maxWidth: .infinity)
        .padding(HS.xl)
        .hearthCard()
        .padding(.horizontal, HS.lg)
        .padding(.top, HS.lg)
    }

    private var trendChart: some View {
        VStack(alignment: .leading, spacing: HS.md) {
            Text("Daily spend")
                .font(.hearthCaption1)
                .foregroundColor(.textTertiary)
                .padding(.horizontal, HS.lg)

            let daily = Dictionary(grouping: transactions.filter { !$0.isIncome }) {
                Calendar.current.startOfDay(for: $0.date)
            }
            .map { (date: $0.key, total: $0.value.reduce(0) { $0 + $1.amount }) }
            .sorted { $0.date < $1.date }

            if !daily.isEmpty {
                Chart(daily, id: \.date) { item in
                    BarMark(
                        x: .value("Date", item.date, unit: .day),
                        y: .value("Amount", item.total)
                    )
                    .foregroundStyle(Color(hex: category.colorHex).gradient)
                    .cornerRadius(4)
                }
                .frame(height: 120)
                .padding(.horizontal, HS.lg)
            }
        }
    }

    private var transactionList: some View {
        VStack(spacing: 0) {
            ForEach(transactions) { tx in
                TransactionRow(
                    transaction: tx,
                    category: category,
                    partnerName: tx.partnerId == appState.currentUser.id ? appState.currentUser.name : (appState.partner?.name ?? "")
                )
                Divider().padding(.horizontal, HS.lg)
            }
        }
    }
}
