import SwiftUI

struct TransactionDetailView: View {
    @Environment(AppState.self) private var appState
    @Environment(\.dismiss) private var dismiss
    let transaction: Transaction

    private var category: Category? { appState.category(for: transaction.categoryId) }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: HS.xl) {
                    merchantHeader
                    detailsCard
                    if transaction.isSplit { splitCard }
                    if let note = transaction.note { noteCard(note) }
                    reviewButton
                }
                .padding(.bottom, HS.xxl)
            }
            .background(Color.backgroundPrimary)
            .navigationTitle("Transaction")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") { dismiss() }
                        .foregroundColor(.hearthTerracotta)
                }
            }
        }
    }

    private var merchantHeader: some View {
        VStack(spacing: HS.md) {
            ZStack {
                Circle()
                    .fill(Color(hex: category?.colorHex ?? "#9E9E9E").opacity(0.15))
                    .frame(width: 72, height: 72)
                Text(category?.emoji ?? "📦")
                    .font(.system(size: 36))
            }
            Text(transaction.merchantName)
                .font(.hearthTitle2)
                .foregroundColor(.textPrimary)
            Text(transaction.amount, format: .currency(code: "USD"))
                .font(.hearthAmount)
                .foregroundColor(transaction.isIncome ? .semanticSuccessFg : .textPrimary)
            Text(transaction.date.formatted(date: .long, time: .shortened))
                .font(.hearthCaption1)
                .foregroundColor(.textTertiary)
        }
        .padding(.top, HS.xl)
    }

    private var detailsCard: some View {
        VStack(spacing: 0) {
            detailRow(label: "Category", value: (category?.name ?? "Other"))
            Divider().padding(.horizontal, HS.md)
            detailRow(label: "Account", value: appState.accounts.first { $0.id == transaction.accountId }?.name ?? "Unknown")
            Divider().padding(.horizontal, HS.md)
            detailRow(label: "Paid by", value: transaction.partnerId == appState.currentUser.id ? appState.currentUser.name : (appState.partner?.name ?? "Partner"))
        }
        .hearthCard()
        .padding(.horizontal, HS.lg)
    }

    private var splitCard: some View {
        VStack(alignment: .leading, spacing: HS.md) {
            Label("Split Expense", systemImage: "arrow.triangle.branch")
                .font(.hearthSubheadline)
                .foregroundColor(.hearthAmber)
            if let split = transaction.splitAmount {
                HStack {
                    Text("Your share")
                        .font(.hearthBody)
                        .foregroundColor(.textSecondary)
                    Spacer()
                    Text(split, format: .currency(code: "USD"))
                        .font(.hearthSmallAmount)
                        .foregroundColor(.textPrimary)
                }
                HStack {
                    Text("Partner's share")
                        .font(.hearthBody)
                        .foregroundColor(.textSecondary)
                    Spacer()
                    Text((transaction.amount - split), format: .currency(code: "USD"))
                        .font(.hearthSmallAmount)
                        .foregroundColor(.textPrimary)
                }
            }
        }
        .padding(HS.lg)
        .hearthCard()
        .padding(.horizontal, HS.lg)
    }

    private func noteCard(_ note: String) -> some View {
        VStack(alignment: .leading, spacing: HS.sm) {
            Label("Note", systemImage: "note.text")
                .font(.hearthCaption1)
                .foregroundColor(.textTertiary)
            Text(note)
                .font(.hearthBody)
                .foregroundColor(.textPrimary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(HS.lg)
        .hearthCard()
        .padding(.horizontal, HS.lg)
    }

    private var reviewButton: some View {
        HearthPrimaryButton(
            title: transaction.isReviewed ? "Reviewed ✓" : "Mark as Reviewed",
            isDisabled: transaction.isReviewed
        ) {
            appState.markReviewed(transaction)
            dismiss()
        }
        .padding(.horizontal, HS.lg)
    }

    private func detailRow(label: String, value: String) -> some View {
        HStack {
            Text(label)
                .font(.hearthBody)
                .foregroundColor(.textSecondary)
            Spacer()
            Text(value)
                .font(.hearthBody)
                .foregroundColor(.textPrimary)
        }
        .padding(.horizontal, HS.lg)
        .padding(.vertical, HS.md)
    }
}
