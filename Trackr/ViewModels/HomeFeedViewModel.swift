import Foundation
import Combine
import SwiftUI

class HomeFeedViewModel: ObservableObject {
    @Published var posts: [Post] = []
    @Published var isLoading = false
    
    private var cancellables = Set<AnyCancellable>()
    
    func loadFeed() {
        isLoading = true
        
        // Mock social posts
        let mockPosts = [
            Post(
                userId: UUID(),
                userName: "Alex Chen",
                goalId: UUID(),
                goalTitle: "Run 5K",
                caption: "Just completed my first 5K! 🏃‍♂️ The training really paid off. Can't wait for the next milestone!",
                imageURL: nil,
                location: Post.PostLocation(latitude: 37.7749, longitude: -122.4194, cityName: "San Francisco"),
                timestamp: Date().addingTimeInterval(-3600),
                likes: 23,
                claps: 15,
                fires: 8
            ),
            Post(
                userId: UUID(),
                userName: "Sarah Johnson",
                goalId: UUID(),
                goalTitle: "Learn Spanish",
                caption: "Week 3 update: I've mastered 100 new words! 💪 My Duolingo streak is still going strong.",
                timestamp: Date().addingTimeInterval(-7200),
                likes: 18,
                claps: 12,
                fires: 5
            ),
            Post(
                userId: UUID(),
                userName: "Jordan Miller",
                goalId: UUID(),
                goalTitle: "Save $5000",
                caption: "Hit another milestone! 70% there. The budgeting app has been a game-changer. 💰",
                timestamp: Date().addingTimeInterval(-10800),
                likes: 31,
                claps: 20,
                fires: 14
            )
        ]
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.posts = mockPosts
            self.isLoading = false
        }
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

