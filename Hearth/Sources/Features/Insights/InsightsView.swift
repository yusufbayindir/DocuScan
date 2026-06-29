import SwiftUI
import Charts

struct InsightsView: View {
    @Environment(AppState.self) private var appState
    @State private var vm = InsightsViewModel()

    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                VStack(spacing: HS.lg) {
                    spendingChartSection
                    aiCoachSection
                    categoryBreakdownSection
                    monthlyReportBanner
                }
                .padding(.bottom, HS.xxl)
            }
            .background(Color.backgroundPrimary)
            .navigationTitle("Insights")
            .navigationBarTitleDisplayMode(.large)
        }
        .sheet(item: $vm.selectedInsight) { insight in
            AICoachDetailView(insight: insight)
        }
        .sheet(isPresented: $vm.showMonthlyReport) {
            MonthlyReportView()
        }
        .sheet(isPresented: $vm.showCategoryDive) {
            if let catId = vm.selectedCategoryId,
               let cat = appState.categories.first(where: { $0.id == catId }) {
                CategoryDiveView(category: cat)
            }
        }
    }

    // MARK: - Spending Chart

    private var spendingChartSection: some View {
        VStack(alignment: .leading, spacing: HS.md) {
            SectionHeader(title: "This Month")

            VStack(spacing: HS.lg) {
                let total = appState.totalMonthlySpend()
                Text(total, format: .currency(code: "USD"))
                    .font(.hearthAmount)
                    .foregroundColor(.textPrimary)
                    .frame(maxWidth: .infinity, alignment: .center)

                let spendData = appState.spendByCategory()
                if !spendData.isEmpty {
                    Chart(spendData, id: \.0.id) { (cat, amount) in
                        SectorMark(
                            angle: .value("Amount", amount),
                            innerRadius: .ratio(0.6),
                            angularInset: 2
                        )
                        .foregroundStyle(Color(hex: cat.colorHex))
                        .cornerRadius(4)
                    }
                    .frame(height: 200)
                    .padding(.horizontal, HS.xl)
                }
            }
            .padding(HS.lg)
            .hearthCard()
            .padding(.horizontal, HS.lg)
        }
        .padding(.top, HS.lg)
    }

    // MARK: - AI Coach

    private var aiCoachSection: some View {
        let active = appState.activeInsights()
        return Group {
            if !active.isEmpty {
                VStack(alignment: .leading, spacing: HS.md) {
                    SectionHeader(title: "AI Coach")
                    ForEach(active) { insight in
                        AICoachCard(insight: insight) {
                            vm.selectedInsight = insight
                        } onDismiss: {
                            appState.dismissInsight(insight)
                        }
                        .padding(.horizontal, HS.lg)
                    }
                }
            }
        }
    }

    // MARK: - Category Breakdown

    private var categoryBreakdownSection: some View {
        VStack(alignment: .leading, spacing: 0) {
            SectionHeader(title: "By Category")

            ForEach(appState.spendByCategory(), id: \.0.id) { (cat, amount) in
                Button(action: {
                    vm.selectedCategoryId = cat.id
                    vm.showCategoryDive = true
                }) {
                    HStack(spacing: HS.md) {
                        ZStack {
                            Circle()
                                .fill(Color(hex: cat.colorHex).opacity(0.15))
                                .frame(width: 40, height: 40)
                            Text(cat.emoji).font(.system(size: 18))
                        }
                        Text(cat.name)
                            .font(.hearthBody)
                            .foregroundColor(.textPrimary)
                        Spacer()
                        Text(amount, format: .currency(code: "USD"))
                            .font(.hearthSmallAmount)
                            .foregroundColor(.textPrimary)
                        Image(systemName: "chevron.right")
                            .font(.system(size: 12))
                            .foregroundColor(.textTertiary)
                    }
                    .padding(.horizontal, HS.lg)
                    .padding(.vertical, HS.md)
                    .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
                Divider().padding(.horizontal, HS.lg)
            }
        }
    }

    // MARK: - Monthly Report Banner

    private var monthlyReportBanner: some View {
        Button(action: { vm.showMonthlyReport = true }) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Monthly Report")
                        .font(.hearthSubheadline)
                        .foregroundColor(.textPrimary)
                    Text("See your full financial summary")
                        .font(.hearthCaption1)
                        .foregroundColor(.textTertiary)
                }
                Spacer()
                Image(systemName: "doc.text.fill")
                    .font(.system(size: 28))
                    .foregroundColor(.hearthTerracotta)
            }
            .padding(HS.lg)
            .hearthCard()
            .padding(.horizontal, HS.lg)
        }
        .buttonStyle(ScaleButtonStyle(scale: 0.98))
    }
}
