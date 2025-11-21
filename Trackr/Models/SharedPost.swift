import Foundation

struct SharedPost: Identifiable {
    let id: UUID
    let originalPost: Post
    let sharedBy: User
    let sharedAt: Date
    let message: String?
    
    init(id: UUID = UUID(), originalPost: Post, sharedBy: User, sharedAt: Date = Date(), message: String? = nil) {
        self.id = id
        self.originalPost = originalPost
        self.sharedBy = sharedBy
        self.sharedAt = sharedAt
        self.message = message
    }
}

