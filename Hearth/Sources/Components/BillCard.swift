import SwiftUI

struct BillCard: View {
    let bill: Bill
    var currentUserName: String = "Alex"
    var partnerName: String = "Jordan"
    var onCheckTap: (() -> Void)? = nil

    private var urgencyColor: Color {
        let days = Calendar.current.dateComponents([.day], from: Date(), to: bill.dueDate).day ?? 0
        if days <= 1  { return .semanticErrorFg }
        if days <= 5  { return .hearthAmber }
        return .textTertiary
    }

    private var dueLabel: String {
        let days = Calendar.current.dateComponents([.day], from: Date(), to: bill.dueDate).day ?? 0
        if days < 0  { return "Overdue" }
        if days == 0 { return "Due today" }
        if days == 1 { return "Due tomorrow" }
        return "Due in \(days) days"
    }

    var body: some View {
        HStack(spacing: HS.md) {
            ZStack {
                RoundedRectangle(cornerRadius: HR.sm)
                    .fill(urgencyColor.opacity(0.12))
                    .frame(width: 44, height: 44)
                Image(systemName: bill.iconName)
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(urgencyColor)
            }

            VStack(alignment: .leading, spacing: 3) {
                Text(bill.merchantName)
                    .font(.hearthBody)
                    .foregroundColor(.textPrimary)
                HStack(spacing: 8) {
                    Text(dueLabel)
                        .font(.hearthCaption2)
                        .foregroundColor(urgencyColor)
                    checkmarks
                }
            }

            Spacer()

            VStack(alignment: .trailing, spacing: 4) {
                Text(bill.amount, format: .currency(code: "USD"))
                    .font(.hearthSmallAmount)
                    .foregroundColor(.textPrimary)

                if bill.isRecurring {
                    Text("Monthly")
                        .font(.hearthCaption2)
                        .foregroundColor(.textTertiary)
                }
            }

            Button(action: { onCheckTap?() }) {
                Image(systemName: bill.partnerAChecked ? "checkmark.circle.fill" : "circle")
                    .font(.system(size: 24))
                    .foregroundColor(bill.partnerAChecked ? .semanticSuccessFg : .borderDefault)
            }
            .buttonStyle(ScaleButtonStyle(scale: 0.9))
        }
        .padding(.horizontal, HS.lg)
        .padding(.vertical, HS.md)
    }

    private var checkmarks: some View {
        HStack(spacing: 4) {
            checkBubble(name: currentUserName, checked: bill.partnerAChecked, isA: true)
            checkBubble(name: partnerName, checked: bill.partnerBChecked, isA: false)
        }
    }

    private func checkBubble(name: String, checked: Bool, isA: Bool) -> some View {
        HStack(spacing: 3) {
            Circle()
                .fill(isA ? Color.hearthTerracotta : Color.hearthDustyRose)
                .frame(width: 6, height: 6)
            Image(systemName: checked ? "checkmark" : "minus")
                .font(.system(size: 8, weight: .bold))
                .foregroundColor(checked ? .semanticSuccessFg : .textTertiary)
        }
    }
}
