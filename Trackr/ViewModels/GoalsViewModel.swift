import Foundation

class GoalsViewModel: ObservableObject {
    @Published var goals: [Goal] = []
    @Published var expandedGoalId: UUID? = nil
    
    func loadGoals(from store: GoalStore) {
        self.goals = store.goals
    }
    
    func toggleExpanded(goalId: UUID) {
        withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
            if expandedGoalId == goalId {
                expandedGoalId = nil
            } else {
                expandedGoalId = goalId
            }
        }
    }
}

