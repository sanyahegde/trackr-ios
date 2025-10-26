import SwiftUI

struct LoginView: View {
    @Environment(\.dismiss) var dismiss
    @State private var email = ""
    @State private var password = ""
    @State private var isLoading = false
    @State private var showError = false
    @State private var errorMessage = ""
    @State private var showForgotPassword = false
    
    var body: some View {
        NavigationView {
            ZStack {
                // Animated gradient background
                LinearGradient(
                    colors: [Color.blue.opacity(0.8), Color.purple.opacity(0.8), Color.pink.opacity(0.8)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        // Header
                        VStack(spacing: 8) {
                            Text("Welcome Back")
                                .font(.system(size: 32, weight: .bold, design: .rounded))
                                .foregroundColor(.white)
                            
                            Text("Continue your journey")
                                .font(.system(.subheadline, design: .rounded))
                                .foregroundColor(.white.opacity(0.8))
                        }
                        .padding(.top, 40)
                        .padding(.bottom, 40)
                        
                        // Form fields
                        VStack(spacing: 16) {
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
                                    .textContentType(.password)
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
                        
                        // Forgot password
                        Button(action: {
                            HapticManager.shared.impact(.light)
                            showForgotPassword = true
                        }) {
                            Text("Forgot Password?")
                                .font(.system(.subheadline, design: .rounded))
                                .foregroundColor(.white.opacity(0.9))
                                .underline()
                        }
                        .padding(.top, 8)
                        
                        // Login Button
                        Button(action: {
                            login()
                        }) {
                            HStack {
                                if isLoading {
                                    ProgressView()
                                        .progressViewStyle(.circular)
                                        .tint(.white)
                                } else {
                                    Text("Log In")
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
                        
                        // Sign up option
                        HStack {
                            Text("Don't have an account?")
                                .font(.system(.subheadline, design: .rounded))
                                .foregroundColor(.white.opacity(0.7))
                            
                            Button(action: {
                                dismiss()
                            }) {
                                Text("Sign Up")
                                    .font(.system(.subheadline, design: .rounded))
                                    .fontWeight(.semibold)
                                    .foregroundColor(.white)
                                    .underline()
                            }
                        }
                        .padding(.top, 20)
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
            .sheet(isPresented: $showForgotPassword) {
                ForgotPasswordView()
            }
        }
    }
    
    private func login() {
        guard !email.isEmpty && !password.isEmpty else {
            errorMessage = "Please enter your credentials"
            showError = true
            return
        }
        
        isLoading = true
        HapticManager.shared.impact(.medium)
        
        // TODO: Integrate Auth0 login
        // Simulate API call
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            isLoading = false
            HapticManager.shared.notification(.success)
            dismiss()
            // Navigate to main app
        }
    }
}

