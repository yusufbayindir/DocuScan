import SwiftUI

struct AccountManagementView: View {
    @Environment(AppState.self) private var appState
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            List {
                Section("Your Accounts") {
                    ForEach(appState.accounts.filter { $0.isMyAccount }) { account in
                        AccountCard(account: account, isCompact: true)
                            .listRowInsets(EdgeInsets())
                    }
                }

                Section("Partner's Accounts") {
                    ForEach(appState.accounts.filter { !$0.isMyAccount }) { account in
                        AccountCard(account: account, isCompact: true)
                            .listRowInsets(EdgeInsets())
                    }
                }

                Section {
                    Button(action: {}) {
                        Label("Connect a Bank", systemImage: "plus.circle.fill")
                            .foregroundColor(.hearthTerracotta)
                    }
                }
            }
            .listStyle(.insetGrouped)
            .scrollContentBackground(.hidden)
            .background(Color.backgroundPrimary)
            .navigationTitle("Accounts")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") { dismiss() }.foregroundColor(.hearthTerracotta)
                }
            }
        }
    }
}
