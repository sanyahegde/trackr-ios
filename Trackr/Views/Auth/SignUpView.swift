import SwiftUI

struct SignUpView: View {
    @Environment(\.dismiss) var dismiss
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var fullName = ""
    @State private var isLoading = false
    @State private var showError = false
    @State private var errorMessage = ""
    
    var body: some View {
        NavigationView {
            ZStack {
                // Animated gradient background
                LinearGradient(
                    colors: [Color.purple.opacity(0.8), Color.blue.opacity(0.8), Color.pink.opacity(0.8)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        // Header
                        VStack(spacing: 8) {
                            Text("Create Your Account")
                                .font(.system(size: 32, weight: .bold, design: .rounded))
                                .foregroundColor(.white)
                            
                            Text("Start achieving your goals today")
                                .font(.system(.subheadline, design: .rounded))
                                .foregroundColor(.white.opacity(0.8))
                        }
                        .padding(.top, 40)
                        .padding(.bottom, 20)
                        
                        // Form fields
                        VStack(spacing: 16) {
                            // Full Name
                            HStack {
                                Image(systemName: "person.fill")
                                    .font(.system(size: 18))
                                    .foregroundColor(.gray)
                                    .frame(width: 44)
                                
                                TextField("Full Name", text: $fullName)
                                    .font(.system(.body, design: .rounded))
                                    .textContentType(.name)
                                    .autocapitalization(.words)
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
                            
                            // Email
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
                            
                            // Password
                            HStack {
                                Image(systemName: "lock.fill")
                                    .font(.system(size: 18))
                                    .foregroundColor(.gray)
                                    .frame(width: 44)
                                
                                SecureField("Password", text: $password)
                                    .font(.system(.body, design: .rounded))
                                    .textContentType(.newPassword)
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
                            
                            // Confirm Password
                            HStack {
                                Image(systemName: "lock.fill")
                                    .font(.system(size: 18))
                                    .foregroundColor(.gray)
                                    .frame(width: 44)
                                
                                SecureField("Confirm Password", text: $confirmPassword)
                                    .font(.system(.body, design: .rounded))
                                    .textContentType(.newPassword)
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
                        }
                        .padding(.horizontal, 32)
                        .padding(.top, 20)
                        
                        // Sign Up Button
                        Button(action: {
                            signUp()
                        }) {
                            HStack {
                                if isLoading {
                                    ProgressView()
                                        .progressViewStyle(.circular)
                                        .tint(.white)
                                } else {
                                    Text("Sign Up")
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
                        .padding(.top, 20)
                        
                        // Error message
                        if showError {
                            Text(errorMessage)
                                .font(.system(.caption, design: .rounded))
                                .foregroundColor(.red)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(.ultraThinMaterial)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 12)
                                                .stroke(Color.red.opacity(0.5), lineWidth: 1)
                                        )
                                )
                                .padding(.horizontal, 32)
                        }
                        
                        // Terms and privacy
                        Text("By signing up, you agree to our Terms of Service and Privacy Policy")
                            .font(.system(.caption2, design: .rounded))
                            .foregroundColor(.white.opacity(0.7))
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 32)
                            .padding(.top, 8)
                    }
                    .padding(.bottom, 40)
                }
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
    
    private func signUp() {
        guard !email.isEmpty && !password.isEmpty && password == confirmPassword else {
            errorMessage = "Please fill all fields correctly"
            showError = true
            return
        }
        
        isLoading = true
        HapticManager.shared.impact(.medium)
        
        // TODO: Integrate Auth0 sign up
        // Simulate API call
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            isLoading = false
            HapticManager.shared.notification(.success)
            dismiss()
            // Navigate to main app
        }
    }
}

