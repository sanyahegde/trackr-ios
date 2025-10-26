import SwiftUI

@main
struct TrackrApp: App {
    @StateObject private var authManager = AuthManager.shared
    @AppStorage("hasSeenOnboarding") private var hasSeenOnboarding = false
    @AppStorage("skipAuthForTesting") private var skipAuthForTesting = true // Set to false to enable auth
    
    var body: some Scene {
        WindowGroup {
            if skipAuthForTesting || authManager.isAuthenticated {
                MainTabView()
                    .transition(.move(edge: .trailing).combined(with: .opacity))
            } else {
                LandingView()
                    .transition(.move(edge: .leading).combined(with: .opacity))
            }
        }
        .environmentObject(authManager)
    }
}

 
