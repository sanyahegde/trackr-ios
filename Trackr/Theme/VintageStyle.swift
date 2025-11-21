import SwiftUI

struct VintageCardModifier: ViewModifier {
    @Environment(\.colorScheme) var colorScheme
    
    func body(content: Content) -> some View {
        content
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(colorScheme == .dark ? VintageColors.parchment : Color.white)
                    .shadow(
                        color: colorScheme == .dark 
                            ? Color.black.opacity(0.3) 
                            : VintageColors.deepBrown.opacity(0.15),
                        radius: colorScheme == .dark ? 10 : 8,
                        x: 0,
                        y: colorScheme == .dark ? 4 : 4
                    )
            )
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(
                        colorScheme == .dark 
                            ? Color.white.opacity(0.1)
                            : VintageColors.sepia.opacity(0.3),
                        lineWidth: colorScheme == .dark ? 1 : 2
                    )
            )
    }
}

extension View {
    func vintageCard() -> some View {
        modifier(VintageCardModifier())
    }
}

struct VintageButtonStyle: ButtonStyle {
    let color: Color
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(.horizontal, 24)
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(color)
                    .shadow(color: color.opacity(0.3), radius: 6, x: 0, y: 3)
            )
            .foregroundColor(.white)
            .fontWeight(.semibold)
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
    }
}

struct VintageProgressStyle: ProgressViewStyle {
    var color: Color = VintageColors.forestGreen
    
    func makeBody(configuration: Configuration) -> some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 8)
                    .fill(VintageColors.warmGray.opacity(0.3))
                    .frame(height: 12)
                
                RoundedRectangle(cornerRadius: 8)
                    .fill(
                        LinearGradient(
                            colors: [color, color.opacity(0.7)],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .frame(width: geometry.size.width * CGFloat(configuration.fractionCompleted ?? 0), height: 12)
                    .animation(.spring(response: 0.6, dampingFraction: 0.8), value: configuration.fractionCompleted)
            }
        }
    }
}

