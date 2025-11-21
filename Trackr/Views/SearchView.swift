import SwiftUI

struct SearchView: View {
    @State private var searchText = ""
    @State private var users: [User] = []
    @State private var isLoading = false
    @State private var errorMessage: String?
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Search bar
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.secondary)
                    
                    TextField("Search", text: $searchText)
                        .font(.system(.body, design: .rounded))
                        .onChange(of: searchText) { _, newValue in
                            Task {
                                await performSearch(query: newValue)
                            }
                        }
                }
                .padding(12)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color(.systemGray6))
                )
                .padding(.horizontal)
                .padding(.vertical, 8)
                
                // Results
                ScrollView {
                    if isLoading {
                        ProgressView()
                            .padding()
                    } else if let error = errorMessage {
                        VStack(spacing: 12) {
                            Image(systemName: "exclamationmark.triangle")
                                .font(.largeTitle)
                                .foregroundColor(.orange)
                            Text(error)
                                .font(.system(.body, design: .rounded))
                                .foregroundColor(.secondary)
                        }
                        .padding()
                    } else if users.isEmpty && !searchText.isEmpty {
                        VStack(spacing: 12) {
                            Image(systemName: "magnifyingglass")
                                .font(.largeTitle)
                                .foregroundColor(.secondary)
                            Text("No users found")
                                .font(.system(.body, design: .rounded))
                                .foregroundColor(.secondary)
                        }
                        .padding()
                    } else {
                        LazyVStack(spacing: 0) {
                            ForEach(users) { user in
                                NavigationLink(destination: UserProfileDetailView(user: user)) {
                                    UserResultRow(user: user)
                                }
                                .buttonStyle(.plain)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Search")
            .navigationBarTitleDisplayMode(.inline)
            .background(Color(.systemGroupedBackground))
            .task {
                // Load initial users when view appears
                await performSearch(query: "")
            }
        }
    }
    
    private func performSearch(query: String) async {
        isLoading = true
        errorMessage = nil
        
        do {
            let results = try await APIService.shared.searchUsers(query: query)
            await MainActor.run {
                users = results
                isLoading = false
            }
        } catch {
            await MainActor.run {
                errorMessage = "Failed to search users: \(error.localizedDescription)"
                isLoading = false
            }
        }
    }
}

struct UserResultRow: View {
    let user: User
    @State private var isFollowing = false
    
    var body: some View {
        HStack(spacing: 12) {
            // Profile picture
            Circle()
                .fill(
                    LinearGradient(
                        colors: colorsForUser(user),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: 50, height: 50)
                .overlay(
                    Text(user.name.prefix(1))
                        .font(.system(.title3, design: .rounded))
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                )
            
            VStack(alignment: .leading, spacing: 4) {
                Text(user.name)
                    .font(.system(.body, design: .rounded))
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                
                Text("@\(user.username)")
                    .font(.system(.subheadline, design: .rounded))
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Button(action: {
                withAnimation(.spring(response: 0.3)) {
                    isFollowing.toggle()
                    HapticManager.shared.impact(.light)
                }
            }) {
                Text(isFollowing ? "Following" : "Follow")
                    .font(.system(.subheadline, design: .rounded))
                    .fontWeight(.semibold)
                    .foregroundColor(isFollowing ? .primary : .white)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(isFollowing ? Color(.systemGray5) : Color.blue)
                    )
            }
        }
        .padding()
        .background(Color(.systemBackground))
    }
    
    func colorsForUser(_ user: User) -> [Color] {
        let colors: [[Color]] = [
            [.blue, .purple],
            [.pink, .red],
            [.orange, .yellow],
            [.green, .mint],
            [.purple, .blue]
        ]
        return colors[abs(user.id.hashValue) % colors.count]
    }
}

struct GoalPreviewCard: View {
    let goal: Goal
    
    var body: some View {
        HStack(spacing: 12) {
            RoundedRectangle(cornerRadius: 12)
                .fill(
                    LinearGradient(
                        colors: [VintageColors.colorForCategory(goal.category).opacity(0.7), VintageColors.colorForCategory(goal.category).opacity(0.5)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: 60, height: 60)
                .overlay(
                    Text(goal.category.prefix(1))
                        .font(.system(size: 24, design: .rounded))
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                )
            
            VStack(alignment: .leading, spacing: 4) {
                Text(goal.title)
                    .font(.system(.body, design: .rounded))
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                
                Text(goal.category)
                    .font(.system(.caption, design: .rounded))
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 4) {
                Text("\(Int(goal.progress * 100))%")
                    .font(.system(.subheadline, design: .rounded))
                    .fontWeight(.bold)
                    .foregroundColor(.blue)
                
                ProgressView(value: goal.progress)
                    .tint(.blue)
                    .frame(width: 50)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.systemGray6))
        )
    }
}

struct UserProfileDetailView: View {
    let user: User
    @State private var isFollowing = false
    @State private var followers = 250
    @State private var following = 180
    @State private var posts = 15
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Profile header
                HStack(spacing: 16) {
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: colorsForUser(user),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 90, height: 90)
                        .overlay(
                            Text(user.name.prefix(1))
                                .font(.system(size: 40, design: .rounded))
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                        )
                    
                    HStack(spacing: 20) {
                        VStack(spacing: 4) {
                            Text("\(posts)")
                                .font(.system(.title3, design: .rounded))
                                .fontWeight(.bold)
                            Text("Posts")
                                .font(.system(.caption, design: .rounded))
                                .foregroundColor(.secondary)
                        }
                        
                        VStack(spacing: 4) {
                            Text("\(followers)")
                                .font(.system(.title3, design: .rounded))
                                .fontWeight(.bold)
                            Text("Followers")
                                .font(.system(.caption, design: .rounded))
                                .foregroundColor(.secondary)
                        }
                        
                        VStack(spacing: 4) {
                            Text("\(following)")
                                .font(.system(.title3, design: .rounded))
                                .fontWeight(.bold)
                            Text("Following")
                                .font(.system(.caption, design: .rounded))
                                .foregroundColor(.secondary)
                        }
                    }
                }
                .padding(.horizontal)
                .padding(.top)
                
                // Username and bio
                VStack(alignment: .leading, spacing: 8) {
                    Text(user.name)
                        .font(.system(.body, design: .rounded))
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Text("@\(user.username)")
                        .font(.system(.body, design: .rounded))
                        .foregroundColor(.secondary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    // Only show bio placeholder for current user's profile
                    let currentUserId = UUID(uuidString: "00000000-0000-0000-0000-000000000001") ?? UUID()
                    if user.id == currentUserId {
                        Text("Add bio here")
                            .font(.system(.body, design: .rounded))
                            .foregroundColor(.secondary)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
                .padding(.horizontal)
                
                // Follow button
                Button(action: {
                    withAnimation(.spring(response: 0.3)) {
                        isFollowing.toggle()
                        followers += isFollowing ? 1 : -1
                        HapticManager.shared.impact(.medium)
                    }
                }) {
                    Text(isFollowing ? "Following" : "Follow")
                        .font(.system(.body, design: .rounded))
                        .fontWeight(.semibold)
                        .foregroundColor(isFollowing ? .primary : .white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(isFollowing ? Color(.systemGray5) : Color.blue)
                        )
                }
                .padding(.horizontal)
                
                // Public Goals section
                VStack(alignment: .leading, spacing: 12) {
                    Text("Public Goals")
                        .font(.system(.title3, design: .rounded))
                        .fontWeight(.bold)
                        .padding(.horizontal)
                    
                    if user.username == "alexchen" {
                        VStack(spacing: 8) {
                            GoalPreviewCard(goal: Goal(
                                title: "Run a Marathon",
                                description: "Training for my first marathon",
                                targetDate: Date().addingTimeInterval(86400 * 90),
                                progress: 0.6,
                                category: "Fitness",
                                owner: user,
                                privacyLevel: .public
                            ))
                            GoalPreviewCard(goal: Goal(
                                title: "Read 20 Books",
                                description: "Year-long reading challenge",
                                targetDate: Date().addingTimeInterval(86400 * 180),
                                progress: 0.4,
                                category: "Learning",
                                owner: user,
                                privacyLevel: .public
                            ))
                        }
                    } else {
                        Text("No public goals")
                            .font(.system(.body, design: .rounded))
                            .foregroundColor(.secondary)
                            .padding()
                    }
                }
            }
        }
        .navigationTitle(user.name)
        .navigationBarTitleDisplayMode(.inline)
    }
    
    func colorsForUser(_ user: User) -> [Color] {
        let colors: [[Color]] = [
            [.blue, .purple],
            [.pink, .red],
            [.orange, .yellow],
            [.green, .mint]
        ]
        return colors[abs(user.id.hashValue) % colors.count]
    }
}

