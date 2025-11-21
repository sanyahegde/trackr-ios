import SwiftUI

@main
struct TrackrApp: App {
    @StateObject private var authManager = AuthManager.shared
    @AppStorage("hasSeenOnboarding") private var hasSeenOnboarding = false
    @AppStorage("skipAuthForTesting") private var skipAuthForTesting = true // Set to false to enable auth
    @AppStorage("preferredColorScheme") private var preferredColorScheme = 0 // 0=auto, 1=light, 2=dark
    
    init() {
        // Observe changes to skipAuthForTesting to update UI
    }
    
    var body: some Scene {
        WindowGroup {
            if skipAuthForTesting || authManager.isAuthenticated {
                MainTabView()
                    .preferredColorScheme(
                        preferredColorScheme == 0 ? nil : (preferredColorScheme == 1 ? .light : .dark)
                    )
                    .transition(.move(edge: .trailing).combined(with: .opacity))
                    .tint(AppColors.primaryCoral)
            } else {
                LandingView()
                    .preferredColorScheme(
                        preferredColorScheme == 0 ? nil : (preferredColorScheme == 1 ? .light : .dark)
                    )
                    .transition(.move(edge: .leading).combined(with: .opacity))
            }
        }
        .environmentObject(authManager)
    }
}

 
