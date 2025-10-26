import SwiftUI
import Charts

struct ProfileView: View {
    @EnvironmentObject var goalStore: GoalStore
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Profile Header
                    ProfileHeaderView()
                    
                    // Stats Grid
                    StatsGridView(goalStore: goalStore)
                    
                    // Streak Section
                    StreakView()
                    
                    // Recent Achievements
                    AchievementsView()
                    
                    // Settings
                    SettingsView()
                }
                .padding()
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Profile")
            .navigationBarTitleDisplayMode(.large)
        }
    }
}

struct ProfileHeaderView: View {
    var body: some View {
        VStack(spacing: 16) {
            // Avatar
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [Color.blue, Color.purple],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 100, height: 100)
                
                Image(systemName: "person.fill")
                    .font(.system(size: 50))
                    .foregroundColor(.white)
            }
            
            VStack(spacing: 4) {
                Text("Welcome Back!")
                    .font(.system(.title2, design: .rounded))
                    .fontWeight(.bold)
                
                Text("@username")
                    .font(.system(.body, design: .rounded))
                    .foregroundColor(.secondary)
            }
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color(.systemBackground))
        )
    }
}

struct StatsGridView: View {
    @ObservedObject var goalStore: GoalStore
    
    var completedGoals: Int {
        goalStore.goals.filter { $0.isCompleted }.count
    }
    
    var inProgressGoals: Int {
        goalStore.goals.filter { !$0.isCompleted }.count
    }
    
    var averageProgress: Double {
        guard !goalStore.goals.isEmpty else { return 0 }
        return goalStore.goals.map { $0.progress }.reduce(0, +) / Double(goalStore.goals.count)
    }
    
    var body: some View {
        LazyVGrid(columns: [
            GridItem(.flexible(), spacing: 12),
            GridItem(.flexible(), spacing: 12)
        ], spacing: 12) {
            ProfileStatCard(
                icon: "checkmark.circle.fill",
                label: "Completed",
                value: "\(completedGoals)",
                color: .green
            )
            
            ProfileStatCard(
                icon: "target",
                label: "In Progress",
                value: "\(inProgressGoals)",
                color: .orange
            )
            
            ProfileStatCard(
                icon: "chart.bar.fill",
                label: "Avg Progress",
                value: "\(Int(averageProgress * 100))%",
                color: .blue
            )
            
            ProfileStatCard(
                icon: "flame.fill",
                label: "Streak",
                value: "7 days",
                color: .red
            )
        }
    }
}

struct ProfileStatCard: View {
    let icon: String
    let label: String
    let value: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 32))
                .foregroundColor(color)
            
            Text(value)
                .font(.system(.title2, design: .rounded))
                .fontWeight(.bold)
                .foregroundColor(.primary)
            
            Text(label)
                .font(.system(.caption, design: .rounded))
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color(.systemBackground))
                .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
        )
    }
}

struct StreakView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Image(systemName: "flame.fill")
                    .font(.system(size: 24))
                    .foregroundColor(.orange)
                
                Text("Your Streak")
                    .font(.system(.title3, design: .rounded))
                    .fontWeight(.bold)
            }
            
            HStack(spacing: 20) {
                ForEach(0..<7) { day in
                    VStack(spacing: 4) {
                        Circle()
                            .fill(Color.orange)
                            .frame(width: 40, height: 40)
                            .overlay(
                                Image(systemName: "checkmark")
                                    .foregroundColor(.white)
                                    .font(.caption)
                            )
                        
                        Text(["M", "T", "W", "T", "F", "S", "S"][day])
                            .font(.system(.caption2, design: .rounded))
                            .foregroundColor(.secondary)
                    }
                }
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color(.systemBackground))
                .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
        )
    }
}

struct AchievementsView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Image(systemName: "star.fill")
                    .font(.system(size: 24))
                    .foregroundColor(.yellow)
                
                Text("Recent Achievements")
                    .font(.system(.title3, design: .rounded))
                    .fontWeight(.bold)
            }
            
            VStack(spacing: 12) {
                AchievementRow(
                    icon: "target",
                    title: "Goal Master",
                    description: "Completed 10 goals",
                    color: .blue
                )
                
                AchievementRow(
                    icon: "calendar",
                    title: "Consistency",
                    description: "7 day streak",
                    color: .orange
                )
                
                AchievementRow(
                    icon: "chart.line.uptrend.xyaxis",
                    title: "Making Progress",
                    description: "Average 80% completion",
                    color: .green
                )
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color(.systemBackground))
                .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
        )
    }
}

struct AchievementRow: View {
    let icon: String
    let title: String
    let description: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(color.opacity(0.2))
                    .frame(width: 50, height: 50)
                
                Image(systemName: icon)
                    .foregroundColor(color)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.system(.body, design: .rounded))
                    .fontWeight(.semibold)
                
                Text(description)
                    .font(.system(.caption, design: .rounded))
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Image(systemName: "checkmark.circle.fill")
                .foregroundColor(color)
        }
    }
}

struct SettingsView: View {
    @State private var notifications = true
    @State private var darkMode = false
    @State private var showAbout = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Settings")
                .font(.system(.title3, design: .rounded))
                .fontWeight(.bold)
            
            VStack(spacing: 12) {
                SettingsRow(
                    icon: "bell.fill",
                    title: "Notifications",
                    isToggle: true,
                    value: $notifications,
                    color: .blue
                )
                
                SettingsRow(
                    icon: "moon.fill",
                    title: "Dark Mode",
                    isToggle: true,
                    value: $darkMode,
                    color: .purple
                )
                
                SettingsRow(
                    icon: "info.circle.fill",
                    title: "About Trackr",
                    isToggle: false,
                    action: { showAbout = true },
                    color: .gray
                )
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color(.systemBackground))
                .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
        )
        .sheet(isPresented: $showAbout) {
            AboutView()
        }
    }
}

struct SettingsRow: View {
    let icon: String
    let title: String
    let isToggle: Bool
    var value: Binding<Bool>? = nil
    var action: (() -> Void)? = nil
    let color: Color
    
    var body: some View {
        Button(action: {
            if !isToggle {
                action?()
            }
        }) {
            HStack {
                ZStack {
                    Circle()
                        .fill(color.opacity(0.15))
                        .frame(width: 40, height: 40)
                    
                    Image(systemName: icon)
                        .foregroundColor(color)
                        .font(.system(size: 18))
                }
                
                Text(title)
                    .font(.system(.body, design: .rounded))
                    .foregroundColor(.primary)
                
                Spacer()
                
                if isToggle, let binding = value {
                    Toggle("", isOn: binding)
                        .labelsHidden()
                } else {
                    Image(systemName: "chevron.right")
                        .foregroundColor(.secondary)
                        .font(.caption)
                }
            }
        }
        .buttonStyle(.plain)
    }
}

struct AboutView: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            VStack(spacing: 24) {
                Image(systemName: "target")
                    .font(.system(size: 80))
                    .foregroundColor(.blue)
                
                Text("Trackr")
                    .font(.system(.largeTitle, design: .rounded))
                    .fontWeight(.bold)
                
                Text("Version 1.0.0")
                    .font(.system(.body, design: .rounded))
                    .foregroundColor(.secondary)
                
                Text("Track your goals and achieve great things with friends.")
                    .font(.system(.body, design: .rounded))
                    .multilineTextAlignment(.center)
                    .foregroundColor(.secondary)
                    .padding()
                
                Spacer()
            }
            .padding()
            .navigationTitle("About")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}

