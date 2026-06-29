import SwiftUI

struct NotificationPrefsView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var billReminders = true
    @State private var weeklyRecap = true
    @State private var unusualSpending = true
    @State private var goalMilestones = true
    @State private var partnerActivity = false
    @State private var aiInsights = true

    var body: some View {
        NavigationStack {
            List {
                Section("Bills & Payments") {
                    Toggle("Bill Reminders", isOn: $billReminders)
                        .tint(.hearthTerracotta)
                }

                Section("Insights") {
                    Toggle("Weekly Recap", isOn: $weeklyRecap)
                        .tint(.hearthTerracotta)
                    Toggle("Unusual Spending Alerts", isOn: $unusualSpending)
                        .tint(.hearthTerracotta)
                    Toggle("AI Coach Insights", isOn: $aiInsights)
                        .tint(.hearthTerracotta)
                }

                Section("Goals & Partner") {
                    Toggle("Goal Milestones", isOn: $goalMilestones)
                        .tint(.hearthTerracotta)
                    Toggle("Partner Activity", isOn: $partnerActivity)
                        .tint(.hearthTerracotta)
                }
            }
            .listStyle(.insetGrouped)
            .scrollContentBackground(.hidden)
            .background(Color.backgroundPrimary)
            .navigationTitle("Notifications")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") { dismiss() }.foregroundColor(.hearthTerracotta)
                }
            }
        }
    }
}
