import Foundation

enum LeaderboardFilter: String, CaseIterable {
    case friends = "Friends"
    case global = "Global"
    case weekly = "Weekly"
}

class LeaderboardViewModel: ObservableObject {
    @Published var selectedFilter: LeaderboardFilter = .friends
    @Published var entries: [LeaderboardEntry] = []
    
    func updateFilter(_ filter: LeaderboardFilter) {
        selectedFilter = filter
        HapticManager.shared.selection()
    }
    
    func update(from friends: [User], goals: [Goal]) {
        let entries = friends.map { friend in
            let userGoals = goals.filter { $0.owner.id == friend.id }
            let completed = userGoals.filter { $0.isCompleted }.count
            let totalProgress = userGoals.map { $0.progress }.reduce(0, +)
            
            return LeaderboardEntry(
                id: UUID(),
                user: friend,
                completedGoals: completed,
                totalProgress: totalProgress,
                rank: 0
            )
        }.sorted(by: { $0.totalProgress > $1.totalProgress })
        
        self.entries = entries.enumerated().map { index, entry in
            LeaderboardEntry(
                id: entry.id,
                user: entry.user,
                completedGoals: entry.completedGoals,
                totalProgress: entry.totalProgress,
                rank: index + 1
            )
        }
    }
}

