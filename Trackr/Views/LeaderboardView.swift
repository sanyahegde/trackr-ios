import SwiftUI

struct LeaderboardView: View {
    @ObservedObject var goalStore: GoalStore
    @StateObject private var leaderboard = LeaderboardViewModel()
    
    var mockFriends: [User] = [
        User(name: "Alex Chen", username: "alexchen"),
        User(name: "Sam Rodriguez", username: "samrod"),
        User(name: "Jordan Taylor", username: "jordant")
    ]
    
    var body: some View {
        ZStack {
            VintageColors.cream
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Filter Picker
                Picker("Filter", selection: $leaderboard.selectedFilter) {
                    ForEach(LeaderboardFilter.allCases, id: \.self) { filter in
                        Text(filter.rawValue).tag(filter)
                    }
                }
                .pickerStyle(.segmented)
                .padding()
                
                ScrollView {
                    VStack(spacing: 20) {
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
                            
                            Text(leaderboard.selectedFilter.rawValue)
                                .font(.system(.subheadline, design: .rounded))
                                .foregroundColor(.secondary)
                        }
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Color(.systemBackground))
                                .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
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
                                .padding(.horizontal)
                            
                            ForEach(leaderboard.entries) { entry in
                                LeaderboardRowView(entry: entry)
                                    .padding(.horizontal)
                            }
                        }
                    }
                    .padding()
                }
            }
        }
        .onAppear {
            leaderboard.update(from: mockFriends, goals: goalStore.goals)
        }
        .onChange(of: leaderboard.selectedFilter) { _, _ in
            leaderboard.update(from: mockFriends, goals: goalStore.goals)
        }
        .navigationTitle("Leaderboard")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct PodiumView: View {
    let entries: [LeaderboardEntry]
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        HStack(alignment: .bottom, spacing: 12) {
            // 2nd Place
            if entries.count > 1 {
                VStack(spacing: 8) {
                    Image(systemName: "medal.fill")
                        .font(.system(size: 32))
                        .foregroundColor(VintageColors.warmGray)
                    
                    ZStack {
                        RoundedRectangle(cornerRadius: 8)
                            .fill(
                                LinearGradient(
                                    colors: [VintageColors.sepia.opacity(0.3), VintageColors.warmGray.opacity(0.2)],
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                            )
                            .frame(height: CGFloat(80 + entries[1].totalProgress * 40))
                        
                        VStack {
                            Text("2")
                                .font(.system(size: 24, design: .rounded))
                                .fontWeight(.bold)
                                .foregroundColor(VintageColors.deepBrown)
                            
                            Spacer()
                            
                            Text(entries[1].user.name)
                                .font(.system(size: 12, design: .rounded))
                                .fontWeight(.semibold)
                                .foregroundColor(VintageColors.deepBrown)
                                .multilineTextAlignment(.center)
                        }
                        .padding(8)
                    }
                }
            }
            
            // 1st Place
            VStack(spacing: 8) {
                Image(systemName: "crown.fill")
                    .font(.system(size: 40))
                    .foregroundColor(VintageColors.burntOrange)
                    .shadow(color: VintageColors.burntOrange.opacity(0.5), radius: 4, x: 0, y: 2)
                
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(
                            LinearGradient(
                                colors: [VintageColors.burntOrange.opacity(0.4), VintageColors.burntOrange.opacity(0.2)],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                        .frame(height: CGFloat(100 + entries[0].totalProgress * 40))
                    
                    VStack {
                        Text("1")
                            .font(.system(size: 28, design: .rounded))
                            .fontWeight(.bold)
                            .foregroundColor(VintageColors.deepBrown)
                        
                        Spacer()
                        
                        Text(entries[0].user.name)
                            .font(.system(size: 12, design: .rounded))
                            .fontWeight(.semibold)
                            .foregroundColor(VintageColors.deepBrown)
                            .multilineTextAlignment(.center)
                    }
                    .padding(8)
                }
            }
            
            // 3rd Place
            if entries.count > 2 {
                VStack(spacing: 8) {
                    Image(systemName: "medal.fill")
                        .font(.system(size: 32))
                        .foregroundColor(VintageColors.sageGreen.opacity(0.6))
                    
                    ZStack {
                        RoundedRectangle(cornerRadius: 8)
                            .fill(
                                LinearGradient(
                                    colors: [VintageColors.sageGreen.opacity(0.3), VintageColors.sageGreen.opacity(0.1)],
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                            )
                            .frame(height: CGFloat(60 + entries[2].totalProgress * 40))
                        
                        VStack {
                            Text("3")
                                .font(.system(size: 24, design: .rounded))
                                .fontWeight(.bold)
                                .foregroundColor(VintageColors.deepBrown)
                            
                            Spacer()
                            
                            Text(entries[2].user.name)
                                .font(.system(size: 12, design: .rounded))
                                .fontWeight(.semibold)
                                .foregroundColor(VintageColors.deepBrown)
                                .multilineTextAlignment(.center)
                        }
                        .padding(8)
                    }
                }
            }
        }
        .padding()
        .vintageCard()
    }
}

struct LeaderboardRowView: View {
    let entry: LeaderboardEntry
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        HStack(spacing: 16) {
            // Rank
            ZStack {
                Circle()
                    .fill(VintageColors.sepia.opacity(colorScheme == .dark ? 0.3 : 0.2))
                    .frame(width: 40, height: 40)
                
                Text("\(entry.rank)")
                    .font(.system(size: 18, design: .rounded))
                    .fontWeight(.bold)
                    .foregroundColor(VintageColors.deepBrown)
            }
            
            // User Info
            VStack(alignment: .leading, spacing: 4) {
                Text(entry.user.name)
                    .font(.system(size: 16, design: .rounded))
                    .fontWeight(.semibold)
                    .foregroundColor(VintageColors.deepBrown)
                
                Text("@\(entry.user.username)")
                    .font(.system(size: 12, design: .rounded))
                    .foregroundColor(VintageColors.warmGray)
            }
            
            Spacer()
            
            // Stats
            VStack(alignment: .trailing, spacing: 4) {
                HStack(spacing: 4) {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.caption)
                        .foregroundColor(VintageColors.forestGreen)
                    Text("\(entry.completedGoals)")
                        .font(.system(size: 14, design: .rounded))
                        .fontWeight(.semibold)
                        .foregroundColor(VintageColors.deepBrown)
                }
                
                Text("\(Int(entry.totalProgress * 100))% progress")
                    .font(.system(size: 11, design: .rounded))
                    .foregroundColor(VintageColors.warmGray)
            }
        }
        .padding()
        .vintageCard()
    }
}

