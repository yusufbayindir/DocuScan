import SwiftUI

struct AccountDetailView: View {
    @Environment(AppState.self) private var appState
    let accountId: UUID
    @Environment(\.dismiss) private var dismiss

    private var account: Account? { appState.accounts.first { $0.id == accountId } }
    private var transactions: [Transaction] { appState.transactionsFor(account: accountId) }

    var body: some View {
        NavigationStack {
            Group {
                if let account {
                    ScrollView {
                        VStack(spacing: 0) {
                            headerCard(account: account)
                            transactionList
                        }
                    }
                    .navigationTitle(account.name)
                    .navigationBarTitleDisplayMode(.inline)
                } else {
                    ContentUnavailableView("Account not found", systemImage: "creditcard.slash")
                }
            }
            .background(Color.backgroundPrimary)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") { dismiss() }
                        .foregroundColor(.hearthTerracotta)
                }
            }
        }
    }

    private func headerCard(account: Account) -> some View {
        VStack(spacing: HS.md) {
            Text(account.balance, format: .currency(code: "USD"))
                .font(.hearthAmount)
                .foregroundColor(account.balance < 0 ? .semanticErrorFg : .textPrimary)
            Text(account.type == .creditCard ? "Current Balance" : "Available Balance")
                .font(.hearthFootnote)
                .foregroundColor(.textTertiary)

            HStack(spacing: HS.xl) {
                VStack {
                    Text(transactions.filter { !$0.isIncome }.reduce(0) { $0 + $1.amount }, format: .currency(code: "USD"))
                        .font(.hearthHeadline)
                        .foregroundColor(.textPrimary)
                    Text("Spending")
                        .font(.hearthCaption2)
                        .foregroundColor(.textTertiary)
                }
                Divider().frame(height: 32)
                VStack {
                    Text(transactions.filter { $0.isIncome }.reduce(0) { $0 + $1.amount }, format: .currency(code: "USD"))
                        .font(.hearthHeadline)
                        .foregroundColor(.semanticSuccessFg)
                    Text("Income")
                        .font(.hearthCaption2)
                        .foregroundColor(.textTertiary)
                }
            }
            .padding(HS.lg)
            .hearthCard()
        }
        .padding(HS.lg)
    }

    private var transactionList: some View {
        LazyVStack(spacing: 0) {
            ForEach(transactions.sorted { $0.date > $1.date }) { tx in
                TransactionRow(
                    transaction: tx,
                    category: appState.category(for: tx.categoryId)
                )
                Divider().padding(.horizontal, HS.lg)
            }
        }
    }
}

extension UUID: @retroactive Identifiable {
    public var id: UUID { self }
}
