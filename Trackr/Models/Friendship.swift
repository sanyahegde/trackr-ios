import Foundation

struct Friendship: Identifiable, Codable, Hashable {
    let id: UUID
    let followerId: UUID
    let followeeId: UUID
    let createdAt: Date
    var isMutual: Bool = false // Both users follow each other
    
    init(id: UUID = UUID(), followerId: UUID, followeeId: UUID, createdAt: Date = Date(), isMutual: Bool = false) {
        self.id = id
        self.followerId = followerId
        self.followeeId = followeeId
        self.createdAt = createdAt
        self.isMutual = isMutual
    }
    
    static func == (lhs: Friendship, rhs: Friendship) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

// Helper to find mutual friends
extension Array where Element == Friendship {
    func mutualFriends(for userId: UUID) -> [UUID] {
        // Get all users that userId follows
        let following = self.filter { $0.followerId == userId }.map { $0.followeeId }
        
        // Get all users that follow userId
        let followers = self.filter { $0.followeeId == userId }.map { $0.followerId }
        
        // Return intersection (mutual friends)
        let followingSet = Set(following)
        let followersSet = Set(followers)
        let intersection = followingSet.intersection(followersSet)
        return [UUID](intersection)
    }
}

