import SwiftUI

struct MainTabView: View {
    @StateObject private var goalStore: GoalStore
    @State private var showingCreatePost = false
    
    init() {
        let sampleUser = User(name: "You", username: "you")
        _goalStore = StateObject(wrappedValue: GoalStore(currentUser: sampleUser))
    }
    
    var body: some View {
        ZStack {
            TabView(selection: .constant(0)) {
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
                
                // Center button placeholder
                Color.clear
                    .tabItem {
                        Label("", systemImage: "")
                    }
                    .tag(2)
                    .opacity(0)
                
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
            .sheet(isPresented: $showingCreatePost) {
                // CreatePostView will be shown here
                Text("Create Post")
            }
            
            // Floating create button
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Button(action: {
                        HapticManager.shared.impact(.medium)
                        showingCreatePost = true
                    }) {
                        ZStack {
                            Circle()
                                .fill(
                                    LinearGradient(
                                        colors: [.blue, .purple],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .frame(width: 56, height: 56)
                                .shadow(color: .blue.opacity(0.3), radius: 10, x: 0, y: 5)
                            
                            Image(systemName: "plus")
                                .font(.system(size: 24, weight: .bold))
                                .foregroundColor(.white)
                        }
                    }
                    .padding(.trailing, 16)
                    .padding(.bottom, 32)
                }
            }
        }
    }
}

