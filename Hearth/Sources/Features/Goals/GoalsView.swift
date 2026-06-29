import SwiftUI

struct GoalsView: View {
    @Environment(AppState.self) private var appState
    @State private var vm = GoalViewModel()

    private var totalSaved: Double {
        appState.goals.reduce(0) { $0 + $1.partnerAContribution + $1.partnerBContribution }
    }

    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                VStack(spacing: HS.lg) {
                    summaryBanner
                    goalsList
                }
                .padding(.bottom, HS.xxl)
            }
            .background(Color.backgroundPrimary)
            .navigationTitle("Goals")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: { vm.showCreateSheet = true }) {
                        Image(systemName: "plus.circle.fill")
                            .font(.system(size: 22))
                            .foregroundColor(.hearthTerracotta)
                    }
                }
            }
        }
        .sheet(item: $vm.selectedGoal) { goal in
            GoalDetailView(goal: goal)
        }
        .sheet(isPresented: $vm.showCreateSheet) {
            CreateGoalSheet()
        }
    }

    private var summaryBanner: some View {
        HStack(spacing: 0) {
            VStack(alignment: .leading, spacing: 4) {
                Text("Total saved")
                    .font(.hearthCaption1)
                    .foregroundColor(.textTertiary)
                Text(totalSaved, format: .currency(code: "USD"))
                    .font(.hearthMediumAmount)
                    .foregroundColor(.textPrimary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            Divider().frame(height: 40)

            VStack(alignment: .trailing, spacing: 4) {
                Text("Active goals")
                    .font(.hearthCaption1)
                    .foregroundColor(.textTertiary)
                Text("\(appState.goals.count)")
                    .font(.hearthMediumAmount)
                    .foregroundColor(.textPrimary)
            }
            .frame(maxWidth: .infinity, alignment: .trailing)
        }
        .padding(HS.lg)
        .hearthCard()
        .padding(.horizontal, HS.lg)
        .padding(.top, HS.lg)
    }

    private var goalsList: some View {
        ForEach(appState.goals) { goal in
            GoalCard(
                goal: goal,
                currentUserName: appState.currentUser.name,
                partnerName: appState.partner?.name ?? "Partner"
            ) {
                vm.selectedGoal = goal
            }
            .padding(.horizontal, HS.lg)
        }
    }
}
