import SwiftUI

struct MoneyDateView: View {
    @Environment(AppState.self) private var appState
    @Environment(\.dismiss) private var dismiss
    @State private var currentAgendaIndex = 0

    private let agendaItems = [
        ("📊", "Review this month's spending", "See where your money went together."),
        ("🎯", "Check goal progress", "How close are you to your shared dreams?"),
        ("💡", "AI insights", "Discuss the coach's recommendations."),
        ("📋", "Upcoming bills", "Make sure everything is covered."),
        ("🌟", "Set intentions", "What's one financial win you'd like to achieve together?"),
    ]

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: HS.xl) {
                    headerBanner
                    agendaSection
                    spendingSnapshot
                    goalsSnapshot
                }
                .padding(.bottom, HS.xxl)
            }
            .background(Color.backgroundPrimary)
            .navigationTitle("Money Date")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") { dismiss() }
                        .foregroundColor(.hearthTerracotta)
                }
            }
        }
    }

    private var headerBanner: some View {
        ZStack {
            LinearGradient(
                colors: [Color.hearthAmber.opacity(0.7), Color.hearthTerracotta.opacity(0.7)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            VStack(spacing: HS.sm) {
                Text("💑").font(.system(size: 48))
                Text("Money Date")
                    .font(.hearthTitle2)
                    .foregroundColor(.white)
                Text("A moment to connect over finances")
                    .font(.hearthBody)
                    .foregroundColor(.white.opacity(0.85))
            }
            .padding(.vertical, HS.xxl)
        }
        .clipShape(RoundedRectangle(cornerRadius: HR.xl))
        .padding(.horizontal, HS.lg)
        .padding(.top, HS.lg)
        .shadowMedium()
    }

    private var agendaSection: some View {
        VStack(alignment: .leading, spacing: HS.md) {
            SectionHeader(title: "Tonight's Agenda")
            VStack(spacing: HS.sm) {
                ForEach(agendaItems.indices, id: \.self) { idx in
                    let item = agendaItems[idx]
                    HStack(spacing: HS.md) {
                        Text(item.0).font(.system(size: 24))
                        VStack(alignment: .leading, spacing: 2) {
                            Text(item.1)
                                .font(.hearthBody)
                                .foregroundColor(.textPrimary)
                            Text(item.2)
                                .font(.hearthCaption1)
                                .foregroundColor(.textSecondary)
                        }
                        Spacer()
                        Image(systemName: "chevron.right")
                            .font(.system(size: 12))
                            .foregroundColor(.textTertiary)
                    }
                    .padding(HS.md)
                    .hearthCard()
                    .padding(.horizontal, HS.lg)
                }
            }
        }
    }

    private var spendingSnapshot: some View {
        VStack(alignment: .leading, spacing: HS.md) {
            SectionHeader(title: "Spending Snapshot")
            let spend = appState.spendByCategory().prefix(4)
            VStack(spacing: HS.sm) {
                ForEach(spend, id: \.0.id) { (cat, amount) in
                    HStack {
                        Text(cat.emoji).font(.system(size: 20))
                        Text(cat.name)
                            .font(.hearthBody)
                            .foregroundColor(.textPrimary)
                        Spacer()
                        Text(amount, format: .currency(code: "USD"))
                            .font(.hearthSmallAmount)
                            .foregroundColor(.textPrimary)
                    }
                    .padding(.horizontal, HS.lg)
                    Divider().padding(.horizontal, HS.lg)
                }
            }
        }
    }

    private var goalsSnapshot: some View {
        VStack(alignment: .leading, spacing: HS.md) {
            SectionHeader(title: "Goal Progress")
            ForEach(appState.goals) { goal in
                GoalCard(
                    goal: goal,
                    currentUserName: appState.currentUser.name,
                    partnerName: appState.partner?.name ?? "Partner"
                )
                .padding(.horizontal, HS.lg)
            }
        }
    }
}
