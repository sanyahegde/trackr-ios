import SwiftUI
import PhotosUI
import MapKit
import CoreLocation

struct HomeFeedView: View {
    @StateObject private var viewModel = HomeFeedViewModel()
    @State private var showingCreatePost = false
    @State private var selectedImage: UIImage?
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(.systemGroupedBackground)
                    .ignoresSafeArea()
                
                if viewModel.isLoading && viewModel.posts.isEmpty {
                    ProgressView()
                        .scaleEffect(1.5)
                } else if viewModel.posts.isEmpty {
                    EmptyFeedView()
                } else {
                    ScrollView {
                        LazyVStack(spacing: 20) {
                            ForEach(viewModel.posts) { post in
                                FeedPostCard(post: post)
                                    .transition(.move(edge: .top).combined(with: .opacity))
                            }
                        }
                        .padding()
                    }
                    .refreshable {
                        await viewModel.refreshFeed()
                    }
                }
            }
            .navigationTitle("Home")
            .navigationBarTitleDisplayMode(.large)
            .sheet(isPresented: $showingCreatePost) {
                CreatePostView(viewModel: viewModel)
            }
        }
    }
}

struct FeedPostCard: View {
    let post: Post
    @State private var likeCount: Int
    @State private var clapCount: Int
    @State private var fireCount: Int
    @State private var hasLiked = false
    @State private var hasClapped = false
    @State private var hasFired = false
    
    init(post: Post) {
        self.post = post
        _likeCount = State(initialValue: post.likes)
        _clapCount = State(initialValue: post.claps)
        _fireCount = State(initialValue: post.fires)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Header
            HStack(spacing: 12) {
                // Profile image with gradient
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
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(post.userName)
                        .font(.system(.headline, design: .rounded))
                        .fontWeight(.semibold)
                    
                    HStack(spacing: 4) {
                        Text(post.timestamp, style: .relative)
                        if let location = post.location {
                            Text("• \(location.cityName)")
                        }
                        if let goalTitle = post.goalTitle {
                            Text("• \(goalTitle)")
                                .foregroundColor(.blue)
                        }
                    }
                    .font(.system(.caption, design: .rounded))
                    .foregroundColor(.secondary)
                }
                
                Spacer()
            }
            
            // Caption
            Text(post.caption)
                .font(.system(.body, design: .rounded))
                .foregroundColor(.primary)
            
            // Image placeholder (will be PhotosPicker later)
            if post.imageURL != nil {
                RoundedRectangle(cornerRadius: 16)
                    .fill(
                        LinearGradient(
                            colors: [Color.blue.opacity(0.3), Color.purple.opacity(0.3)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(height: 200)
                    .overlay(
                        Image(systemName: "photo.fill")
                            .font(.system(size: 50))
                            .foregroundColor(.white.opacity(0.8))
                    )
            }
            
            // Location preview (if available)
            if let location = post.location {
                LocationPreviewView(location: location)
            }
            
            // Reactions bar
            HStack(spacing: 20) {
                ReactionButton(
                    icon: "❤️",
                    count: $likeCount,
                    isActive: $hasLiked,
                    color: .red
                )
                
                ReactionButton(
                    icon: "👏",
                    count: $clapCount,
                    isActive: $hasClapped,
                    color: .blue
                )
                
                ReactionButton(
                    icon: "🔥",
                    count: $fireCount,
                    isActive: $hasFired,
                    color: .orange
                )
                
                Spacer()
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color(.systemBackground))
                .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 5)
        )
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

struct ReactionButton: View {
    let icon: String
    @Binding var count: Int
    @Binding var isActive: Bool
    let color: Color
    @State private var isAnimating = false
    
    var body: some View {
        Button(action: {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.5)) {
                isAnimating = true
            }
            
            if isActive {
                count -= 1
            } else {
                count += 1
            }
            isActive.toggle()
            HapticManager.shared.impact(.light)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                isAnimating = false
            }
        }) {
            HStack(spacing: 6) {
                Text(icon)
                    .font(.system(size: 20))
                
                Text("\(count)")
                    .font(.system(.subheadline, design: .rounded))
                    .foregroundColor(.secondary)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(isActive ? color.opacity(0.15) : Color(.systemGray6))
            )
            .scaleEffect(isAnimating ? 1.3 : 1.0)
        }
        .buttonStyle(.plain)
    }
}

struct LocationPreviewView: View {
    let location: Post.PostLocation
    @State private var region: MKCoordinateRegion
    
    init(location: Post.PostLocation) {
        self.location = location
        _region = State(initialValue: MKCoordinateRegion(
            center: location.coordinate,
            span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        ))
    }
    
    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: "mappin.circle.fill")
                .foregroundColor(.red)
            
            Text(location.cityName)
                .font(.system(.caption, design: .rounded))
                .foregroundColor(.secondary)
        }
        .padding(.vertical, 4)
    }
}

struct EmptyFeedView: View {
    var body: some View {
        VStack(spacing: 24) {
            Image(systemName: "sparkles")
                .font(.system(size: 60))
                .foregroundStyle(
                    LinearGradient(
                        colors: [.blue, .purple],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
            
            VStack(spacing: 8) {
                Text("Welcome to Trackr!")
                    .font(.system(.title2, design: .rounded))
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                
                Text("Start by sharing your goals and cheering on your friends!")
                    .font(.system(.body, design: .rounded))
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }
        }
    }
}

