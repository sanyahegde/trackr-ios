import Foundation

struct Notification: Identifiable, Codable {
    let id: UUID
    let type: NotificationType
    let fromUserId: UUID
    let fromUserName: String
    let postId: UUID?
    let goalId: UUID?
    let message: String
    let timestamp: Date
    var isRead: Bool
    
    enum NotificationType: String, Codable {
        case share = "share"
        case like = "like"
        case comment = "comment"
        case follow = "follow"
        case goalCompleted = "goal_completed"
    }
    
    init(id: UUID = UUID(), type: NotificationType, fromUserId: UUID, fromUserName: String, postId: UUID? = nil, goalId: UUID? = nil, message: String, timestamp: Date = Date(), isRead: Bool = false) {
        self.id = id
        self.type = type
        self.fromUserId = fromUserId
        self.fromUserName = fromUserName
        self.postId = postId
        self.goalId = goalId
        self.message = message
        self.timestamp = timestamp
        self.isRead = isRead
    }
}

