import Foundation
import Combine

class NotificationService: ObservableObject {
    static let shared = NotificationService()
    
    @Published var notifications: [Notification] = []
    @Published var unreadCount: Int = 0
    
    private init() {
        loadMockNotifications()
    }
    
    func loadMockNotifications() {
        // Mock notifications
        notifications = []
        updateUnreadCount()
    }
    
    func addNotification(_ notification: Notification) {
        notifications.insert(notification, at: 0)
        updateUnreadCount()
    }
    
    func markAsRead(_ notificationId: UUID) {
        if let index = notifications.firstIndex(where: { $0.id == notificationId }) {
            notifications[index].isRead = true
            updateUnreadCount()
        }
    }
    
    func markAllAsRead() {
        for index in notifications.indices {
            notifications[index].isRead = true
        }
        updateUnreadCount()
    }
    
    func deleteNotification(_ notificationId: UUID) {
        notifications.removeAll { $0.id == notificationId }
        updateUnreadCount()
    }
    
    private func updateUnreadCount() {
        unreadCount = notifications.filter { !$0.isRead }.count
    }
    
    // Create a share notification
    func createShareNotification(from user: User, post: Post) {
        let notification = Notification(
            type: .share,
            fromUserId: user.id,
            fromUserName: user.name,
            postId: post.id,
            message: "\(user.name) shared a post with you"
        )
        addNotification(notification)
    }
}

