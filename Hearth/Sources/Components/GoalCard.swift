import SwiftUI

struct GoalCard: View {
    let goal: Goal
    var currentUserName: String = "Alex"
    var partnerName: String = "Jordan"
    var onTap: (() -> Void)? = nil

    private var totalContributed: Double { goal.partnerAContribution + goal.partnerBContribution }
    private var progress: Double { goal.targetAmount > 0 ? min(totalContributed / goal.targetAmount, 1) : 0 }

    private var daysLeft: Int? {
        guard let target = goal.targetDate else { return nil }
        return Calendar.current.dateComponents([.day], from: Date(), to: target).day
    }

    var body: some View {
        Button(action: { onTap?() }) {
            VStack(alignment: .leading, spacing: HS.md) {
                HStack {
                    Text(goal.emoji)
                        .font(.system(size: 28))
                    VStack(alignment: .leading, spacing: 2) {
                        Text(goal.name)
                            .font(.hearthSubheadline)
                            .foregroundColor(.textPrimary)
                        if let days = daysLeft {
                            Text(days > 0 ? "\(days) days left" : "Due today")
                                .font(.hearthCaption2)
                                .foregroundColor(days <= 7 ? .semanticWarningFg : .textTertiary)
                        }
                    }
                    Spacer()
                    Text("\(Int(progress * 100))%")
                        .font(.hearthHeadline)
                        .foregroundColor(.hearthTerracotta)
                }

                HearthProgressBar(
                    value: goal.partnerAContribution,
                    total: goal.targetAmount,
                    primaryColor: .hearthTerracotta,
                    partnerBValue: goal.partnerBContribution,
                    partnerBColor: .hearthDustyRose,
                    height: 10
                )

                HStack {
                    HStack(spacing: 4) {
                        Circle().fill(Color.hearthTerracotta).frame(width: 8, height: 8)
                        Text("\(currentUserName) \(goal.partnerAContribution.formatted(.currency(code: "USD")))")
                            .font(.hearthCaption2)
                            .foregroundColor(.textSecondary)
                    }
                    Spacer()
                    HStack(spacing: 4) {
                        Circle().fill(Color.hearthDustyRose).frame(width: 8, height: 8)
                        Text("\(partnerName) \(goal.partnerBContribution.formatted(.currency(code: "USD")))")
                            .font(.hearthCaption2)
                            .foregroundColor(.textSecondary)
                    }
                }

                HStack {
                    Text(totalContributed, format: .currency(code: "USD"))
                        .font(.hearthCaption1)
                        .foregroundColor(.textPrimary)
                    Text("of")
                        .font(.hearthCaption2)
                        .foregroundColor(.textTertiary)
                    Text(goal.targetAmount, format: .currency(code: "USD"))
                        .font(.hearthCaption1)
                        .foregroundColor(.textSecondary)
                    Spacer()
                    Text((goal.targetAmount - totalContributed).formatted(.currency(code: "USD")) + " to go")
                        .font(.hearthCaption2)
                        .foregroundColor(.textTertiary)
                }
            }
            .padding(HS.lg)
            .hearthCard()
        }
        .buttonStyle(.plain)
    }
}
