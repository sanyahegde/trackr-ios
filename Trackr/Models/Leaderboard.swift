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

// LeaderboardViewModel moved to ViewModels/LeaderboardViewModel.swift

