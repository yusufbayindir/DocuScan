import SwiftUI

// MARK: - Shadows
extension View {
    func shadowSubtle() -> some View {
        self.shadow(color: Color(red:0.11, green:0.08, blue:0.06).opacity(0.06), radius: 3, x: 0, y: 1)
    }
    func shadowMedium() -> some View {
        self.shadow(color: Color(red:0.11, green:0.08, blue:0.06).opacity(0.10), radius: 12, x: 0, y: 4)
    }
    func shadowStrong() -> some View {
        self.shadow(color: Color(red:0.11, green:0.08, blue:0.06).opacity(0.16), radius: 24, x: 0, y: 8)
    }
    func shadowBrandGlow() -> some View {
        self.shadow(color: Color.hearthTerracotta.opacity(0.22), radius: 16, x: 0, y: 4)
    }
}

// MARK: - Card / Sheet
extension View {
    func hearthCard() -> some View {
        self
            .background(Color.backgroundCard)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .shadowMedium()
    }
    func hearthSheet() -> some View {
        self
            .background(Color.backgroundPrimary)
            .clipShape(UnevenRoundedRectangle(topLeadingRadius: 28, bottomLeadingRadius: 0, bottomTrailingRadius: 0, topTrailingRadius: 28))
            .shadowStrong()
    }
}

// MARK: - Spacing constants
enum HS {
    static let xs:  CGFloat = 4
    static let sm:  CGFloat = 8
    static let md:  CGFloat = 16
    static let lg:  CGFloat = 24
    static let xl:  CGFloat = 32
    static let xxl: CGFloat = 48
}

// MARK: - Radius constants
enum HR {
    static let xs:   CGFloat = 4
    static let sm:   CGFloat = 8
    static let md:   CGFloat = 12
    static let lg:   CGFloat = 16
    static let xl:   CGFloat = 20
    static let xxl:  CGFloat = 28
    static let full: CGFloat = 999
}
