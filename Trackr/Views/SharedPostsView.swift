import SwiftUI

struct SharedPostsView: View {
    @StateObject private var viewModel = SharedPostsViewModel.shared
    @StateObject private var notificationService = NotificationService.shared
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(.systemGroupedBackground)
                    .ignoresSafeArea()
                
                if viewModel.isLoading && viewModel.sharedPosts.isEmpty {
                    ProgressView()
                        .scaleEffect(1.5)
                } else if viewModel.sharedPosts.isEmpty {
                    EmptySharedPostsView()
                } else {
                    ScrollView {
                        LazyVStack(spacing: 20) {
                            ForEach(viewModel.sharedPosts) { sharedPost in
                                SharedPostCard(sharedPost: sharedPost)
                                    .transition(.move(edge: .top).combined(with: .opacity))
                            }
                        }
                        .padding()
                    }
                }
            }
            .navigationTitle("Shared with You")
            .navigationBarTitleDisplayMode(.large)
            .refreshable {
                await viewModel.loadSharedPosts()
            }
        }
    }
}

struct SharedPostCard: View {
    let sharedPost: SharedPost
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Shared by header
            HStack(spacing: 8) {
                Image(systemName: "paperplane.fill")
                    .font(.caption)
                    .foregroundColor(.blue)
                
                Text("Shared by \(sharedPost.sharedBy.name)")
                    .font(.system(.caption, design: .rounded))
                    .foregroundColor(.secondary)
                
                Spacer()
                
                Text(sharedPost.sharedAt, style: .relative)
                    .font(.system(.caption2, design: .rounded))
                    .foregroundColor(.secondary)
            }
            .padding(.horizontal, 16)
            .padding(.top, 12)
            
            // Optional message
            if let message = sharedPost.message {
                Text(message)
                    .font(.system(.subheadline, design: .rounded))
                    .foregroundColor(.primary)
                    .padding(.horizontal, 16)
            }
            
            // Original post
            FeedPostCardView(post: sharedPost.originalPost)
        }
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
}

struct EmptySharedPostsView: View {
    var body: some View {
        VStack(spacing: 24) {
            Image(systemName: "paperplane")
                .font(.system(size: 60))
                .foregroundStyle(
                    LinearGradient(
                        colors: [.blue, .purple],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
            
            VStack(spacing: 8) {
                Text("No Shared Posts")
                    .font(.system(.title2, design: .rounded))
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                
                Text("Posts shared with you by your friends will appear here")
                    .font(.system(.body, design: .rounded))
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }
        }
    }
}

