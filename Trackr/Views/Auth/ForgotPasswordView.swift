import SwiftUI

struct ForgotPasswordView: View {
    @Environment(\.dismiss) var dismiss
    @State private var email = ""
    @State private var isLoading = false
    @State private var showSuccess = false
    
    var body: some View {
        NavigationView {
            ZStack {
                // Animated gradient background
                LinearGradient(
                    colors: [Color.blue.opacity(0.8), Color.purple.opacity(0.8)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                VStack(spacing: 32) {
                    Spacer()
                    
                    // Icon
                    Image(systemName: "lock.rotation")
                        .font(.system(size: 80, weight: .light))
                        .foregroundColor(.white)
                        .padding()
                    
                    // Header
                    VStack(spacing: 12) {
                        Text("Forgot Password?")
                            .font(.system(size: 32, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                        
                        Text("Enter your email and we'll send you instructions to reset your password")
                            .font(.system(.subheadline, design: .rounded))
                            .foregroundColor(.white.opacity(0.8))
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 40)
                    }
                    
                    // Email field
                    HStack {
                        Image(systemName: "envelope.fill")
                            .font(.system(size: 18))
                            .foregroundColor(.gray)
                            .frame(width: 44)
                        
                        TextField("Email", text: $email)
                            .font(.system(.body, design: .rounded))
                            .textContentType(.emailAddress)
                            .keyboardType(.emailAddress)
                            .autocapitalization(.none)
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(.ultraThinMaterial)
                            .overlay(
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(Color.white.opacity(0.3), lineWidth: 1)
                            )
                    )
                    .padding(.horizontal, 32)
                    
                    // Send button
                    if !showSuccess {
                        Button(action: {
                            sendResetPassword()
                        }) {
                            HStack {
                                if isLoading {
                                    ProgressView()
                                        .progressViewStyle(.circular)
                                        .tint(.white)
                                } else {
                                    Text("Send Reset Link")
                                        .font(.system(.body, design: .rounded))
                                        .fontWeight(.semibold)
                                }
                            }
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(
                                        LinearGradient(
                                            colors: [.blue.opacity(0.9), .purple.opacity(0.9)],
                                            startPoint: .leading,
                                            endPoint: .trailing
                                        )
                                    )
                                    .shadow(color: .blue.opacity(0.3), radius: 10, x: 0, y: 5)
                            )
                            .disabled(isLoading)
                        }
                        .padding(.horizontal, 32)
                    } else {
                        VStack(spacing: 12) {
                            Image(systemName: "checkmark.circle.fill")
                                .font(.system(size: 60))
                                .foregroundColor(.green)
                            
                            Text("Reset link sent!")
                                .font(.system(.title2, design: .rounded))
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                            
                            Text("Check your email for password reset instructions")
                                .font(.system(.subheadline, design: .rounded))
                                .foregroundColor(.white.opacity(0.8))
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 40)
                        }
                        .padding(.top, 40)
                    }
                    
                    Spacer()
                }
                .padding(.bottom, 40)
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(.white)
                }
            }
        }
    }
    
    private func sendResetPassword() {
        guard !email.isEmpty else { return }
        
        isLoading = true
        HapticManager.shared.impact(.medium)
        
        // TODO: Integrate Auth0 password reset
        // Auth0.shared.resetPassword(email: email)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            isLoading = false
            HapticManager.shared.notification(.success)
            showSuccess = true
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                dismiss()
            }
        }
    }
}

