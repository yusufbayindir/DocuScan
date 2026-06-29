import SwiftUI

struct PrivacyBadge: View {
    let level: PrivacyLevel

    private var label: String {
        switch level {
        case .full:        return "Shared"
        case .balanceOnly: return "Balance only"
        case .hidden:      return "Hidden"
        }
    }

    private var icon: String {
        switch level {
        case .full:        return "eye.fill"
        case .balanceOnly: return "eye.slash"
        case .hidden:      return "lock.fill"
        }
    }

    private var tint: Color {
        switch level {
        case .full:        return .semanticSuccessFg
        case .balanceOnly: return .hearthAmber
        case .hidden:      return .textTertiary
        }
    }

    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: icon)
                .font(.system(size: 10, weight: .semibold))
            Text(label)
                .font(.hearthCaption2)
        }
        .foregroundColor(tint)
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(tint.opacity(0.12))
        .clipShape(Capsule())
    }
}
