import StoreKit

// MARK: - IAPError

enum IAPError: LocalizedError {
    case failedVerification
    case productUnavailable

    var errorDescription: String? {
        switch self {
        case .failedVerification:
            return String(localized: "iap.error.failed_verification")
        case .productUnavailable:
            return String(localized: "iap.error.product_unavailable")
        }
    }
}

// MARK: - IAPService

@MainActor
final class IAPService: ObservableObject {

    static let monthlyProductID = "com.docuscan.premium.monthly"

    @Published private(set) var monthlyProduct: Product?
    @Published private(set) var isPurchasing = false
    @Published private(set) var isRestoring = false

    private let adService: AdService
    private var updatesTask: Task<Void, Never>?

    init(adService: AdService) {
        self.adService = adService
        updatesTask = Task { await listenForTransactions() }
    }

    deinit {
        updatesTask?.cancel()
    }

    // MARK: - Product Loading

    func loadProducts() async {
        do {
            let products = try await Product.products(for: [Self.monthlyProductID])
            monthlyProduct = products.first
        } catch {
            // Product unavailable in sandbox / no App Store connection — gracefully degrade
        }
    }

    // MARK: - Purchase

    func purchase() async throws {
        guard let product = monthlyProduct else {
            throw IAPError.productUnavailable
        }
        isPurchasing = true
        defer { isPurchasing = false }

        let result = try await product.purchase()
        switch result {
        case .success(let verification):
            let transaction = try checkVerified(verification)
            await unlockPremium()
            await transaction.finish()
        case .pending:
            break
        case .userCancelled:
            break
        @unknown default:
            break
        }
    }

    // MARK: - Restore

    func restore() async throws {
        isRestoring = true
        defer { isRestoring = false }
        try await AppStore.sync()
        for await result in Transaction.currentEntitlements {
            guard let transaction = try? checkVerified(result),
                  transaction.productID == Self.monthlyProductID else { continue }
            await unlockPremium()
            await transaction.finish()
        }
    }

    // MARK: - Entitlement Check

    func refreshEntitlements() async {
        for await result in Transaction.currentEntitlements {
            guard let transaction = try? checkVerified(result),
                  transaction.productID == Self.monthlyProductID else { continue }
            await unlockPremium()
            await transaction.finish()
        }
    }

    // MARK: - Private

    private func listenForTransactions() async {
        for await result in Transaction.updates {
            guard let transaction = try? checkVerified(result) else { continue }
            if transaction.productID == Self.monthlyProductID {
                await unlockPremium()
            }
            await transaction.finish()
        }
    }

    private func checkVerified<T>(_ result: VerificationResult<T>) throws -> T {
        switch result {
        case .verified(let value):
            return value
        case .unverified:
            throw IAPError.failedVerification
        }
    }

    private func unlockPremium() async {
        adService.unlockPremium()
    }
}
