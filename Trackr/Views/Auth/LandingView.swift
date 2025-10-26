import SwiftUI

struct LandingView: View {
    @State private var animateGradient = false
    @State private var showSignUp = false
    @State private var showLogin = false
    @State private var showOnboarding = false
    @AppStorage("hasSeenOnboarding") private var hasSeenOnboarding = false
    
    var body: some View {
        ZStack {
            // Animated gradient background
            AnimatedGradientBackground()
            
            VStack(spacing: 40) {
                Spacer()
                
                // Logo and branding
                VStack(spacing: 20) {
                    // App Logo
                    ZStack {
                        Circle()
                            .fill(
                                LinearGradient(
                                    colors: [.white.opacity(0.3), .white.opacity(0.1)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 120, height: 120)
                            .shadow(color: .white.opacity(0.3), radius: 20, x: 0, y: 10)
                        
                        Image(systemName: "target")
                            .font(.system(size: 60, weight: .light))
                            .foregroundColor(.white)
                    }
                    
                    Text("Trackr")
                        .font(.system(size: 52, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                        .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 5)
                    
                    Text("Achieve your goals together")
                        .font(.system(size: 18, weight: .medium, design: .rounded))
                        .foregroundColor(.white.opacity(0.9))
                }
                .padding(.top, 60)
                
                Spacer()
                
                // Auth buttons
                VStack(spacing: 16) {
                    // Continue with Apple
                    Button(action: {
                        HapticManager.shared.impact(.medium)
                        // Handle Apple Sign In
                    }) {
                        HStack {
                            Image(systemName: "applelogo")
                            Text("Continue with Apple")
                                .font(.system(.body, design: .rounded))
                                .fontWeight(.semibold)
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color(.systemGray).opacity(0.3))
                                .background(
                                    RoundedRectangle(cornerRadius: 16)
                                        .fill(.ultraThinMaterial)
                                )
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(Color.white.opacity(0.3), lineWidth: 1)
                        )
                    }
                    
                    // Continue with Google
                    Button(action: {
                        HapticManager.shared.impact(.medium)
                        // Handle Google Sign In
                    }) {
                        HStack {
                            Image(systemName: "globe")
                            Text("Continue with Google")
                                .font(.system(.body, design: .rounded))
                                .fontWeight(.semibold)
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color(.systemGray).opacity(0.3))
                                .background(
                                    RoundedRectangle(cornerRadius: 16)
                                        .fill(.ultraThinMaterial)
                                )
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(Color.white.opacity(0.3), lineWidth: 1)
                        )
                    }
                    
                    // Regular sign up
                    Button(action: {
                        HapticManager.shared.impact(.light)
                        showSignUp = true
                    }) {
                        Text("Sign Up with Email")
                            .font(.system(.body, design: .rounded))
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(
                                        LinearGradient(
                                            colors: [.blue.opacity(0.8), .purple.opacity(0.8)],
                                            startPoint: .leading,
                                            endPoint: .trailing
                                        )
                                    )
                                    .shadow(color: .blue.opacity(0.3), radius: 10, x: 0, y: 5)
                            )
                    }
                    
                    // Login
                    Button(action: {
                        HapticManager.shared.impact(.light)
                        showLogin = true
                    }) {
                        Text("Already have an account? Log In")
                            .font(.system(.subheadline, design: .rounded))
                            .foregroundColor(.white.opacity(0.9))
                            .underline()
                    }
                }
                .padding(.horizontal, 32)
                .padding(.bottom, 40)
            }
        }
        .sheet(isPresented: $showSignUp) {
            SignUpView()
        }
        .sheet(isPresented: $showLogin) {
            LoginView()
        }
        .fullScreenCover(isPresented: $showOnboarding) {
            OnboardingWalkthroughView()
        }
        .onAppear {
            if !hasSeenOnboarding {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    showOnboarding = true
                }
            }
        }
    }
}

struct AnimatedGradientBackground: View {
    @State private var animateGradient = false
    
    var body: some View {
        ZStack {
            LinearGradient(
                colors: animateGradient ? 
                    [Color.purple, Color.blue, Color.pink, Color.orange] :
                    [Color.orange, Color.pink, Color.blue, Color.purple],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            .onAppear {
                withAnimation(.easeInOut(duration: 3.0).repeatForever(autoreverses: true)) {
                    animateGradient.toggle()
                }
            }
        }
    }
}

