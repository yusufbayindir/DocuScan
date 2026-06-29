import SwiftUI

struct TransactionRow: View {
    let transaction: Transaction
    let category: Category?
    var partnerName: String = ""
    var onTap: (() -> Void)? = nil

    private var amountColor: Color {
        transaction.isIncome ? .semanticSuccessFg : .textPrimary
    }

    private var amountString: String {
        let sign = transaction.isIncome ? "+" : "-"
        return sign + transaction.amount.formatted(.currency(code: "USD"))
    }

    var body: some View {
        Button(action: { onTap?() }) {
            HStack(spacing: HS.md) {
                ZStack {
                    Circle()
                        .fill(Color(hex: category?.colorHex ?? "#9E9E9E").opacity(0.15))
                        .frame(width: 44, height: 44)
                    Text(category?.emoji ?? "📦")
                        .font(.system(size: 20))
                }

                VStack(alignment: .leading, spacing: 3) {
                    Text(transaction.merchantName)
                        .font(.hearthBody)
                        .foregroundColor(.textPrimary)
                        .lineLimit(1)

                    HStack(spacing: 6) {
                        if !partnerName.isEmpty {
                            Text(partnerName)
                                .font(.hearthCaption2)
                                .foregroundColor(.textTertiary)
                        }

                        if transaction.isSplit, let split = transaction.splitAmount {
                            HStack(spacing: 3) {
                                Image(systemName: "arrow.triangle.branch")
                                    .font(.system(size: 9))
                                Text("Split \(split.formatted(.currency(code: "USD")))")
                                    .font(.hearthCaption2)
                            }
                            .foregroundColor(.hearthAmber)
                        }

                        Text(transaction.date, style: .relative)
                            .font(.hearthCaption2)
                            .foregroundColor(.textTertiary)
                    }
                }

                Spacer()

                VStack(alignment: .trailing, spacing: 4) {
                    Text(amountString)
                        .font(.hearthSmallAmount)
                        .foregroundColor(amountColor)

                    if !transaction.isReviewed {
                        Circle()
                            .fill(Color.hearthTerracotta)
                            .frame(width: 8, height: 8)
                    }
                }
            }
            .padding(.horizontal, HS.lg)
            .padding(.vertical, HS.md)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }
}
