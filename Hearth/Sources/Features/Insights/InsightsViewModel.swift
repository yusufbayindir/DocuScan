import Foundation
import Observation

@Observable
final class InsightsViewModel {
    var selectedInsight: AIInsight? = nil
    var showMonthlyReport: Bool = false
    var showCategoryDive: Bool = false
    var selectedCategoryId: UUID? = nil
}
