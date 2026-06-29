import Foundation
import Observation

@Observable
final class AppState {
    var currentUser: AppUser = AppUser(name: "Alex", email: "alex@example.com")
    var partner: Partner? = nil
    var accounts: [Account] = []
    var transactions: [Transaction] = []
    var categories: [Category] = []
    var goals: [Goal] = []
    var insights: [AIInsight] = []
    var bills: [Bill] = []

    var isOnboarded: Bool = false
    var showPaywall: Bool = false
    var selectedTab: Int = 0

    var partnerA: Partner {
        Partner(id: currentUser.id, name: currentUser.name, email: currentUser.email, isPartnerA: true)
    }

    var unreviewedTransactionCount: Int {
        transactions.filter { !$0.isReviewed }.count
    }

    var combinedBalance: Double {
        accounts.reduce(0) { $0 + $1.balance }
    }

    func category(for id: UUID) -> Category? {
        categories.first { $0.id == id }
    }

    func markReviewed(_ transaction: Transaction) {
        if let idx = transactions.firstIndex(where: { $0.id == transaction.id }) {
            transactions[idx].isReviewed = true
        }
    }

    func dismissInsight(_ insight: AIInsight) {
        if let idx = insights.firstIndex(where: { $0.id == insight.id }) {
            insights[idx].isDismissed = true
        }
    }

    func activeInsights() -> [AIInsight] {
        insights.filter { !$0.isDismissed }
    }

    func recentTransactions(limit: Int = 5) -> [Transaction] {
        Array(transactions.sorted { $0.date > $1.date }.prefix(limit))
    }

    func transactionsFor(account accountId: UUID) -> [Transaction] {
        transactions.filter { $0.accountId == accountId }
    }

    func transactionsFor(category categoryId: UUID) -> [Transaction] {
        transactions.filter { $0.categoryId == categoryId }
    }

    func monthlySpend(for categoryId: UUID) -> Double {
        let calendar = Calendar.current
        let now = Date()
        let start = calendar.date(from: calendar.dateComponents([.year, .month], from: now)) ?? now
        return transactions
            .filter { $0.categoryId == categoryId && $0.date >= start && !$0.isIncome }
            .reduce(0) { $0 + $1.amount }
    }

    func totalMonthlySpend() -> Double {
        let calendar = Calendar.current
        let now = Date()
        let start = calendar.date(from: calendar.dateComponents([.year, .month], from: now)) ?? now
        return transactions
            .filter { $0.date >= start && !$0.isIncome }
            .reduce(0) { $0 + $1.amount }
    }

    func spendByCategory() -> [(Category, Double)] {
        categories.compactMap { cat in
            let spend = monthlySpend(for: cat.id)
            guard spend > 0 else { return nil }
            return (cat, spend)
        }.sorted { $0.1 > $1.1 }
    }
}
