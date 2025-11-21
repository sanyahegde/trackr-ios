import Foundation

class FriendshipService: ObservableObject {
    static let shared = FriendshipService()
    
    @Published var friendships: [Friendship] = []
    @Published var currentUserId: UUID?
    
    private init() {
        loadMockFriendships()
    }
    
    // MARK: - Mock Data
    
    private func loadMockFriendships() {
        // Mock current user
        let currentUser = UUID(uuidString: "00000000-0000-0000-0000-000000000001") ?? UUID()
        currentUserId = currentUser
        
        // Mock friends
        let friend1 = UUID(uuidString: "00000000-0000-0000-0000-000000000002") ?? UUID()
        let friend2 = UUID(uuidString: "00000000-0000-0000-0000-000000000003") ?? UUID()
        let friend3 = UUID(uuidString: "00000000-0000-0000-0000-000000000004") ?? UUID()
        
        // Create mutual friendships (both follow each other)
        friendships = [
            // Current user follows friend1, friend1 follows back (mutual)
            Friendship(followerId: currentUser, followeeId: friend1, isMutual: true),
            Friendship(followerId: friend1, followeeId: currentUser, isMutual: true),
            
            // Current user follows friend2, friend2 follows back (mutual)
            Friendship(followerId: currentUser, followeeId: friend2, isMutual: true),
            Friendship(followerId: friend2, followeeId: currentUser, isMutual: true),
            
            // Current user follows friend3, but friend3 doesn't follow back (not mutual)
            Friendship(followerId: currentUser, followeeId: friend3, isMutual: false),
        ]
    }
    
    // MARK: - Public Methods
    
    func getMutualFriends(for userId: UUID? = nil) -> [UUID] {
        let targetUserId = userId ?? currentUserId ?? UUID()
        return friendships.mutualFriends(for: targetUserId)
    }
    
    func getMutualFriendsAsUsers(for userId: UUID? = nil) -> [User] {
        let mutualFriendIds = getMutualFriends(for: userId)
        
        // Convert to User objects (mock data)
        return mutualFriendIds.map { id in
            let names = ["Alex Chen", "Sam Rodriguez", "Jordan Taylor", "Casey Kim", "Morgan Lee"]
            let usernames = ["alexchen", "samrod", "jordant", "caseyk", "morganl"]
            
            let index = Int(id.uuidString.prefix(8).suffix(1).hexDigitValue ?? 0) % names.count
            return User(
                id: id,
                name: names[index],
                username: usernames[index]
            )
        }
    }
    
    func isMutualFriend(_ userId: UUID) -> Bool {
        guard let currentUserId = currentUserId else { return false }
        let mutualFriends = getMutualFriends(for: currentUserId)
        return mutualFriends.contains(userId)
    }
    
    func follow(_ userId: UUID) {
        guard let currentUserId = currentUserId else { return }
        
        // Check if already following
        if !friendships.contains(where: { $0.followerId == currentUserId && $0.followeeId == userId }) {
            let newFriendship = Friendship(followerId: currentUserId, followeeId: userId)
            friendships.append(newFriendship)
            
            // Check if mutual (they follow us back)
            if friendships.contains(where: { $0.followerId == userId && $0.followeeId == currentUserId }) {
                // Update both to be mutual
                if let index = friendships.firstIndex(where: { $0.followerId == currentUserId && $0.followeeId == userId }) {
                    friendships[index].isMutual = true
                }
                if let index = friendships.firstIndex(where: { $0.followerId == userId && $0.followeeId == currentUserId }) {
                    friendships[index].isMutual = true
                }
            }
        }
    }
    
    func unfollow(_ userId: UUID) {
        guard let currentUserId = currentUserId else { return }
        friendships.removeAll { $0.followerId == currentUserId && $0.followeeId == userId }
    }
}

extension String {
    func hexDigitValue() -> Int? {
        return Int(self, radix: 16)
    }
}

