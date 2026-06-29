import SwiftUI

struct HearthProgressBar: View {
    let value: Double
    let total: Double
    var primaryColor: Color = .hearthTerracotta
    var partnerBValue: Double? = nil
    var partnerBColor: Color = .hearthDustyRose
    var height: CGFloat = 8

    private var progress: Double { total > 0 ? min(value / total, 1.0) : 0 }
    private var partnerBProgress: Double {
        guard let b = partnerBValue else { return 0 }
        return total > 0 ? min((value + b) / total, 1.0) : 0
    }

    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: height / 2)
                    .fill(Color.backgroundTertiary)
                    .frame(height: height)

                if let _ = partnerBValue {
                    RoundedRectangle(cornerRadius: height / 2)
                        .fill(partnerBColor.opacity(0.7))
                        .frame(width: geo.size.width * partnerBProgress, height: height)
                        .animation(.spring(response: 0.6, dampingFraction: 0.8), value: partnerBProgress)
                }

                RoundedRectangle(cornerRadius: height / 2)
                    .fill(primaryColor)
                    .frame(width: geo.size.width * progress, height: height)
                    .animation(.spring(response: 0.6, dampingFraction: 0.8), value: progress)
            }
        }
        .frame(height: height)
    }
}
