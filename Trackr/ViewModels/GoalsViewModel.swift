import Foundation
import SwiftUI

class GoalsViewModel: ObservableObject {
    @Published var goals: [Goal] = []
    @Published var expandedGoalId: UUID? = nil
    
    func loadGoals(from store: GoalStore) {
        self.goals = store.goals
    }
    
    func toggleExpanded(goalId: UUID) {
        // Animation will be handled by the view
        if expandedGoalId == goalId {
            expandedGoalId = nil
        } else {
            expandedGoalId = goalId
        }
    }
}

