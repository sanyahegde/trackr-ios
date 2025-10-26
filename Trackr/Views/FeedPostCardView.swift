import SwiftUI

struct FeedPostCardView: View {
    let post: Post
    @State private var isLiked: Bool
    @State private var likeCount: Int
    @State private var showComments = false
    @State private var comments: [Comment]
    @State private var showingUserProfile = false
    
    init(post: Post) {
        self.post = post
        _isLiked = State(initialValue: post.isLiked)
        _likeCount = State(initialValue: post.likes)
        _comments = State(initialValue: post.comments)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Location at top (if available)
            if let location = post.location {
                HStack {
                    Image(systemName: "mappin.circle.fill")
                        .foregroundColor(.red)
                        .font(.caption)
                    
                    Text(location.cityName)
                        .font(.system(.caption, design: .rounded))
                        .foregroundColor(.secondary)
                }
                .padding(.horizontal, 16)
                .padding(.top, 16)
                .padding(.bottom, 8)
            }
            
            // Header with clickable profile
            HStack(spacing: 12) {
                Button(action: { showingUserProfile = true }) {
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: colorsForName(post.userName),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 50, height: 50)
                        .overlay(
                            Text(post.userName.prefix(1))
                                .font(.system(.title3, design: .rounded))
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                        )
                }
                .buttonStyle(.plain)
                
                VStack(alignment: .leading, spacing: 4) {
                    Button(action: { showingUserProfile = true }) {
                        Text(post.userName)
                            .font(.system(.headline, design: .rounded))
                            .fontWeight(.semibold)
                            .foregroundColor(.primary)
                    }
                    .buttonStyle(.plain)
                    
                    HStack(spacing: 4) {
                        if let goalTitle = post.goalTitle {
                            Text(goalTitle)
                                .font(.system(.caption, design: .rounded))
                                .foregroundColor(.blue)
                            
                            Text("•")
                        }
                        
                        Text(post.timestamp, style: .relative)
                            .font(.system(.caption, design: .rounded))
                            .foregroundColor(.secondary)
                    }
                }
                
                Spacer()
            }
            .padding(.horizontal, 16)
            .padding(.top, 8)
            .padding(.bottom, 12)
            
            // Caption
            Text(post.caption)
                .font(.system(.body, design: .rounded))
                .foregroundColor(.primary)
                .padding(.horizontal, 16)
                .padding(.bottom, 12)
            
            // Image placeholder
            if post.imageURL != nil {
                RoundedRectangle(cornerRadius: 0)
                    .fill(
                        LinearGradient(
                            colors: [Color.blue.opacity(0.3), Color.purple.opacity(0.3)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(height: 300)
                    .overlay(
                        Image(systemName: "photo.fill")
                            .font(.system(size: 50))
                            .foregroundColor(.white.opacity(0.8))
                    )
            }
            
            // Actions (Instagram-style)
            HStack(spacing: 20) {
                Button(action: toggleLike) {
                    Image(systemName: isLiked ? "heart.fill" : "heart")
                        .font(.system(size: 24))
                        .foregroundColor(isLiked ? .red : .primary)
                        .symbolEffect(.bounce, value: isLiked)
                }
                .buttonStyle(.plain)
                
                Button(action: { showComments.toggle() }) {
                    Image(systemName: "bubble.right")
                        .font(.system(size: 24))
                        .foregroundColor(.primary)
                }
                .buttonStyle(.plain)
                
                Button(action: {}) {
                    Image(systemName: "paperplane")
                        .font(.system(size: 24))
                        .foregroundColor(.primary)
                }
                .buttonStyle(.plain)
                
                Spacer()
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            
            // Like count
            if likeCount > 0 {
                Text("\(likeCount) \(likeCount == 1 ? "like" : "likes")")
                    .font(.system(.subheadline, design: .rounded))
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                    .padding(.horizontal, 16)
                    .padding(.bottom, 8)
            }
            
            // Show comments if toggled
            if showComments {
                VStack(alignment: .leading, spacing: 8) {
                    ForEach(comments) { comment in
                        CommentView(comment: comment)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 12)
            }
            
            // Add comment field
            HStack(spacing: 12) {
                Circle()
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: 32, height: 32)
                
                Text("Add a comment...")
                    .font(.system(.body, design: .rounded))
                    .foregroundColor(.secondary)
                
                Spacer()
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 12)
        }
        .background(Color(.systemBackground))
        .cornerRadius(0)
        .sheet(isPresented: $showingUserProfile) {
            UserProfileView(userName: post.userName, userId: post.userId)
        }
    }
    
    func toggleLike() {
        withAnimation(.spring(response: 0.3)) {
            if isLiked {
                likeCount -= 1
            } else {
                likeCount += 1
            }
            isLiked.toggle()
        }
        HapticManager.shared.impact(.light)
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

struct CommentView: View {
    let comment: Comment
    
    var body: some View {
        HStack(alignment: .top, spacing: 8) {
            Text(comment.userName)
                .font(.system(.subheadline, design: .rounded))
                .fontWeight(.semibold)
            
            Text(comment.text)
                .font(.system(.subheadline, design: .rounded))
            
            Spacer()
            
            if comment.likes > 0 {
                HStack(spacing: 4) {
                    Image(systemName: "heart.fill")
                        .font(.caption2)
                        .foregroundColor(.red)
                    Text("\(comment.likes)")
                        .font(.system(.caption2, design: .rounded))
                        .foregroundColor(.secondary)
                }
            }
        }
    }
}

struct UserProfileView: View {
    let userName: String
    let userId: UUID
    @Environment(\.dismiss) var dismiss
    
    // Mock user goals
    var publicGoals: [Goal] = []
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Profile Header
                    VStack(spacing: 16) {
                        Circle()
                            .fill(
                                LinearGradient(
                                    colors: colorsForName(userName),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 100, height: 100)
                            .overlay(
                                Text(userName.prefix(1))
                                    .font(.system(size: 50, design: .rounded))
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                            )
                        
                        Text(userName)
                            .font(.system(.title2, design: .rounded))
                            .fontWeight(.bold)
                        
                        Text("@\(userName.lowercased())")
                            .font(.system(.subheadline, design: .rounded))
                            .foregroundColor(.secondary)
                    }
                    .padding(.vertical)
                    
                    // Stats
                    HStack(spacing: 40) {
                        VStack {
                            Text("12")
                                .font(.system(.title3, design: .rounded))
                                .fontWeight(.bold)
                            Text("Public Goals")
                                .font(.system(.caption, design: .rounded))
                                .foregroundColor(.secondary)
                        }
                        
                        VStack {
                            Text("45")
                                .font(.system(.title3, design: .rounded))
                                .fontWeight(.bold)
                            Text("Posts")
                                .font(.system(.caption, design: .rounded))
                                .foregroundColor(.secondary)
                        }
                    }
                    
                    // Public Goals
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Public Goals")
                            .font(.system(.title3, design: .rounded))
                            .fontWeight(.bold)
                            .padding(.horizontal)
                        
                        if publicGoals.isEmpty {
                            Text("No public goals yet")
                                .font(.system(.body, design: .rounded))
                                .foregroundColor(.secondary)
                                .padding()
                        } else {
                            ForEach(publicGoals) { goal in
                                GoalPreviewCard(goal: goal)
                            }
                        }
                    }
                }
            }
            .navigationTitle(userName)
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

