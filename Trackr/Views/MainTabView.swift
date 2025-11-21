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
                
                SearchView()
                    .tabItem {
                        Label("Search", systemImage: "magnifyingglass")
                    }
                    .tag(1)
                
                ContentView()
                    .environmentObject(goalStore)
                    .tabItem {
                        Label("Goals", systemImage: "target")
                    }
                    .tag(2)
                
                // Combined Dashboard & Leaderboard
                DashboardView(goalStore: goalStore)
                    .tabItem {
                        Label("Stats", systemImage: "chart.bar.fill")
                    }
                    .tag(3)
                
                ProfileView()
                    .environmentObject(goalStore)
                    .tabItem {
                        Label("Profile", systemImage: "person.fill")
                    }
                    .tag(4)
                
                // Messages/Notifications Tab
                MessagesView()
                    .tabItem {
                        Label("Messages", systemImage: "message.fill")
                    }
                    .tag(5)
                    .badge(NotificationService.shared.unreadCount)
            }
            .accentColor(AppColors.primaryCoral)
            .sheet(isPresented: $showingCreatePost) {
                CreatePostView(viewModel: HomeFeedViewModel())
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
                                .fill(AppColors.gradientPrimary)
                                .frame(width: 56, height: 56)
                                .shadow(
                                    color: AppColors.primaryCoral.opacity(0.4),
                                    radius: 12,
                                    x: 0,
                                    y: 6
                                )
                            
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

