import SwiftUI

struct OnboardingWalkthroughView: View {
    @AppStorage("hasSeenOnboarding") private var hasSeenOnboarding = false
    @State private var currentPage = 0
    
    var body: some View {
        ZStack {
            // Background gradient
            LinearGradient(
                colors: [Color.purple, Color.blue, Color.pink],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            TabView(selection: $currentPage) {
                // Page 1: Track Your Goals
                OnboardingWalkthroughPage(
                    icon: "target",
                    title: "Track Your Goals",
                    description: "Set meaningful goals and track your progress with beautiful visual timelines",
                    gradientColors: [.blue, .purple]
                )
                .tag(0)
                
                // Page 2: Connect with Friends
                OnboardingWalkthroughPage(
                    icon: "person.2.fill",
                    title: "Connect with Friends",
                    description: "Share your journey and stay motivated with your community",
                    gradientColors: [.pink, .purple]
                )
                .tag(1)
                
                // Page 3: Achieve Together
                OnboardingWalkthroughPage(
                    icon: "trophy.fill",
                    title: "Achieve Together",
                    description: "Celebrate milestones and compete in friendly leaderboards",
                    gradientColors: [.orange, .pink]
                )
                .tag(2)
            }
            .tabViewStyle(.page)
            .indexViewStyle(.page(backgroundDisplayMode: .always))
            
            // Get Started button
            VStack {
                Spacer()
                
                if currentPage == 2 {
                    Button(action: {
                        withAnimation(.spring(response: 0.6)) {
                            hasSeenOnboarding = true
                            HapticManager.shared.notification(.success)
                        }
                    }) {
                        Text("Get Started")
                            .font(.system(.title3, design: .rounded))
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(
                                        LinearGradient(
                                            colors: [.blue.opacity(0.9), .purple.opacity(0.9)],
                                            startPoint: .leading,
                                            endPoint: .trailing
                                        )
                                    )
                                    .shadow(color: .blue.opacity(0.4), radius: 20, x: 0, y: 10)
                            )
                    }
                    .padding(.horizontal, 40)
                    .padding(.bottom, 40)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                }
            }
        }
    }
}

struct OnboardingWalkthroughPage: View {
    let icon: String
    let title: String
    let description: String
    let gradientColors: [Color]
    
    var body: some View {
        VStack(spacing: 40) {
            Spacer()
            
            // Icon with gradient background
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: gradientColors,
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 160, height: 160)
                    .shadow(color: gradientColors.first!.opacity(0.4), radius: 30, x: 0, y: 15)
                
                Image(systemName: icon)
                    .font(.system(size: 80, weight: .light))
                    .foregroundColor(.white)
            }
            
            // Text content
            VStack(spacing: 16) {
                Text(title)
                    .font(.system(size: 36, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                
                Text(description)
                    .font(.system(size: 18, design: .rounded))
                    .foregroundColor(.white.opacity(0.9))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
            }
            
            Spacer()
        }
        .padding()
    }
}

