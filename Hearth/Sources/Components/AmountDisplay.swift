import SwiftUI

struct AmountDisplay: View {
    let amount: Double
    var label: String? = nil
    var delta: Double? = nil
    var isLoading: Bool = false
    var size: AmountDisplaySize = .large

    enum AmountDisplaySize { case large, medium, small }

    private var font: Font {
        switch size {
        case .large:  return .hearthAmount
        case .medium: return .hearthMediumAmount
        case .small:  return .hearthSmallAmount
        }
    }

    var body: some View {
        VStack(spacing: HS.xs) {
            if let label {
                Text(label)
                    .font(.hearthFootnote)
                    .foregroundColor(.textSecondary)
            }

            if isLoading {
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.backgroundTertiary)
                    .frame(width: 180, height: size == .large ? 42 : 28)
                    .shimmering()
            } else {
                Text(amount, format: .currency(code: "USD"))
                    .font(font)
                    .foregroundColor(.textPrimary)
                    .contentTransition(.numericText())
            }

            if let delta, !isLoading {
                HStack(spacing: 4) {
                    Image(systemName: delta >= 0 ? "arrow.up.right" : "arrow.down.right")
                        .font(.system(size: 12, weight: .semibold))
                    Text(abs(delta), format: .currency(code: "USD"))
                        .font(.hearthCaption1)
                }
                .foregroundColor(delta >= 0 ? .semanticSuccessFg : .semanticErrorFg)
            }
        }
    }
}

// MARK: - Shimmer effect
struct ShimmeringModifier: ViewModifier {
    @State private var phase: CGFloat = -1

    func body(content: Content) -> some View {
        content.overlay(
            LinearGradient(
                colors: [.clear, .white.opacity(0.4), .clear],
                startPoint: .init(x: phase, y: 0),
                endPoint: .init(x: phase + 0.5, y: 0)
            )
        )
        .onAppear {
            withAnimation(.linear(duration: 1.2).repeatForever(autoreverses: false)) {
                phase = 1.5
            }
        }
    }
}

extension View {
    func shimmering() -> some View {
        modifier(ShimmeringModifier())
    }
}
