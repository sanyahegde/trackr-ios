import SwiftUI

struct MainTabView: View {
    @StateObject private var goalStore: GoalStore
    
    init() {
        let sampleUser = User(name: "You", username: "you")
        _goalStore = StateObject(wrappedValue: GoalStore(currentUser: sampleUser))
    }
    
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }
                .tag(0)
            
            ContentView()
                .environmentObject(goalStore)
                .tabItem {
                    Label("Goals", systemImage: "target")
                }
                .tag(1)
            
            DashboardView(goalStore: goalStore)
                .tabItem {
                    Label("Dashboard", systemImage: "chart.bar.fill")
                }
                .tag(2)
            
            LeaderboardView(goalStore: goalStore)
                .tabItem {
                    Label("Leaderboard", systemImage: "trophy.fill")
                }
                .tag(3)
            
            ProfileView()
                .environmentObject(goalStore)
                .tabItem {
                    Label("Profile", systemImage: "person.fill")
                }
                .tag(4)
        }
        .accentColor(.blue)
    }
}

