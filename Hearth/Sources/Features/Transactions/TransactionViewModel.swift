import Foundation
import Observation

@Observable
final class TransactionViewModel {
    var searchText: String = ""
    var selectedCategoryId: UUID? = nil
    var selectedFilter: TransactionFilter = .all
    var selectedTransaction: Transaction? = nil
    var showSplitSheet: Bool = false
    var splitTransaction: Transaction? = nil

    func filtered(transactions: [Transaction], categories: [Category]) -> [Transaction] {
        transactions
            .filter { tx in
                if !searchText.isEmpty {
                    let q = searchText.lowercased()
                    guard tx.merchantName.lowercased().contains(q) else { return false }
                }
                if let catId = selectedCategoryId {
                    guard tx.categoryId == catId else { return false }
                }
                switch selectedFilter {
                case .all:     return true
                case .mine:    return true
                case .partner: return true
                case .split:   return tx.isSplit
                case .unreviewed: return !tx.isReviewed
                }
            }
            .sorted { $0.date > $1.date }
    }

    func groupedByDate(_ transactions: [Transaction]) -> [(String, [Transaction])] {
        let cal = Calendar.current
        let grouped = Dictionary(grouping: transactions) { tx -> String in
            if cal.isDateInToday(tx.date)     { return "Today" }
            if cal.isDateInYesterday(tx.date) { return "Yesterday" }
            let fmt = DateFormatter()
            fmt.dateFormat = "MMMM d"
            return fmt.string(from: tx.date)
        }
        let order = ["Today", "Yesterday"]
        return grouped.keys
            .sorted { a, b in
                let ai = order.firstIndex(of: a) ?? Int.max
                let bi = order.firstIndex(of: b) ?? Int.max
                if ai != Int.max || bi != Int.max { return ai < bi }
                return a > b
            }
            .map { ($0, grouped[$0]!) }
    }
}
