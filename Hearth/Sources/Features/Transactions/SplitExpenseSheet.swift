import SwiftUI

struct SplitExpenseSheet: View {
    @Environment(AppState.self) private var appState
    @Environment(\.dismiss) private var dismiss
    let transaction: Transaction

    @State private var splitPercentage: Double = 50
    private var myShare: Double { transaction.amount * splitPercentage / 100 }
    private var partnerShare: Double { transaction.amount - myShare }

    var body: some View {
        NavigationStack {
            VStack(spacing: HS.xl) {
                merchantInfo
                splitSlider
                splitPreview
                Spacer()
                HearthPrimaryButton(title: "Confirm Split") {
                    dismiss()
                }
                .padding(.horizontal, HS.lg)
                .padding(.bottom, HS.xl)
            }
            .padding(.top, HS.xl)
            .background(Color.backgroundPrimary)
            .navigationTitle("Split Expense")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") { dismiss() }.foregroundColor(.textSecondary)
                }
            }
        }
    }

    private var merchantInfo: some View {
        VStack(spacing: HS.sm) {
            Text(transaction.merchantName)
                .font(.hearthTitle3)
                .foregroundColor(.textPrimary)
            Text(transaction.amount, format: .currency(code: "USD"))
                .font(.hearthAmount)
                .foregroundColor(.textPrimary)
        }
    }

    private var splitSlider: some View {
        VStack(spacing: HS.md) {
            Text("\(Int(splitPercentage))% / \(100 - Int(splitPercentage))%")
                .font(.hearthHeadline)
                .foregroundColor(.hearthTerracotta)

            Slider(value: $splitPercentage, in: 0...100, step: 5)
                .tint(.hearthTerracotta)
                .padding(.horizontal, HS.lg)

            HStack {
                Text("0%").font(.hearthCaption2).foregroundColor(.textTertiary)
                Spacer()
                Text("50/50").font(.hearthCaption2).foregroundColor(.textTertiary)
                Spacer()
                Text("100%").font(.hearthCaption2).foregroundColor(.textTertiary)
            }
            .padding(.horizontal, HS.lg)
        }
    }

    private var splitPreview: some View {
        HStack(spacing: HS.md) {
            splitBubble(
                name: appState.currentUser.name,
                amount: myShare,
                isA: true
            )
            Image(systemName: "arrow.left.arrow.right")
                .foregroundColor(.textTertiary)
            splitBubble(
                name: appState.partner?.name ?? "Partner",
                amount: partnerShare,
                isA: false
            )
        }
        .padding(.horizontal, HS.lg)
    }

    private func splitBubble(name: String, amount: Double, isA: Bool) -> some View {
        VStack(spacing: HS.sm) {
            PartnerAvatar(name: name, isPartnerA: isA, size: .lg)
            Text(name)
                .font(.hearthCaption1)
                .foregroundColor(.textSecondary)
            Text(amount, format: .currency(code: "USD"))
                .font(.hearthMediumAmount)
                .foregroundColor(.textPrimary)
        }
        .frame(maxWidth: .infinity)
        .padding(HS.lg)
        .hearthCard()
    }
}
