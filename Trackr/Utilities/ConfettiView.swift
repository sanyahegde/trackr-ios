import SwiftUI

struct ConfettiView: View {
    @State private var animate = false
    @State private var confettiCount = 50
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                ForEach(0..<confettiCount, id: \.self) { index in
                    ConfettiPiece(index: index, animate: animate)
                        .onAppear {
                            withAnimation(.linear(duration: 3.0).delay(Double(index) * 0.05)) {
                                animate = true
                            }
                        }
                }
            }
        }
    }
}

struct ConfettiPiece: View {
    let index: Int
    let animate: Bool
    
    @State private var colors: [Color] = [.blue, .purple, .pink, .orange, .green, .yellow]
    @State private var randomColor: Color = .blue
    @State private var randomRotation: Double = 0
    @State private var randomOffset: CGSize = .zero
    
    var body: some View {
        Circle()
            .fill(randomColor.opacity(0.8))
            .frame(width: 12, height: 12)
            .offset(x: animate ? CGFloat.random(in: -200...200) : CGFloat.random(in: -50...50),
                   y: animate ? CGFloat.random(in: -100...600) : 0)
            .rotationEffect(.degrees(animate ? randomRotation * 360 : 0))
            .opacity(animate ? 0 : 1)
            .onAppear {
                randomColor = colors.randomElement() ?? .blue
                randomRotation = Double.random(in: 0...360)
                randomOffset = CGSize(width: CGFloat.random(in: -200...200), height: CGFloat.random(in: 0...600))
            }
    }
}

struct ConfettiModifier: ViewModifier {
    @State private var showConfetti = false
    
    func body(content: Content) -> some View {
        ZStack {
            content
            
            if showConfetti {
                ConfettiView()
                    .allowsHitTesting(false)
            }
        }
        .onAppear {
            showConfetti = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                showConfetti = false
            }
        }
    }
}

extension View {
    func confetti() -> some View {
        modifier(ConfettiModifier())
    }
}

