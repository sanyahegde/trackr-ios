import Foundation
import Combine

class HomeViewModel: ObservableObject {
    @Published var posts: [FeedPost] = []
    
    func loadFeed() {
        // Mock data for demonstration
        let mockUsers = [
            User(name: "Alex", username: "alex"),
            User(name: "Sarah", username: "sarah"),
            User(name: "Jordan", username: "jordan")
        ]
        
        let mockGoals = [
            Goal(title: "Run 5K", description: "Training for marathon", targetDate: Date(), progress: 1.0, category: "Fitness", owner: mockUsers[1], privacyLevel: .public),
            Goal(title: "Learn Swift", description: "iOS development", targetDate: Date(), progress: 0.6, category: "Learning", owner: mockUsers[0], privacyLevel: .public),
            Goal(title: "Read 10 Books", description: "Reading challenge", targetDate: Date(), progress: 0.8, category: "Personal", owner: mockUsers[2], privacyLevel: .public)
        ]
        
        self.posts = [
            FeedPost(user: mockUsers[1], goal: mockGoals[0], activityType: .completed),
            FeedPost(user: mockUsers[0], goal: mockGoals[1], activityType: .updated),
            FeedPost(user: mockUsers[2], goal: mockGoals[2], activityType: .updated)
        ]
    }
    
    @MainActor
    func refreshFeed() async {
        // Simulate network call
        try? await Task.sleep(nanoseconds: 500_000_000)
        loadFeed()
    }
    
    init() {
        loadFeed()
    }
}

