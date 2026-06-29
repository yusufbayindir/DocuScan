import SwiftUI

struct SectionHeader: View {
    let title: String
    var trailingLabel: String? = nil
    var trailingAction: (() -> Void)? = nil

    var body: some View {
        HStack {
            Text(title)
                .font(.hearthSubheadline)
                .foregroundColor(.textSecondary)

            Spacer()

            if let label = trailingLabel {
                Button(action: { trailingAction?() }) {
                    Text(label)
                        .font(.hearthCaption1)
                        .foregroundColor(.hearthTerracotta)
                }
            }
        }
        .padding(.horizontal, HS.lg)
        .padding(.vertical, HS.xs)
    }
}
