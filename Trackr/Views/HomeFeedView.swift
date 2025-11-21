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
                AppGradientBackground()
                
                if viewModel.isLoading && viewModel.posts.isEmpty {
                    VStack(spacing: AppSpacing.lg) {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: AppColors.primaryCoral))
                            .scaleEffect(1.2)
                        Text("Loading your feed...")
                            .font(AppTypography.callout())
                            .foregroundColor(AppColors.textSecondary)
                    }
                } else if viewModel.posts.isEmpty {
                    EmptyFeedView()
                } else {
                    ScrollView {
                        LazyVStack(spacing: AppSpacing.lg) {
                            ForEach(viewModel.posts) { post in
                                FeedPostCardView(post: post, viewModel: viewModel)
                                    .transition(.move(edge: .top).combined(with: .opacity))
                            }
                        }
                        .padding(.horizontal, AppSpacing.md)
                        .padding(.vertical, AppSpacing.md)
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
        VStack(spacing: AppSpacing.xl) {
            AppLogo(size: 80)
            
            VStack(spacing: AppSpacing.sm) {
                Text("Welcome to Trackr!")
                    .font(AppTypography.title2(weight: .bold))
                    .foregroundColor(AppColors.textPrimary)
                
                Text("Start sharing your goals and cheering on your friends!")
                    .font(AppTypography.body())
                    .foregroundColor(AppColors.textSecondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, AppSpacing.lg)
            }
        }
    }
}

