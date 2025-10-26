import SwiftUI

struct MainTabView: View {
    @StateObject private var goalStore: GoalStore
    
    init() {
        let sampleUser = User(name: "You", username: "you")
        _goalStore = StateObject(wrappedValue: GoalStore(currentUser: sampleUser))
    }
    
    var body: some View {
        TabView {
            ContentView()
                .environmentObject(goalStore)
                .tabItem {
                    Label("Goals", systemImage: "target")
                }
            
            DashboardView(goalStore: goalStore)
                .tabItem {
                    Label("Dashboard", systemImage: "chart.bar.fill")
                }
            
            LeaderboardView(goalStore: goalStore)
                .tabItem {
                    Label("Leaderboard", systemImage: "trophy.fill")
                }
            
            ProfileView()
                .environmentObject(goalStore)
                .tabItem {
                    Label("Profile", systemImage: "person.fill")
                }
        }
        .accentColor(.blue)
    }
}

