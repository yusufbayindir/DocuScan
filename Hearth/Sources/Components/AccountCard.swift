import SwiftUI

struct AccountCard: View {
    let account: Account
    var isCompact: Bool = false
    var onTap: (() -> Void)? = nil

    private var typeIcon: String {
        switch account.type {
        case .checking:   return "banknote"
        case .savings:    return "chart.line.uptrend.xyaxis"
        case .creditCard: return "creditcard"
        case .investment: return "arrow.triangle.2.circlepath.circle"
        case .cash:       return "dollarsign.circle"
        }
    }

    private var balanceColor: Color {
        account.balance < 0 ? .semanticErrorFg : .textPrimary
    }

    var body: some View {
        Button(action: { onTap?() }) {
            if isCompact {
                compactBody
            } else {
                fullBody
            }
        }
        .buttonStyle(.plain)
    }

    private var fullBody: some View {
        VStack(alignment: .leading, spacing: HS.sm) {
            HStack {
                Image(systemName: typeIcon)
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(.hearthTerracotta)
                    .frame(width: 36, height: 36)
                    .background(Color.hearthTerracotta.opacity(0.12))
                    .clipShape(RoundedRectangle(cornerRadius: HR.sm))

                Spacer()

                PrivacyBadge(level: account.privacyLevel)
            }

            Spacer()

            Text(account.bankName)
                .font(.hearthCaption1)
                .foregroundColor(.textTertiary)
            Text(account.name)
                .font(.hearthSubheadline)
                .foregroundColor(.textPrimary)
                .lineLimit(1)

            Text(account.balance, format: .currency(code: "USD"))
                .font(.hearthMediumAmount)
                .foregroundColor(balanceColor)
        }
        .padding(HS.lg)
        .frame(width: 200, height: 140)
        .hearthCard()
    }

    private var compactBody: some View {
        HStack(spacing: HS.md) {
            Image(systemName: typeIcon)
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.hearthTerracotta)
                .frame(width: 40, height: 40)
                .background(Color.hearthTerracotta.opacity(0.12))
                .clipShape(RoundedRectangle(cornerRadius: HR.sm))

            VStack(alignment: .leading, spacing: 2) {
                Text(account.name)
                    .font(.hearthBody)
                    .foregroundColor(.textPrimary)
                    .lineLimit(1)
                Text(account.bankName)
                    .font(.hearthCaption1)
                    .foregroundColor(.textTertiary)
            }

            Spacer()

            Text(account.balance, format: .currency(code: "USD"))
                .font(.hearthSmallAmount)
                .foregroundColor(balanceColor)
        }
        .padding(.horizontal, HS.lg)
        .padding(.vertical, HS.md)
    }
}
