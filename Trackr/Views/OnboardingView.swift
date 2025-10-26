import SwiftUI

struct OnboardingView: View {
    @Binding var hasSeenOnboarding: Bool
    @State private var currentPage = 0
    
    var body: some View {
        ZStack {
            // Background gradient
            LinearGradient(
                colors: [Color.blue.opacity(0.1), Color.purple.opacity(0.1)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            TabView(selection: $currentPage) {
                OnboardingPage(
                    icon: "target",
                    title: "Set Your Goals",
                    description: "Create meaningful objectives and track your progress with beautiful, intuitive visuals.",
                    color: .blue
                )
                .tag(0)
                
                OnboardingPage(
                    icon: "chart.bar.fill",
                    title: "See Your Progress",
                    description: "Visualize your achievements with interactive dashboards and detailed analytics.",
                    color: .orange
                )
                .tag(1)
                
                OnboardingPage(
                    icon: "person.2.fill",
                    title: "Compete with Friends",
                    description: "Stay motivated with leaderboards and share your success with your community.",
                    color: .green
                )
                .tag(2)
            }
            .tabViewStyle(.page)
            .indexViewStyle(.page(backgroundDisplayMode: .always))
            
            VStack {
                Spacer()
                
                Button(action: {
                    if currentPage < 2 {
                        withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                            currentPage += 1
                        }
                    } else {
                        withAnimation {
                            hasSeenOnboarding = true
                        }
                    }
                }) {
                    HStack {
                        Text(currentPage < 2 ? "Next" : "Get Started")
                            .font(.system(.body, design: .rounded))
                            .fontWeight(.semibold)
                        
                        if currentPage < 2 {
                            Image(systemName: "arrow.right")
                        }
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color.blue)
                            .shadow(color: Color.blue.opacity(0.3), radius: 10, x: 0, y: 5)
                    )
                }
                .padding(.horizontal, 32)
                .padding(.bottom, 50)
            }
        }
    }
}

struct OnboardingPage: View {
    let icon: String
    let title: String
    let description: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 40) {
            Spacer()
            
            // Icon
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [color, color.opacity(0.6)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 120, height: 120)
                    .shadow(color: color.opacity(0.3), radius: 20, x: 0, y: 10)
                
                Image(systemName: icon)
                    .font(.system(size: 60))
                    .foregroundColor(.white)
            }
            .padding(.bottom, 40)
            
            // Text content
            VStack(spacing: 16) {
                Text(title)
                    .font(.system(.largeTitle, design: .rounded))
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                
                Text(description)
                    .font(.system(.body, design: .rounded))
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
            }
            
            Spacer()
        }
    }
}

