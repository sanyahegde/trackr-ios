import Foundation

struct User: Identifiable, Codable, Hashable {
    var id: UUID
    var name: String
    var username: String
    var avatar: String?
    
    init(id: UUID = UUID(), name: String, username: String, avatar: String? = nil) {
        self.id = id
        self.name = name
        self.username = username
        self.avatar = avatar
    }
    
    static func == (lhs: User, rhs: User) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

