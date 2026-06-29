import SwiftUI
import Charts

struct HomeView: View {
    @Environment(AppState.self) private var appState
    @State private var vm = HomeViewModel()

    private var greeting: String {
        let hour = Calendar.current.component(.hour, from: Date())
        if hour < 12 { return "Good morning" }
        if hour < 17 { return "Good afternoon" }
        return "Good evening"
    }

    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {
                    headerSection
                    insightsSection
                    accountsSection
                    recentTransactionsSection
                    goalsSection
                    billsSection
                }
            }
            .background(Color.backgroundPrimary)
            .navigationBarHidden(true)
        }
        .sheet(isPresented: $vm.showMoneyDate) {
            MoneyDateView()
        }
        .sheet(item: $vm.selectedAccountId) { id in
            AccountDetailView(accountId: id)
        }
    }

    // MARK: - Header

    private var headerSection: some View {
        ZStack(alignment: .bottom) {
            LinearGradient(
                colors: [Color.hearthTerracotta, Color.hearthSienna],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea(edges: .top)

            VStack(alignment: .leading, spacing: 0) {
                HStack(alignment: .top) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("\(greeting),")
                            .font(.hearthBody)
                            .foregroundColor(.white.opacity(0.8))
                        Text(appState.currentUser.name)
                            .font(.hearthTitle2)
                            .foregroundColor(.white)
                    }

                    Spacer()

                    HStack(spacing: HS.md) {
                        if let partner = appState.partner {
                            StackedPartnerAvatars(nameA: appState.currentUser.name, nameB: partner.name, size: .md)
                        }

                        Button(action: { vm.showMoneyDate = true }) {
                            Image(systemName: "calendar.badge.checkmark")
                                .font(.system(size: 20))
                                .foregroundColor(.white)
                        }
                    }
                }
                .padding(.horizontal, HS.lg)
                .padding(.top, HS.lg)

                Spacer(minLength: HS.lg)

                VStack(alignment: .leading, spacing: 6) {
                    Text("COMBINED NET WORTH")
                        .font(.hearthCaption2)
                        .foregroundColor(.white.opacity(0.7))
                        .kerning(1.2)

                    HStack(alignment: .bottom, spacing: HS.md) {
                        if vm.isBalancePrivate {
                            Text("••••••")
                                .font(.hearthAmount)
                                .foregroundColor(.white)
                        } else {
                            Text(appState.combinedBalance, format: .currency(code: "USD"))
                                .font(.hearthAmount)
                                .foregroundColor(.white)
                                .contentTransition(.numericText())
                        }

                        Button(action: { vm.togglePrivacy() }) {
                            Image(systemName: vm.isBalancePrivate ? "eye.slash" : "eye")
                                .font(.system(size: 16))
                                .foregroundColor(.white.opacity(0.7))
                        }
                        .padding(.bottom, 6)
                    }
                }
                .padding(.horizontal, HS.lg)
                .padding(.bottom, HS.xl)
            }
        }
        .frame(height: 220)
    }

    // MARK: - Insights

    private var insightsSection: some View {
        let active = appState.activeInsights()
        return Group {
            if !active.isEmpty {
                VStack(alignment: .leading, spacing: HS.sm) {
                    SectionHeader(title: "AI Insights")
                    VStack(spacing: HS.sm) {
                        ForEach(active.prefix(2)) { insight in
                            AICoachCard(insight: insight) {
                                // action
                            } onDismiss: {
                                appState.dismissInsight(insight)
                            }
                            .padding(.horizontal, HS.lg)
                        }
                    }
                }
                .padding(.top, HS.lg)
            }
        }
    }

    // MARK: - Accounts

    private var accountsSection: some View {
        VStack(alignment: .leading, spacing: HS.sm) {
            SectionHeader(title: "Accounts", trailingLabel: "Manage") {}

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: HS.md) {
                    ForEach(appState.accounts) { account in
                        AccountCard(account: account, onTap: {
                            vm.selectedAccountId = account.id
                        })
                    }
                }
                .padding(.horizontal, HS.lg)
            }
        }
        .padding(.top, HS.lg)
    }

    // MARK: - Recent Transactions

    private var recentTransactionsSection: some View {
        VStack(alignment: .leading, spacing: 0) {
            SectionHeader(title: "Recent", trailingLabel: "See all") {
                appState.selectedTab = 1
            }

            let recents = appState.recentTransactions(limit: 5)
            ForEach(recents) { tx in
                TransactionRow(
                    transaction: tx,
                    category: appState.category(for: tx.categoryId),
                    partnerName: tx.partnerId == appState.currentUser.id ? appState.currentUser.name : (appState.partner?.name ?? "")
                )

                if tx.id != recents.last?.id {
                    Divider()
                        .padding(.horizontal, HS.lg)
                }
            }
        }
        .padding(.top, HS.lg)
    }

    // MARK: - Goals

    private var goalsSection: some View {
        VStack(alignment: .leading, spacing: HS.sm) {
            SectionHeader(title: "Goals", trailingLabel: "See all") {
                appState.selectedTab = 2
            }

            ForEach(appState.goals.prefix(2)) { goal in
                GoalCard(
                    goal: goal,
                    currentUserName: appState.currentUser.name,
                    partnerName: appState.partner?.name ?? "Partner"
                )
                .padding(.horizontal, HS.lg)
            }
        }
        .padding(.top, HS.lg)
    }

    // MARK: - Bills

    private var billsSection: some View {
        VStack(alignment: .leading, spacing: 0) {
            SectionHeader(title: "Upcoming Bills", trailingLabel: "View all") {}

            ForEach(appState.bills.prefix(3)) { bill in
                BillCard(
                    bill: bill,
                    currentUserName: appState.currentUser.name,
                    partnerName: appState.partner?.name ?? "Partner"
                ) {}
                Divider().padding(.horizontal, HS.lg)
            }
        }
        .padding(.top, HS.lg)
        .padding(.bottom, HS.xxl)
    }
}
