import Foundation

struct LeaderboardEntry: Identifiable {
    let id: UUID
    let user: User
    let completedGoals: Int
    let totalProgress: Double
    let rank: Int
    
    var completionPercentage: Double {
        guard completedGoals > 0 else { return 0 }
        return min(totalProgress / Double(completedGoals), 1.0)
    }
}

class LeaderboardViewModel: ObservableObject {
    @Published var entries: [LeaderboardEntry] = []
    
    func update(from friends: [User], goals: [Goal]) {
        let entries = friends.map { friend in
            let userGoals = goals.filter { $0.owner.id == friend.id }
            let completed = userGoals.filter { $0.isCompleted }.count
            let totalProgress = userGoals.map { $0.progress }.reduce(0, +)
            
            return LeaderboardEntry(
                user: friend,
                completedGoals: completed,
                totalProgress: totalProgress,
                rank: 0 // Will be calculated later
            )
        }.sorted { $0.totalProgress > $1.totalProgress }
        
        // Assign ranks
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

