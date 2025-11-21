import SwiftUI
import Charts

enum DashboardSection: String, CaseIterable {
    case dashboard = "Dashboard"
    case leaderboard = "Leaderboard"
}

struct DashboardLeaderboardView: View {
    @ObservedObject var goalStore: GoalStore
    @StateObject private var analytics: AnalyticsViewModel
    @StateObject private var leaderboard = LeaderboardViewModel()
    @State private var selectedSection: DashboardSection = .dashboard
    @Environment(\.colorScheme) var colorScheme
    
    var mockFriends: [User] = [
        User(name: "Alex Chen", username: "alexchen"),
        User(name: "Sam Rodriguez", username: "samrod"),
        User(name: "Jordan Taylor", username: "jordant")
    ]
    
    init(goalStore: GoalStore) {
        self.goalStore = goalStore
        _analytics = StateObject(wrappedValue: AnalyticsViewModel(goals: goalStore.goals))
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                // Adaptive background that supports dark mode
                VintageColors.cream
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Segmented Control for Dashboard/Leaderboard
                    Picker("Section", selection: $selectedSection) {
                        ForEach(DashboardSection.allCases, id: \.self) { section in
                            Text(section.rawValue).tag(section)
                        }
                    }
                    .pickerStyle(.segmented)
                    .padding(.horizontal)
                    .padding(.top, 8)
                    
                    ScrollView {
                        if selectedSection == .dashboard {
                            dashboardContent
                        } else {
                            leaderboardContent
                        }
                    }
                }
            }
            .navigationTitle("Stats & Rankings")
            .navigationBarTitleDisplayMode(.large)
            .onAppear {
                analytics.update(with: goalStore.goals)
                leaderboard.update(from: mockFriends, goals: goalStore.goals)
            }
            .onChange(of: selectedSection) { _, _ in
                HapticManager.shared.selection()
            }
        }
    }
    
    // MARK: - Dashboard Content
    private var dashboardContent: some View {
        VStack(spacing: 24) {
            // Header Stats
            DashboardHeaderView(analytics: analytics.analytics)
            
            // Completion Rate Chart
            CompletionChartView(analytics: analytics.analytics)
            
            // Category Distribution Chart
            CategoryChartView(analytics: analytics.analytics)
            
            // Progress Overview
            ProgressOverviewView(analytics: analytics.analytics)
        }
        .padding()
    }
    
    // MARK: - Leaderboard Content
    private var leaderboardContent: some View {
        VStack(spacing: 20) {
            // Filter Picker
            Picker("Filter", selection: $leaderboard.selectedFilter) {
                ForEach(LeaderboardFilter.allCases, id: \.self) { filter in
                    Text(filter.rawValue).tag(filter)
                }
            }
            .pickerStyle(.segmented)
            .padding(.horizontal)
            
            // Header
            VStack(spacing: 8) {
                Image(systemName: "trophy.fill")
                    .font(.system(size: 48))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [.orange, .yellow],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .shadow(color: .orange.opacity(0.3), radius: 8, x: 0, y: 4)
                
                Text("Leaderboard")
                    .font(.system(.title2, design: .rounded))
                    .fontWeight(.bold)
                    .foregroundColor(VintageColors.deepBrown)
                
                Text(leaderboard.selectedFilter.rawValue)
                    .font(.system(.subheadline, design: .rounded))
                    .foregroundColor(VintageColors.warmGray)
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(colorScheme == .dark ? VintageColors.parchment : Color(.systemBackground))
                    .shadow(
                        color: colorScheme == .dark 
                            ? Color.black.opacity(0.3)
                            : Color.black.opacity(0.05),
                        radius: 5,
                        x: 0,
                        y: 2
                    )
            )
            .padding(.horizontal)
            
            // Top 3 Podium
            if leaderboard.entries.count >= 3 {
                PodiumView(entries: Array(leaderboard.entries.prefix(3)))
                    .padding(.horizontal)
            }
            
            // Full Leaderboard
            VStack(alignment: .leading, spacing: 12) {
                Text("All Rankings")
                    .font(.system(.title3, design: .rounded))
                    .fontWeight(.bold)
                    .foregroundColor(VintageColors.deepBrown)
                    .padding(.horizontal)
                
                ForEach(leaderboard.entries) { entry in
                    LeaderboardRowView(entry: entry)
                        .padding(.horizontal)
                }
            }
        }
        .padding(.vertical)
        .onChange(of: leaderboard.selectedFilter) { _, _ in
            leaderboard.update(from: mockFriends, goals: goalStore.goals)
        }
    }
}

