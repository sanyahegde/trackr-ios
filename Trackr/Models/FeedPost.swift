import Foundation

struct FeedPost: Identifiable {
    let id: UUID
    let user: User
    let goal: Goal
    let activityType: ActivityType
    let timestamp: Date
    let reactions: [String: Int]
    
    enum ActivityType {
        case created
        case updated
        case completed
        case shared
    }
    
    var activityText: String {
        let goalTitle = goal.title
        switch activityType {
        case .created:
            return "is working on \(goalTitle)"
        case .updated:
            let progress = Int(goal.progress * 100)
            return "made progress on \(goalTitle) — \(progress)%"
        case .completed:
            return "completed \(goalTitle) 🎉"
        case .shared:
            return "shared \(goalTitle)"
        }
    }
    
    init(id: UUID = UUID(), user: User, goal: Goal, activityType: ActivityType, timestamp: Date = Date(), reactions: [String: Int] = [:]) {
        self.id = id
        self.user = user
        self.goal = goal
        self.activityType = activityType
        self.timestamp = timestamp
        self.reactions = reactions
    }
}

