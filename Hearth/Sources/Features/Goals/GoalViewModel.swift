import Foundation
import Observation

@Observable
final class GoalViewModel {
    var selectedGoal: Goal? = nil
    var showCreateSheet: Bool = false
    var contributionAmount: String = ""

    func addContribution(to goal: Goal, amount: Double, isPartnerA: Bool, appState: AppState) {
        guard let idx = appState.goals.firstIndex(where: { $0.id == goal.id }) else { return }
        if isPartnerA {
            appState.goals[idx].partnerAContribution += amount
        } else {
            appState.goals[idx].partnerBContribution += amount
        }
    }
}
