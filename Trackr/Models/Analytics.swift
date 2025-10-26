import Foundation

struct GoalAnalytics {
    let totalGoals: Int
    let completedGoals: Int
    let inProgressGoals: Int
    let averageProgress: Double
    let goalsByCategory: [String: Int]
    
    var completionRate: Double {
        guard totalGoals > 0 else { return 0 }
        return Double(completedGoals) / Double(totalGoals)
    }
    
    var progressTrend: [Double] = [] // Weekly progress data
}

class AnalyticsViewModel: ObservableObject {
    @Published var analytics: GoalAnalytics
    
    init(goals: [Goal]) {
        self.analytics = GoalAnalytics(
            totalGoals: goals.count,
            completedGoals: goals.filter { $0.isCompleted }.count,
            inProgressGoals: goals.filter { !$0.isCompleted }.count,
            averageProgress: goals.isEmpty ? 0 : goals.map { $0.progress }.reduce(0, +) / Double(goals.count),
            goalsByCategory: Self.calculateGoalsByCategory(goals)
        )
    }
    
    private static func calculateGoalsByCategory(_ goals: [Goal]) -> [String: Int] {
        var dict: [String: Int] = [:]
        for goal in goals {
            dict[goal.category, default: 0] += 1
        }
        return dict
    }
    
    func update(with goals: [Goal]) {
        analytics = GoalAnalytics(
            totalGoals: goals.count,
            completedGoals: goals.filter { $0.isCompleted }.count,
            inProgressGoals: goals.filter { !$0.isCompleted }.count,
            averageProgress: goals.isEmpty ? 0 : goals.map { $0.progress }.reduce(0, +) / Double(goals.count),
            goalsByCategory: Self.calculateGoalsByCategory(goals)
        )
    }
}

