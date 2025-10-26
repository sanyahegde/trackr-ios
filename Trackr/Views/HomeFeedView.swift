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
                                FeedPostCardView(post: post)
                                    .transition(.move(edge: .top).combined(with: .opacity))
                            }
                        }
                        .padding(.horizontal)
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

// FeedPostCard replaced by FeedPostCardView.swift

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

