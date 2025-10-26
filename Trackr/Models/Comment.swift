import Foundation

struct Comment: Identifiable {
    let id: UUID
    let userId: UUID
    let userName: String
    let text: String
    let timestamp: Date
    let likes: Int
    
    init(id: UUID = UUID(), userId: UUID, userName: String, text: String, timestamp: Date = Date(), likes: Int = 0) {
        self.id = id
        self.userId = userId
        self.userName = userName
        self.text = text
        self.timestamp = timestamp
        self.likes = likes
    }
}

