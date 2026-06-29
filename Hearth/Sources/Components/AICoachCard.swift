import SwiftUI

struct AICoachCard: View {
    let insight: AIInsight
    var onAction: (() -> Void)? = nil
    var onDismiss: (() -> Void)? = nil

    private var iconName: String {
        switch insight.type {
        case .proactiveWarning:  return "exclamationmark.triangle.fill"
        case .positiveInsight:   return "star.fill"
        case .subscriptionAlert: return "repeat.circle.fill"
        case .monthlyRecap:      return "chart.bar.fill"
        case .goalProgress:      return "target"
        }
    }

    private var accentColor: Color {
        switch insight.severity {
        case .low:      return .semanticSuccessFg
        case .medium:   return .hearthAmber
        case .high:     return .hearthTerracotta
        case .critical: return .semanticErrorFg
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: HS.md) {
            HStack(alignment: .top, spacing: HS.md) {
                ZStack {
                    Circle()
                        .fill(accentColor.opacity(0.15))
                        .frame(width: 40, height: 40)
                    Image(systemName: iconName)
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(accentColor)
                }

                VStack(alignment: .leading, spacing: 4) {
                    Text(insight.message)
                        .font(.hearthBody)
                        .foregroundColor(.textPrimary)
                        .fixedSize(horizontal: false, vertical: true)
                }

                Spacer(minLength: 0)

                Button(action: { onDismiss?() }) {
                    Image(systemName: "xmark")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(.textTertiary)
                }
            }

            if let label = insight.actionLabel {
                Button(action: { onAction?() }) {
                    Text(label)
                        .font(.hearthFootnote.weight(.semibold))
                        .foregroundColor(accentColor)
                        .padding(.horizontal, HS.md)
                        .padding(.vertical, 8)
                        .background(accentColor.opacity(0.12))
                        .clipShape(Capsule())
                }
                .buttonStyle(ScaleButtonStyle(scale: 0.97))
            }
        }
        .padding(HS.lg)
        .background(
            RoundedRectangle(cornerRadius: HR.lg)
                .fill(Color.backgroundCard)
                .overlay(
                    RoundedRectangle(cornerRadius: HR.lg)
                        .stroke(accentColor.opacity(0.25), lineWidth: 1)
                )
        )
        .shadowSubtle()
    }
}
