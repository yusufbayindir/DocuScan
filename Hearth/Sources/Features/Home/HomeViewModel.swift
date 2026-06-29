import SwiftUI
import Observation

@Observable
final class HomeViewModel {
    var showMoneyDate: Bool = false
    var selectedAccountId: UUID? = nil
    var isBalancePrivate: Bool = false

    func togglePrivacy() {
        withAnimation(.easeInOut(duration: 0.2)) {
            isBalancePrivate.toggle()
        }
    }
}
