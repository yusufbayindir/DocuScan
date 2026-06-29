import SwiftUI
import Observation

@Observable
final class OnboardingViewModel {
    var currentStep: Int = 0
    var yourName: String = ""
    var partnerName: String = ""
    var partnerEmail: String = ""
    var selectedPrivacyLevel: PrivacyLevel = .full
    var isAnimatingIn: Bool = false

    let totalSteps = 7

    var canAdvance: Bool {
        switch currentStep {
        case 1: return yourName.count >= 2
        case 2: return partnerName.count >= 2
        default: return true
        }
    }

    func advance() {
        guard currentStep < totalSteps - 1 else { return }
        withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
            currentStep += 1
        }
    }

    func back() {
        guard currentStep > 0 else { return }
        withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
            currentStep -= 1
        }
    }

    func completeOnboarding(appState: AppState) {
        appState.currentUser.name = yourName.isEmpty ? "Alex" : yourName
        appState.partner = Partner(
            id: UUID(),
            name: partnerName.isEmpty ? "Jordan" : partnerName,
            email: partnerEmail,
            isPartnerA: false
        )
        MockDataService.setupAppState(appState)
        appState.isOnboarded = true
    }
}
