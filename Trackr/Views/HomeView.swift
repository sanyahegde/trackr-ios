import SwiftUI

struct HomeView: View {
    var body: some View {
        HomeFeedView()
    }
}

struct HomeFeedView: View {
    @StateObject private var viewModel = HomeFeedViewModel()
    @State private var showingCreatePost = false
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(.systemGroupedBackground)
                    .ignoresSafeArea()
                
                if viewModel.posts.isEmpty {
                    EmptyFeedView()
                } else {
                    List {
                        ForEach(viewModel.posts) { post in
                            FeedPostView(post: post)
                                .listRowInsets(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
                                .listRowBackground(Color.clear)
                        }
                    }
                    .listStyle(.plain)
                    .refreshable {
                        await viewModel.refreshFeed()
                    }
                }
            }
            .navigationTitle("Home")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingNewGoal = true }) {
                        Image(systemName: "plus.circle.fill")
                            .font(.title3)
                            .foregroundColor(.blue)
                    }
                }
            }
            .sheet(isPresented: $showingNewGoal) {
                CreatePostView()
            }
        }
    }
}

struct FeedPostView: View {
    let post: FeedPost
    @State private var likes = 0
    @State private var fires = 0
    @State private var claps = 0
    @State private var isAnimating = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Header
            HStack(spacing: 12) {
                // Profile image
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [Color.blue, Color.purple],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 50, height: 50)
                    .overlay(
                        Image(systemName: "person.fill")
                            .foregroundColor(.white)
                            .font(.title3)
                    )
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(post.user.name)
                        .font(.system(.headline, design: .rounded))
                        .fontWeight(.semibold)
                    
                    Text(post.timestamp, style: .relative)
                        .font(.system(.caption, design: .rounded))
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                // Category tag
                Text(post.goal.category)
                    .font(.system(.caption2, design: .rounded))
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(
                        Capsule()
                            .fill(colorForCategory(post.goal.category))
                    )
            }
            
            // Activity text
            HStack {
                Text(post.activityText)
                    .font(.system(.body, design: .rounded))
                    .foregroundColor(.primary)
                Spacer()
            }
            
            // Progress bar
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text(post.goal.title)
                        .font(.system(.subheadline, design: .rounded))
                        .fontWeight(.semibold)
                    
                    Spacer()
                    
                    Text("\(Int(post.goal.progress * 100))%")
                        .font(.system(.caption, design: .rounded))
                        .foregroundColor(.secondary)
                }
                
                GeometryReader { geometry in
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 6)
                            .fill(Color.gray.opacity(0.2))
                            .frame(height: 8)
                        
                        RoundedRectangle(cornerRadius: 6)
                            .fill(
                                LinearGradient(
                                    colors: [colorForCategory(post.goal.category), colorForCategory(post.goal.category).opacity(0.6)],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .frame(width: geometry.size.width * CGFloat(post.goal.progress), height: 8)
                            .animation(.spring(response: 0.6), value: post.goal.progress)
                    }
                }
                .frame(height: 8)
            }
            
            // Reactions
            HStack(spacing: 20) {
                ReactionButton(emoji: "❤️", count: $likes)
                ReactionButton(emoji: "🔥", count: $fires)
                ReactionButton(emoji: "👏", count: $claps)
                
                Spacer()
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color(.systemBackground))
                .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 5)
        )
        .onAppear {
            // Load saved reaction counts
            likes = post.reactions["❤️"] ?? 0
            fires = post.reactions["🔥"] ?? 0
            claps = post.reactions["👏"] ?? 0
        }
    }
    
    func colorForCategory(_ category: String) -> Color {
        switch category {
        case "Work": return .orange
        case "Fitness": return .green
        case "Learning": return .blue
        case "Personal": return .red
        case "Finance": return .purple
        default: return .gray
        }
    }
}

struct ReactionButton: View {
    let emoji: String
    @Binding var count: Int
    @State private var isAnimating = false
    
    var body: some View {
        Button(action: {
            count += 1
            HapticManager.shared.impact(.light)
            
            withAnimation(.spring(response: 0.3, dampingFraction: 0.5)) {
                isAnimating = true
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                isAnimating = false
            }
        }) {
            HStack(spacing: 6) {
                Text(emoji)
                    .font(.system(size: 20))
                
                Text("\(count)")
                    .font(.system(.caption, design: .rounded))
                    .foregroundColor(.secondary)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(.systemGray6))
            )
            .scaleEffect(isAnimating ? 1.2 : 1.0)
        }
        .buttonStyle(.plain)
    }
}

struct EmptyFeedView: View {
    var body: some View {
        VStack(spacing: 24) {
            Image(systemName: "sparkles")
                .font(.system(size: 60))
                .foregroundColor(.blue.opacity(0.5))
            
            VStack(spacing: 8) {
                Text("Welcome to Trackr!")
                    .font(.system(.title2, design: .rounded))
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                
                Text("Your feed will show updates from your friends and shared goals.")
                    .font(.system(.body, design: .rounded))
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }
        }
    }
}

struct CreatePostView: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Create a new post")
                    .font(.system(.title3, design: .rounded))
                    .fontWeight(.semibold)
                    .padding()
                
                Spacer()
                
                Button("Done") {
                    dismiss()
                }
            }
            .navigationTitle("New Post")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
}

