import SwiftUI

struct GoalDetailView: View {
    @Environment(AppState.self) private var appState
    @Environment(\.dismiss) private var dismiss
    let goal: Goal

    @State private var contributionText: String = ""
    @State private var showConfetti: Bool = false

    private var totalContributed: Double { goal.partnerAContribution + goal.partnerBContribution }
    private var progress: Double { goal.targetAmount > 0 ? min(totalContributed / goal.targetAmount, 1) : 0 }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: HS.xl) {
                    heroSection
                    progressSection
                    contributionSection
                    historySection
                }
                .padding(.bottom, HS.xxl)
            }
            .background(Color.backgroundPrimary)
            .navigationTitle(goal.name)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") { dismiss() }.foregroundColor(.hearthTerracotta)
                }
            }
        }
    }

    private var heroSection: some View {
        VStack(spacing: HS.md) {
            Text(goal.emoji).font(.system(size: 56))
            Text(goal.name)
                .font(.hearthTitle2)
                .foregroundColor(.textPrimary)
            if let target = goal.targetDate {
                Text("Target: \(target.formatted(date: .abbreviated, time: .omitted))")
                    .font(.hearthCaption1)
                    .foregroundColor(.textTertiary)
            }
        }
        .padding(.top, HS.xl)
    }

    private var progressSection: some View {
        VStack(spacing: HS.md) {
            HStack {
                Text(totalContributed, format: .currency(code: "USD"))
                    .font(.hearthMediumAmount)
                    .foregroundColor(.textPrimary)
                Text("of")
                    .font(.hearthBody)
                    .foregroundColor(.textTertiary)
                Text(goal.targetAmount, format: .currency(code: "USD"))
                    .font(.hearthBody)
                    .foregroundColor(.textSecondary)
            }

            HearthProgressBar(
                value: goal.partnerAContribution,
                total: goal.targetAmount,
                primaryColor: .hearthTerracotta,
                partnerBValue: goal.partnerBContribution,
                partnerBColor: .hearthDustyRose,
                height: 14
            )

            HStack {
                HStack(spacing: 6) {
                    Circle().fill(Color.hearthTerracotta).frame(width: 10, height: 10)
                    Text("\(appState.currentUser.name): \(goal.partnerAContribution.formatted(.currency(code: "USD")))")
                        .font(.hearthCaption1)
                        .foregroundColor(.textSecondary)
                }
                Spacer()
                HStack(spacing: 6) {
                    Circle().fill(Color.hearthDustyRose).frame(width: 10, height: 10)
                    Text("\(appState.partner?.name ?? "Partner"): \(goal.partnerBContribution.formatted(.currency(code: "USD")))")
                        .font(.hearthCaption1)
                        .foregroundColor(.textSecondary)
                }
            }
        }
        .padding(HS.lg)
        .hearthCard()
        .padding(.horizontal, HS.lg)
    }

    private var contributionSection: some View {
        VStack(alignment: .leading, spacing: HS.md) {
            Text("Add Contribution")
                .font(.hearthSubheadline)
                .foregroundColor(.textPrimary)
                .padding(.horizontal, HS.lg)

            HStack(spacing: HS.md) {
                HStack {
                    Text("$").font(.hearthHeadline).foregroundColor(.textTertiary)
                    TextField("0.00", text: $contributionText)
                        .font(.hearthHeadline)
                        .foregroundColor(.textPrimary)
                        .keyboardType(.decimalPad)
                }
                .padding(HS.md)
                .background(Color.backgroundCard)
                .clipShape(RoundedRectangle(cornerRadius: HR.md))
                .overlay(RoundedRectangle(cornerRadius: HR.md).stroke(Color.borderDefault, lineWidth: 1))

                Button(action: contribute) {
                    Text("Add")
                        .font(.hearthHeadline)
                        .foregroundColor(.white)
                        .padding(.horizontal, HS.lg)
                        .padding(.vertical, HS.md)
                        .background(Color.hearthTerracotta)
                        .clipShape(RoundedRectangle(cornerRadius: HR.md))
                }
            }
            .padding(.horizontal, HS.lg)
        }
    }

    private func contribute() {
        guard let amount = Double(contributionText), amount > 0 else { return }
        if let idx = appState.goals.firstIndex(where: { $0.id == goal.id }) {
            appState.goals[idx].partnerAContribution += amount
        }
        contributionText = ""
    }

    private var historySection: some View {
        VStack(alignment: .leading, spacing: HS.md) {
            SectionHeader(title: "Contributions")
            VStack(spacing: HS.sm) {
                contributionRow(name: appState.currentUser.name, amount: goal.partnerAContribution, isA: true)
                Divider().padding(.horizontal, HS.lg)
                contributionRow(name: appState.partner?.name ?? "Partner", amount: goal.partnerBContribution, isA: false)
            }
        }
    }

    private func contributionRow(name: String, amount: Double, isA: Bool) -> some View {
        HStack {
            PartnerAvatar(name: name, isPartnerA: isA, size: .sm)
            Text(name)
                .font(.hearthBody)
                .foregroundColor(.textPrimary)
            Spacer()
            Text(amount, format: .currency(code: "USD"))
                .font(.hearthSmallAmount)
                .foregroundColor(.textPrimary)
        }
        .padding(.horizontal, HS.lg)
        .padding(.vertical, HS.sm)
    }
}
