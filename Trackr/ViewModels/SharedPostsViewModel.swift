import Foundation
import Combine

class SharedPostsViewModel: ObservableObject {
    static let shared = SharedPostsViewModel()
    
    @Published var sharedPosts: [SharedPost] = []
    @Published var isLoading = false
    
    private var cancellables = Set<AnyCancellable>()
    
    private init() {
        loadSharedPosts()
    }
    
    func loadSharedPosts() {
        isLoading = true
        
        // In real app, fetch from API
        // For now, use mock data
        Task {
            try? await Task.sleep(nanoseconds: 500_000_000)
            
            await MainActor.run {
                // Mock shared posts
                sharedPosts = createMockSharedPosts()
                isLoading = false
            }
        }
    }
    
    private func createMockSharedPosts() -> [SharedPost] {
        // Return empty for now - will be populated when posts are shared
        return []
    }
    
    func addSharedPost(_ sharedPost: SharedPost) {
        sharedPosts.insert(sharedPost, at: 0)
    }
}

