import SwiftUI

struct CreateGoalSheet: View {
    @Environment(AppState.self) private var appState
    @Environment(\.dismiss) private var dismiss

    @State private var name: String = ""
    @State private var emoji: String = "🎯"
    @State private var targetAmount: String = ""
    @State private var hasTargetDate: Bool = false
    @State private var targetDate: Date = Calendar.current.date(byAdding: .month, value: 6, to: Date()) ?? Date()

    private let emojiOptions = ["🎯", "✈️", "🏠", "🚗", "💒", "🎓", "🛡️", "🌴", "💍", "🏖️"]
    private var canCreate: Bool { !name.isEmpty && Double(targetAmount) != nil }

    var body: some View {
        NavigationStack {
            Form {
                Section("Goal Details") {
                    HStack {
                        Menu {
                            ForEach(emojiOptions, id: \.self) { e in
                                Button(e) { emoji = e }
                            }
                        } label: {
                            Text(emoji).font(.system(size: 32))
                                .frame(width: 44, height: 44)
                                .background(Color.hearthTerracotta.opacity(0.12))
                                .clipShape(RoundedRectangle(cornerRadius: HR.sm))
                        }
                        TextField("Goal name", text: $name)
                            .font(.hearthBody)
                    }

                    HStack {
                        Text("$").foregroundColor(.textTertiary)
                        TextField("Target amount", text: $targetAmount)
                            .keyboardType(.decimalPad)
                    }
                }

                Section("Target Date") {
                    Toggle("Set a target date", isOn: $hasTargetDate)
                        .tint(.hearthTerracotta)
                    if hasTargetDate {
                        DatePicker("Target date", selection: $targetDate, displayedComponents: .date)
                            .tint(.hearthTerracotta)
                    }
                }
            }
            .navigationTitle("New Goal")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") { dismiss() }.foregroundColor(.textSecondary)
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Create") {
                        let amount = Double(targetAmount) ?? 0
                        let goal = Goal(
                            id: UUID(),
                            name: name,
                            emoji: emoji,
                            targetAmount: amount,
                            partnerAContribution: 0,
                            partnerBContribution: 0,
                            targetDate: hasTargetDate ? targetDate : nil
                        )
                        appState.goals.append(goal)
                        dismiss()
                    }
                    .disabled(!canCreate)
                    .foregroundColor(canCreate ? .hearthTerracotta : .textTertiary)
                    .fontWeight(.semibold)
                }
            }
        }
    }
}
