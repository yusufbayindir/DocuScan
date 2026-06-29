import SwiftUI

enum AvatarSize {
    case sm, md, lg
    var points: CGFloat { switch self { case .sm: 20; case .md: 32; case .lg: 56 } }
    var fontSize: CGFloat { switch self { case .sm: 9; case .md: 13; case .lg: 22 } }
}

struct PartnerAvatar: View {
    var name: String
    var isPartnerA: Bool = true
    var size: AvatarSize = .md
    var badgeCount: Int? = nil

    private var initials: String { String(name.prefix(2)).uppercased() }
    private var gradient: LinearGradient {
        isPartnerA
            ? LinearGradient(colors: [.hearthTerracotta, .hearthSienna], startPoint: .topLeading, endPoint: .bottomTrailing)
            : LinearGradient(colors: [.hearthDustyRose, Color(red:0.7,green:0.45,blue:0.43)], startPoint: .topLeading, endPoint: .bottomTrailing)
    }

    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            ZStack {
                gradient
                Text(initials)
                    .font(.system(size: size.fontSize, weight: .semibold))
                    .foregroundColor(.white)
            }
            .frame(width: size.points, height: size.points)
            .clipShape(Circle())

            if let count = badgeCount, count > 0 {
                Text("\(min(count, 99))")
                    .font(.system(size: 9, weight: .bold))
                    .foregroundColor(.white)
                    .padding(.horizontal, 4)
                    .padding(.vertical, 2)
                    .background(Color.hearthTerracotta)
                    .clipShape(Capsule())
                    .offset(x: 4, y: 4)
            }
        }
    }
}

struct StackedPartnerAvatars: View {
    var nameA: String
    var nameB: String?
    var size: AvatarSize = .md

    var body: some View {
        HStack(spacing: -size.points * 0.25) {
            if let b = nameB {
                PartnerAvatar(name: b, isPartnerA: false, size: size)
                    .overlay(Circle().stroke(Color.backgroundCard, lineWidth: 2))
            }
            PartnerAvatar(name: nameA, isPartnerA: true, size: size)
                .overlay(Circle().stroke(Color.backgroundCard, lineWidth: 2))
        }
    }
}
