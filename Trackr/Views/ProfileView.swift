import SwiftUI
import Charts

struct ProfileView: View {
    @EnvironmentObject var goalStore: GoalStore
    @State private var showingSettings = false
    @State private var isPublicView = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 0) {
                    // Gradient Header with Avatar
                    ProfileHeaderGradientView(isPublicView: $isPublicView)
                    
                    VStack(spacing: 20) {
                        // Stats Grid
                        StatsGridView(goalStore: goalStore)
                            .padding(.top, 20)
                        
                        // Streak Section
                        StreakView()
                        
                        // Recent Achievements
                        AchievementsView()
                        
                        // Profile Settings Card
                        ProfileSettingsCard(showingSettings: $showingSettings)
                    }
                    .padding()
                }
            }
            .background(Color(.systemGroupedBackground))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingSettings = true }) {
                        Image(systemName: "gearshape.fill")
                            .foregroundColor(.blue)
                    }
                }
            }
            .sheet(isPresented: $showingSettings) {
                MainSettingsView()
            }
        }
    }
}

struct ProfileHeaderGradientView: View {
    @Binding var isPublicView: Bool
    @State private var followers = 1680
    @State private var following = 1822
    @State private var isFollowing = false
    
    var body: some View {
        VStack(spacing: 0) {
            // Header Stats
            HStack(spacing: 0) {
                // Profile picture with gradient border
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [.blue, .purple, .pink],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 90, height: 90)
                        .overlay(
                            Circle()
                                .fill(Color(.systemBackground))
                                .frame(width: 85, height: 85)
                                .overlay(
                                    Circle()
                                        .fill(
                                            LinearGradient(
                                                colors: colorsForName("You"),
                                                startPoint: .topLeading,
                                                endPoint: .bottomTrailing
                                            )
                                        )
                                .frame(width: 80, height: 80)
                                .overlay(
                                    Text("You".prefix(1))
                                        .font(.system(size: 35, design: .rounded))
                                        .fontWeight(.bold)
                                        .foregroundColor(.white)
                                )
                                )
                        )
                }
                .padding(.leading, 16)
                
                // Follower counts
                HStack(spacing: 28) {
                    VStack(spacing: 4) {
                        Text("\(followers)")
                            .font(.system(.title3, design: .rounded))
                            .fontWeight(.bold)
                            .foregroundColor(.primary)
                        Text("Followers")
                            .font(.system(.caption, design: .rounded))
                            .foregroundColor(.secondary)
                    }
                    
                    VStack(spacing: 4) {
                        Text("\(following)")
                            .font(.system(.title3, design: .rounded))
                            .fontWeight(.bold)
                            .foregroundColor(.primary)
                        Text("Following")
                            .font(.system(.caption, design: .rounded))
                            .foregroundColor(.secondary)
                    }
                    
                    VStack(spacing: 4) {
                        Text("12")
                            .font(.system(.title3, design: .rounded))
                            .fontWeight(.bold)
                            .foregroundColor(.primary)
                        Text("Goals")
                            .font(.system(.caption, design: .rounded))
                            .foregroundColor(.secondary)
                    }
                }
                .frame(maxWidth: .infinity)
            }
            .padding(.vertical, 16)
            
            // Username and bio
            VStack(alignment: .leading, spacing: 8) {
                Text("Your Username")
                    .font(.system(.body, design: .rounded))
                    .fontWeight(.semibold)
                
                Text("Chasing consistency ✨")
                    .font(.system(.body, design: .rounded))
                    .foregroundColor(.secondary)
                
                // Action buttons
                HStack(spacing: 8) {
                    Button(action: {
                        withAnimation(.spring(response: 0.3)) {
                            isPublicView.toggle()
                            HapticManager.shared.selection()
                        }
                    }) {
                        HStack {
                            Image(systemName: isPublicView ? "globe" : "lock.fill")
                            Text(isPublicView ? "Public" : "Private")
                                .font(.system(.subheadline, design: .rounded))
                                .fontWeight(.semibold)
                        }
                        .foregroundColor(.primary)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color(.systemGray5))
                        )
                    }
                    
                    Button(action: {
                        withAnimation(.spring(response: 0.3)) {
                            // Add share profile action
                        }
                    }) {
                        HStack {
                            Image(systemName: "square.and.arrow.up")
                            Text("Share")
                                .font(.system(.subheadline, design: .rounded))
                                .fontWeight(.semibold)
                        }
                        .foregroundColor(.primary)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color(.systemGray5))
                        )
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 12)
        }
        .background(Color(.systemBackground))
    }
    
    func colorsForName(_ name: String) -> [Color] {
        let colors: [[Color]] = [
            [.blue, .purple],
            [.pink, .red],
            [.orange, .yellow],
            [.green, .mint],
            [.purple, .blue],
            [.indigo, .purple]
        ]
        return colors[abs(name.hashValue) % colors.count]
    }
}

struct ProfileSettingsCard: View {
    @Binding var showingSettings: Bool
    @AppStorage("preferredColorScheme") private var preferredColorScheme = 0
    
    private var darkModeBinding: Binding<Bool> {
        Binding(
            get: { preferredColorScheme == 2 },
            set: { newValue in
                preferredColorScheme = newValue ? 2 : 1
            }
        )
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Profile Settings")
                    .font(.system(.title3, design: .rounded))
                    .fontWeight(.bold)
                
                Spacer()
            }
            
            VStack(spacing: 12) {
                SettingsRow(
                    icon: "lock.fill",
                    title: "Privacy Settings",
                    isToggle: false,
                    action: { showingSettings = true },
                    color: .blue
                )
                
                SettingsRow(
                    icon: "moon.fill",
                    title: "Dark Mode",
                    isToggle: true,
                    value: darkModeBinding,
                    color: .purple
                )
                
                SettingsRow(
                    icon: "bell.fill",
                    title: "Notifications",
                    isToggle: true,
                    value: .constant(true),
                    color: .orange
                )
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color(.systemBackground))
                .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
        )
    }
}

struct SettingsDetailView: View {
    @Environment(\.dismiss) var dismiss
    @AppStorage("preferredColorScheme") private var preferredColorScheme = 0
    @State private var notifications = true
    
    private var darkModeBinding: Binding<Bool> {
        Binding(
            get: { preferredColorScheme == 2 },
            set: { newValue in
                preferredColorScheme = newValue ? 2 : 1
            }
        )
    }
    
    var body: some View {
        NavigationView {
            List {
                Section("Appearance") {
                    Toggle("Dark Mode", isOn: darkModeBinding)
                    
                    Picker("Color Scheme", selection: $preferredColorScheme) {
                        Text("Auto").tag(0)
                        Text("Light").tag(1)
                        Text("Dark").tag(2)
                    }
                }
                
                Section("Privacy") {
                    Toggle("Show Profile", isOn: .constant(true))
                    Toggle("Show Goals", isOn: .constant(false))
                    Toggle("Show Stats", isOn: .constant(true))
                }
                
                Section("Notifications") {
                    Toggle("Goal Reminders", isOn: $notifications)
                    Toggle("Friend Updates", isOn: .constant(true))
                    Toggle("Achievements", isOn: .constant(true))
                }
                
                Section("About") {
                    HStack {
                        Text("Version")
                        Spacer()
                        Text("1.0.0")
                            .foregroundColor(.secondary)
                    }
                    
                    Button("Rate on App Store") {
                        // Rate action
                    }
                    
                    Button("Contact Support") {
                        // Contact action
                    }
                }
            }
            .navigationTitle("Settings")
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


