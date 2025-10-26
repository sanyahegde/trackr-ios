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
        withAnimation(.spring()) {
            selectedFilter = filter
        }
        HapticManager.shared.selection()
    }
}

