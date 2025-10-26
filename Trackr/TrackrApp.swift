import SwiftUI

@main
struct TrackrApp: App {
    @AppStorage("hasSeenOnboarding") private var hasSeenOnboarding = false
    
    var body: some Scene {
        WindowGroup {
            if hasSeenOnboarding {
                MainTabView()
            } else {
                OnboardingView(hasSeenOnboarding: $hasSeenOnboarding)
            }
        }
    }
}

