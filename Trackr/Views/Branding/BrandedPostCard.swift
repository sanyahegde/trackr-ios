import SwiftUI

// MARK: - Branded Post Card (Instagram-style, warm and friendly)
struct BrandedPostCard: View {
    let post: Post
    @State private var isLiked: Bool
    @State private var likeCount: Int
    @State private var showComments = false
    @State private var comments: [Comment]
    @State private var commentText = ""
    @State private var isPostingComment = false
    let viewModel: HomeFeedViewModel?
    
    init(post: Post, viewModel: HomeFeedViewModel? = nil) {
        self.post = post
        self.viewModel = viewModel
        _isLiked = State(initialValue: post.isLiked)
        _likeCount = State(initialValue: post.likes)
        _comments = State(initialValue: post.comments)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Header
            HStack(spacing: AppSpacing.sm) {
                AppAvatar(name: post.userName, size: 40, gradient: gradientForName(post.userName))
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(post.userName)
                        .font(AppTypography.subheadline(weight: .semibold))
                        .foregroundColor(AppColors.textPrimary)
                    
                    if let goalTitle = post.goalTitle {
                        Text("📌 \(goalTitle)")
                            .font(AppTypography.caption())
                            .foregroundColor(AppColors.textSecondary)
                    }
                    
                    Text(post.timestamp, style: .relative)
                        .font(AppTypography.caption())
                        .foregroundColor(AppColors.textTertiary)
                }
                
                Spacer()
            }
            .padding(.horizontal, AppSpacing.md)
            .padding(.vertical, AppSpacing.sm)
            
            // Image (if available)
            if let imageURL = post.imageURL, !imageURL.isEmpty {
                AsyncImage(url: URL(string: imageURL)) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } placeholder: {
                    Rectangle()
                        .fill(AppColors.gradientWarm)
                        .aspectRatio(1.0, contentMode: .fit)
                }
                .frame(maxWidth: .infinity)
                .clipped()
            }
            
            // Actions Bar
            HStack(spacing: AppSpacing.md) {
                Button(action: toggleLike) {
                    Image(systemName: isLiked ? "heart.fill" : "heart")
                        .font(.system(size: 26))
                        .foregroundStyle(isLiked ? AppColors.error : AppColors.textPrimary)
                        .symbolEffect(.bounce, value: isLiked)
                }
                .buttonStyle(.plain)
                
                Button(action: { showComments.toggle() }) {
                    Image(systemName: "bubble.right")
                        .font(.system(size: 26))
                        .foregroundColor(AppColors.textPrimary)
                }
                .buttonStyle(.plain)
                
                ShareButton(post: post)
                    .buttonStyle(.plain)
                
                Spacer()
            }
            .padding(.horizontal, AppSpacing.md)
            .padding(.vertical, AppSpacing.sm)
            
            // Like Count
            if likeCount > 0 {
                Text("\(likeCount) \(likeCount == 1 ? "like" : "likes")")
                    .font(AppTypography.subheadline(weight: .semibold))
                    .foregroundColor(AppColors.textPrimary)
                    .padding(.horizontal, AppSpacing.md)
                    .padding(.bottom, AppSpacing.xs)
            }
            
            // Caption
            HStack(alignment: .top, spacing: AppSpacing.xs) {
                Text(post.userName)
                    .font(AppTypography.subheadline(weight: .semibold))
                    .foregroundColor(AppColors.textPrimary)
                
                Text(post.caption)
                    .font(AppTypography.subheadline())
                    .foregroundColor(AppColors.textPrimary)
                
                Spacer()
            }
            .padding(.horizontal, AppSpacing.md)
            .padding(.bottom, AppSpacing.sm)
            
            // Comments Section
            if showComments {
                VStack(alignment: .leading, spacing: AppSpacing.sm) {
                    if !comments.isEmpty {
                        ForEach(comments) { comment in
                            BrandedCommentView(comment: comment)
                        }
                    }
                    
                    // Add Comment Field
                    HStack(spacing: AppSpacing.sm) {
                        AppAvatar(name: "You", size: 28, gradient: AppColors.gradientPrimary)
                        
                        HStack(spacing: AppSpacing.xs) {
                            TextField("Add a comment...", text: $commentText, axis: .vertical)
                                .textFieldStyle(.plain)
                                .font(AppTypography.subheadline())
                                .lineLimit(1...4)
                            
                            if !commentText.isEmpty {
                                Button(action: postComment) {
                                    if isPostingComment {
                                        ProgressView()
                                            .progressViewStyle(.circular)
                                            .scaleEffect(0.8)
                                            .tint(AppColors.primaryCoral)
                                    } else {
                                        Text("Post")
                                            .font(AppTypography.subheadline(weight: .semibold))
                                            .foregroundColor(AppColors.primaryCoral)
                                    }
                                }
                                .disabled(isPostingComment || commentText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                            }
                        }
                        .padding(.horizontal, AppSpacing.sm)
                        .padding(.vertical, AppSpacing.xs)
                        .background(AppColors.background)
                        .cornerRadius(AppShapes.smallCornerRadius)
                    }
                }
                .padding(.horizontal, AppSpacing.md)
                .padding(.bottom, AppSpacing.sm)
            }
        }
        .appCard(padding: 0)
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
    
    func postComment() {
        guard !commentText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
        guard !isPostingComment else { return }
        
        isPostingComment = true
        HapticManager.shared.impact(.light)
        
        let currentUserId = UUID(uuidString: "00000000-0000-0000-0000-000000000001") ?? UUID()
        let newComment = Comment(
            userId: currentUserId,
            userName: "You",
            text: commentText.trimmingCharacters(in: .whitespacesAndNewlines),
            timestamp: Date(),
            likes: 0
        )
        
        withAnimation(.spring(response: 0.3)) {
            comments.append(newComment)
            commentText = ""
        }
        
        if !showComments {
            showComments = true
        }
        
        if let viewModel = viewModel {
            viewModel.addComment(newComment, to: post.id)
        }
        
        isPostingComment = false
        HapticManager.shared.notification(.success)
    }
    
    func gradientForName(_ name: String) -> LinearGradient {
        let gradients: [LinearGradient] = [
            AppColors.gradientPrimary,
            AppColors.gradientSecondary,
            AppColors.gradientWarm,
            AppColors.gradientCool
        ]
        return gradients[abs(name.hashValue) % gradients.count]
    }
}

struct BrandedCommentView: View {
    let comment: Comment
    
    var body: some View {
        HStack(alignment: .top, spacing: AppSpacing.xs) {
            AppAvatar(name: comment.userName, size: 24, gradient: gradientForName(comment.userName))
            
            VStack(alignment: .leading, spacing: 2) {
                HStack(spacing: AppSpacing.xs) {
                    Text(comment.userName)
                        .font(AppTypography.subheadline(weight: .semibold))
                        .foregroundColor(AppColors.textPrimary)
                    
                    Text(comment.text)
                        .font(AppTypography.subheadline())
                        .foregroundColor(AppColors.textPrimary)
                }
                
                Text(comment.timestamp, style: .relative)
                    .font(AppTypography.caption())
                    .foregroundColor(AppColors.textTertiary)
            }
            
            Spacer()
        }
    }
    
    func gradientForName(_ name: String) -> LinearGradient {
        let gradients: [LinearGradient] = [
            AppColors.gradientPrimary,
            AppColors.gradientSecondary,
            AppColors.gradientWarm,
            AppColors.gradientCool
        ]
        return gradients[abs(name.hashValue) % gradients.count]
    }
}

