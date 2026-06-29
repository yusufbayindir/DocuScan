import SwiftUI

enum PrimaryButtonVariant { case `default`, destructive }

struct HearthPrimaryButton: View {
    let title: String
    var variant: PrimaryButtonVariant = .default
    var isLoading: Bool = false
    var isDisabled: Bool = false
    let action: () -> Void

    private var bg: Color {
        switch variant {
        case .default:     return .hearthTerracotta
        case .destructive: return Color(red: 0.835, green: 0.169, blue: 0.169)
        }
    }

    var body: some View {
        Button(action: {
            let gen = UIImpactFeedbackGenerator(style: .medium)
            gen.impactOccurred()
            action()
        }) {
            ZStack {
                if isLoading {
                    ProgressView().tint(.white)
                } else {
                    Text(title)
                        .font(.hearthHeadline)
                        .foregroundColor(.textInverse)
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 56)
            .background(bg.opacity(isDisabled ? 0.38 : 1))
            .cornerRadius(HR.lg)
            .shadowBrandGlow()
        }
        .disabled(isDisabled || isLoading)
        .buttonStyle(ScaleButtonStyle(scale: 0.97))
    }
}

struct SecondaryButtonStyle_Outlined: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.hearthHeadline)
            .foregroundColor(.hearthTerracotta)
            .frame(maxWidth: .infinity)
            .frame(height: 56)
            .background(Color.clear)
            .overlay(RoundedRectangle(cornerRadius: HR.lg).stroke(Color.hearthTerracotta, lineWidth: 1.5))
            .scaleEffect(configuration.isPressed ? 0.97 : 1)
            .animation(.spring(response: 0.3, dampingFraction: 0.85), value: configuration.isPressed)
    }
}

struct ScaleButtonStyle: ButtonStyle {
    var scale: CGFloat = 0.97
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? scale : 1)
            .animation(.spring(response: 0.3, dampingFraction: 0.85), value: configuration.isPressed)
    }
}
