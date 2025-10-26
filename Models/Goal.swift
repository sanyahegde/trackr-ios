import Foundation

struct Goal: Identifiable, Codable, Hashable {
    var id: UUID
    var title: String
    var description: String
    var targetDate: Date
    var isCompleted: Bool
    var progress: Double
    var category: String
    var owner: User
    
    init(id: UUID = UUID(), title: String, description: String, targetDate: Date, isCompleted: Bool = false, progress: Double = 0.0, category: String = "General", owner: User) {
        self.id = id
        self.title = title
        self.description = description
        self.targetDate = targetDate
        self.isCompleted = isCompleted
        self.progress = progress
        self.category = category
        self.owner = owner
    }
    
    static func == (lhs: Goal, rhs: Goal) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

