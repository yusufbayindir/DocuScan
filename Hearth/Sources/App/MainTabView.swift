import SwiftUI

struct MainTabView: View {
    @Environment(AppState.self) private var appState

    @Bindable private var bindableAppState: AppState

    init(appState: AppState) {
        self.bindableAppState = appState
    }

    var body: some View {
        TabView(selection: $bindableAppState.selectedTab) {
            HomeView()
                .tabItem { Label("Home", systemImage: "house.fill") }
                .tag(0)

            TransactionFeedView()
                .tabItem { Label("Transactions", systemImage: "list.bullet.rectangle") }
                .tag(1)
                .badge(appState.unreviewedTransactionCount > 0 ? appState.unreviewedTransactionCount : 0)

            GoalsView()
                .tabItem { Label("Goals", systemImage: "target") }
                .tag(2)

            InsightsView()
                .tabItem { Label("Insights", systemImage: "chart.bar.fill") }
                .tag(3)

            SettingsView()
                .tabItem { Label("Settings", systemImage: "gearshape.fill") }
                .tag(4)
        }
        .tint(.hearthTerracotta)
    }
}
