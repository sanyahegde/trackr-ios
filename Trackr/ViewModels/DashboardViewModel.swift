import Foundation

class DashboardViewModel: ObservableObject {
    @Published var showMotivationalBanner = true
    
    func loadDashboardData(from store: GoalStore) {
        // Data loading logic
    }
}

