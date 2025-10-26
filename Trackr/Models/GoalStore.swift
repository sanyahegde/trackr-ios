import Foundation
import Combine

class GoalStore: ObservableObject {
    @Published var goals: [Goal] = []
    @Published var currentUser: User
    
    init(currentUser: User) {
        self.currentUser = currentUser
        loadSampleData()
    }
    
    func loadSampleData() {
        // Sample goals for demonstration
        let sampleGoals = [
            Goal(title: "Complete iOS Project", 
                 description: "Finish the trackr iOS app", 
                 targetDate: Date().addingTimeInterval(86400 * 7),
                 progress: 0.6,
                 category: "Work",
                 owner: currentUser,
                 privacyLevel: .public),
            Goal(title: "Go to Gym 3x Week", 
                 description: "Build consistent workout routine", 
                 targetDate: Date().addingTimeInterval(86400 * 30),
                 progress: 0.4,
                 category: "Fitness",
                 owner: currentUser,
                 privacyLevel: .friends),
            Goal(title: "Read 10 Books", 
                 description: "Reading goal for the year", 
                 targetDate: Date().addingTimeInterval(86400 * 180),
                 progress: 0.8,
                 category: "Learning",
                 owner: currentUser,
                 privacyLevel: .private)
        ]
        
        self.goals = sampleGoals
    }
    
    func addGoal(_ goal: Goal) {
        goals.append(goal)
    }
    
    func updateGoal(_ goal: Goal) {
        if let index = goals.firstIndex(where: { $0.id == goal.id }) {
            goals[index] = goal
        }
    }
    
    func deleteGoal(_ goal: Goal) {
        goals.removeAll { $0.id == goal.id }
    }
}

