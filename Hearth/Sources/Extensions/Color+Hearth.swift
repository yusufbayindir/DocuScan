import SwiftUI

extension Color {
    // MARK: - Brand
    static let hearthTerracotta = Color(red: 0.757, green: 0.353, blue: 0.227)
    static let hearthCoral      = Color(red: 0.831, green: 0.447, blue: 0.353)
    static let hearthSienna     = Color(red: 0.608, green: 0.239, blue: 0.133)
    static let hearthAmber      = Color(red: 0.910, green: 0.643, blue: 0.290)
    static let hearthCream      = Color(red: 0.961, green: 0.929, blue: 0.878)
    static let hearthDustyRose  = Color(red: 0.831, green: 0.627, blue: 0.604)

    // MARK: - Adaptive Backgrounds
    static let backgroundPrimary = Color(UIColor { t in
        t.userInterfaceStyle == .dark
            ? UIColor(red: 0.102, green: 0.078, blue: 0.063, alpha: 1)
            : UIColor(red: 0.961, green: 0.929, blue: 0.878, alpha: 1)
    })
    static let backgroundSecondary = Color(UIColor { t in
        t.userInterfaceStyle == .dark
            ? UIColor(red: 0.141, green: 0.110, blue: 0.086, alpha: 1)
            : UIColor(red: 0.933, green: 0.894, blue: 0.831, alpha: 1)
    })
    static let backgroundTertiary = Color(UIColor { t in
        t.userInterfaceStyle == .dark
            ? UIColor(red: 0.180, green: 0.141, blue: 0.110, alpha: 1)
            : UIColor(red: 0.902, green: 0.855, blue: 0.784, alpha: 1)
    })
    static let backgroundCard = Color(UIColor { t in
        t.userInterfaceStyle == .dark
            ? UIColor(red: 0.165, green: 0.125, blue: 0.094, alpha: 1)
            : UIColor(red: 0.992, green: 0.980, blue: 0.965, alpha: 1)
    })

    // MARK: - Adaptive Text
    static let textPrimary = Color(UIColor { t in
        t.userInterfaceStyle == .dark
            ? UIColor(red: 0.941, green: 0.902, blue: 0.847, alpha: 1)
            : UIColor(red: 0.110, green: 0.078, blue: 0.063, alpha: 1)
    })
    static let textSecondary = Color(UIColor { t in
        t.userInterfaceStyle == .dark
            ? UIColor(red: 0.722, green: 0.627, blue: 0.565, alpha: 1)
            : UIColor(red: 0.361, green: 0.290, blue: 0.227, alpha: 1)
    })
    static let textTertiary = Color(UIColor { t in
        t.userInterfaceStyle == .dark
            ? UIColor(red: 0.478, green: 0.400, blue: 0.345, alpha: 1)
            : UIColor(red: 0.612, green: 0.518, blue: 0.447, alpha: 1)
    })
    static let textInverse = Color(UIColor { t in
        t.userInterfaceStyle == .dark
            ? UIColor(red: 0.110, green: 0.078, blue: 0.063, alpha: 1)
            : UIColor(red: 0.992, green: 0.980, blue: 0.965, alpha: 1)
    })
    static let textLink = Color(UIColor { t in
        t.userInterfaceStyle == .dark
            ? UIColor(red: 0.878, green: 0.478, blue: 0.361, alpha: 1)
            : UIColor(red: 0.757, green: 0.353, blue: 0.227, alpha: 1)
    })

    // MARK: - Borders
    static let borderSubtle  = Color.textSecondary.opacity(0.12)
    static let borderDefault = Color.textSecondary.opacity(0.24)
    static let borderStrong  = Color.textSecondary.opacity(0.48)

    // MARK: - Semantic
    static let semanticSuccessBg  = Color(UIColor { t in t.userInterfaceStyle == .dark ? UIColor(red:0.051,green:0.180,blue:0.098,alpha:1) : UIColor(red:0.910,green:0.961,blue:0.925,alpha:1) })
    static let semanticSuccessFg  = Color(UIColor { t in t.userInterfaceStyle == .dark ? UIColor(red:0.298,green:0.784,blue:0.478,alpha:1) : UIColor(red:0.122,green:0.478,blue:0.243,alpha:1) })
    static let semanticWarningBg  = Color(UIColor { t in t.userInterfaceStyle == .dark ? UIColor(red:0.180,green:0.118,blue:0.024,alpha:1) : UIColor(red:0.996,green:0.953,blue:0.886,alpha:1) })
    static let semanticWarningFg  = Color(UIColor { t in t.userInterfaceStyle == .dark ? UIColor(red:0.941,green:0.659,blue:0.196,alpha:1) : UIColor(red:0.604,green:0.369,blue:0.039,alpha:1) })
    static let semanticErrorBg    = Color(UIColor { t in t.userInterfaceStyle == .dark ? UIColor(red:0.180,green:0.051,blue:0.051,alpha:1) : UIColor(red:0.988,green:0.933,blue:0.929,alpha:1) })
    static let semanticErrorFg    = Color(UIColor { t in t.userInterfaceStyle == .dark ? UIColor(red:0.941,green:0.439,blue:0.439,alpha:1) : UIColor(red:0.690,green:0.110,blue:0.110,alpha:1) })

    static let aiCoachBackground  = Color(UIColor { t in
        t.userInterfaceStyle == .dark
            ? UIColor(red: 0.180, green: 0.102, blue: 0.039, alpha: 1)
            : UIColor(red: 1.000, green: 0.941, blue: 0.910, alpha: 1)
    })

    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        guard Scanner(string: hex).scanHexInt64(&int), hex.count == 6 else {
            self = .hearthAmber
            return
        }
        let r = Double((int >> 16) & 0xFF) / 255
        let g = Double((int >> 8)  & 0xFF) / 255
        let b = Double(int         & 0xFF) / 255
        self.init(red: r, green: g, blue: b)
    }
}
