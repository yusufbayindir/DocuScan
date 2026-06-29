import SwiftUI
import Combine

@MainActor
final class AppEnvironment: ObservableObject {
    let adService: AdService
    let documentStore: DocumentStore
    let iapService: IAPService

    init() {
        let ads = AdService()
        self.adService = ads
        self.documentStore = DocumentStore()
        self.iapService = IAPService(adService: ads)
    }
}
