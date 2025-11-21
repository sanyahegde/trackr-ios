import SwiftUI

// MARK: - Branded Home Feed View
struct BrandedHomeView: View {
    @StateObject private var viewModel = HomeFeedViewModel()
    @State private var showingCreatePost = false
    
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
                    EmptyBrandedFeedView()
                } else {
                    ScrollView {
                        LazyVStack(spacing: AppSpacing.lg) {
                            ForEach(viewModel.posts) { post in
                                BrandedPostCard(post: post, viewModel: viewModel)
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
            .navigationTitle("Trackr")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    AppLogo(size: 32)
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingCreatePost = true }) {
                        Image(systemName: "plus.circle.fill")
                            .font(.system(size: 28))
                            .foregroundStyle(AppColors.gradientPrimary)
                    }
                }
            }
            .sheet(isPresented: $showingCreatePost) {
                CreatePostView(viewModel: viewModel)
            }
        }
    }
}

struct EmptyBrandedFeedView: View {
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

