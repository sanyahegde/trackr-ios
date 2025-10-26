import Foundation
import Combine
import SwiftUI

class HomeFeedViewModel: ObservableObject {
    @Published var posts: [Post] = []
    @Published var isLoading = false
    
    private var cancellables = Set<AnyCancellable>()
    
    func loadFeed() {
        isLoading = true
        
        // Try to fetch from API first, fall back to mock data
        Task {
            do {
                let fetchedPosts = try await APIService.shared.fetchPosts()
                await MainActor.run {
                    self.posts = fetchedPosts.isEmpty ? createMockPosts() : fetchedPosts
                    self.isLoading = false
                }
            } catch {
                print("⚠️ API not available, using mock data: \(error)")
                await MainActor.run {
                    self.posts = createMockPosts()
                    self.isLoading = false
                }
            }
        }
    }
    
    private func createMockPosts() -> [Post] {
        return [
            Post(
                userId: UUID(),
                userName: "Alex Chen",
                goalId: UUID(),
                goalTitle: "Run 5K",
                caption: "Just completed my first 5K! The training really paid off. Can't wait for the next milestone!",
                imageURL: nil,
                location: Post.PostLocation(latitude: 37.7749, longitude: -122.4194, cityName: "San Francisco"),
                timestamp: Date().addingTimeInterval(-3600),
                likes: 23,
                isLiked: false,
                comments: [
                    Comment(userId: UUID(), userName: "Sarah", text: "Amazing work! 🎉", likes: 2),
                    Comment(userId: UUID(), userName: "Jordan", text: "Keep it up!", likes: 1)
                ]
            ),
            Post(
                userId: UUID(),
                userName: "Sarah Johnson",
                goalId: UUID(),
                goalTitle: "Learn Spanish",
                caption: "Week 3 update: I've mastered 100 new words! My Duolingo streak is still going strong.",
                timestamp: Date().addingTimeInterval(-7200),
                likes: 18,
                isLiked: false,
                comments: [
                    Comment(userId: UUID(), userName: "Alex", text: "Congrats! 🇪🇸", likes: 3)
                ]
            ),
            Post(
                userId: UUID(),
                userName: "Jordan Miller",
                goalId: UUID(),
                goalTitle: "Save $5000",
                caption: "Hit another milestone! 70% there. The budgeting app has been a game-changer.",
                timestamp: Date().addingTimeInterval(-10800),
                likes: 31,
                isLiked: false,
                comments: []
            )
        ]
    }
    
    func refreshFeed() async {
        isLoading = true
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        loadFeed()
    }
    
    func addPost(_ post: Post) {
        // Animation handled by view
        posts.insert(post, at: 0)
    }
    
    init() {
        loadFeed()
    }
}

