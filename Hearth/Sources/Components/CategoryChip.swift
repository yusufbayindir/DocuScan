import SwiftUI

struct CategoryChip: View {
    let category: Category
    var isSelected: Bool = false
    var onTap: (() -> Void)? = nil

    var body: some View {
        Button(action: { onTap?() }) {
            HStack(spacing: 6) {
                Text(category.emoji)
                    .font(.system(size: 14))
                Text(category.name)
                    .font(.hearthCaption1)
                    .foregroundColor(isSelected ? .white : .textPrimary)
            }
            .padding(.horizontal, HS.md)
            .padding(.vertical, 8)
            .background(
                isSelected
                    ? Color(hex: category.colorHex).opacity(0.9)
                    : Color.backgroundCard
            )
            .overlay(
                Capsule()
                    .stroke(
                        isSelected ? Color(hex: category.colorHex) : Color.borderSubtle,
                        lineWidth: 1
                    )
            )
            .clipShape(Capsule())
        }
        .buttonStyle(ScaleButtonStyle(scale: 0.96))
    }
}

struct CategoryChipRow: View {
    let categories: [Category]
    @Binding var selected: UUID?

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: HS.sm) {
                CategoryChip(
                    category: Category(id: UUID(), name: "All", emoji: "✨", colorHex: "#C15A3A"),
                    isSelected: selected == nil
                ) { selected = nil }

                ForEach(categories) { cat in
                    CategoryChip(
                        category: cat,
                        isSelected: selected == cat.id
                    ) {
                        selected = (selected == cat.id) ? nil : cat.id
                    }
                }
            }
            .padding(.horizontal, HS.lg)
        }
    }
}
