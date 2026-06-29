import SwiftUI

struct TransactionFeedView: View {
    @Environment(AppState.self) private var appState
    @State private var vm = TransactionViewModel()

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                searchBar
                categoryFilter
                filterChips
                transactionList
            }
            .background(Color.backgroundPrimary)
            .navigationTitle("Transactions")
            .navigationBarTitleDisplayMode(.large)
        }
        .sheet(item: $vm.selectedTransaction) { tx in
            TransactionDetailView(transaction: tx)
        }
        .sheet(isPresented: $vm.showSplitSheet) {
            if let tx = vm.splitTransaction {
                SplitExpenseSheet(transaction: tx)
            }
        }
    }

    private var searchBar: some View {
        HStack(spacing: HS.sm) {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.textTertiary)
            TextField("Search transactions...", text: $vm.searchText)
                .font(.hearthBody)
                .foregroundColor(.textPrimary)
        }
        .padding(.horizontal, HS.md)
        .padding(.vertical, 10)
        .background(Color.backgroundCard)
        .clipShape(RoundedRectangle(cornerRadius: HR.md))
        .padding(.horizontal, HS.lg)
        .padding(.vertical, HS.sm)
    }

    private var categoryFilter: some View {
        CategoryChipRow(categories: appState.categories, selected: $vm.selectedCategoryId)
    }

    private var filterChips: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: HS.sm) {
                ForEach(TransactionFilter.allCases, id: \.self) { filter in
                    Button(action: { vm.selectedFilter = filter }) {
                        Text(filter.label)
                            .font(.hearthCaption1)
                            .foregroundColor(vm.selectedFilter == filter ? .white : .textPrimary)
                            .padding(.horizontal, HS.md)
                            .padding(.vertical, 8)
                            .background(vm.selectedFilter == filter ? Color.hearthTerracotta : Color.backgroundCard)
                            .clipShape(Capsule())
                            .overlay(Capsule().stroke(Color.borderSubtle, lineWidth: vm.selectedFilter == filter ? 0 : 1))
                    }
                    .buttonStyle(ScaleButtonStyle(scale: 0.96))
                }
            }
            .padding(.horizontal, HS.lg)
            .padding(.bottom, HS.sm)
        }
    }

    private var transactionList: some View {
        let filtered = vm.filtered(transactions: appState.transactions, categories: appState.categories)
        let grouped = vm.groupedByDate(filtered)

        return ScrollView(showsIndicators: false) {
            LazyVStack(spacing: 0, pinnedViews: [.sectionHeaders]) {
                if filtered.isEmpty {
                    emptyState
                } else {
                    ForEach(grouped, id: \.0) { (dateLabel, txs) in
                        Section {
                            ForEach(txs) { tx in
                                TransactionRow(
                                    transaction: tx,
                                    category: appState.category(for: tx.categoryId),
                                    partnerName: tx.partnerId == appState.currentUser.id
                                        ? appState.currentUser.name
                                        : (appState.partner?.name ?? "")
                                ) {
                                    vm.selectedTransaction = tx
                                }
                                Divider().padding(.horizontal, HS.lg)
                            }
                        } header: {
                            Text(dateLabel)
                                .font(.hearthCaption1)
                                .foregroundColor(.textTertiary)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.horizontal, HS.lg)
                                .padding(.vertical, 8)
                                .background(Color.backgroundPrimary.opacity(0.95))
                        }
                    }
                }
            }
        }
    }

    private var emptyState: some View {
        VStack(spacing: HS.md) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 44))
                .foregroundColor(.textTertiary)
            Text("No transactions found")
                .font(.hearthHeadline)
                .foregroundColor(.textSecondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.top, HS.xxl * 2)
    }
}

