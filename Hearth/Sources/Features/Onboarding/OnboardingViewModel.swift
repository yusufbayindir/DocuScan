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
        // Setup mock data first, then override with the names the user actually typed
        MockDataService.setupAppState(appState)
        appState.currentUser.name = yourName.isEmpty ? appState.currentUser.name : yourName
        if var partner = appState.partner {
            partner.name = partnerName.isEmpty ? partner.name : partnerName
            partner.email = partnerEmail.isEmpty ? partner.email : partnerEmail
            appState.partner = partner
        }
        appState.isOnboarded = true
    }
}
