import SwiftUI

struct MessagesView: View {
    @StateObject private var notificationService = NotificationService.shared
    @State private var selectedNotification: Notification?
    
    var unreadBadge: Int? {
        notificationService.unreadCount > 0 ? notificationService.unreadCount : nil
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(.systemGroupedBackground)
                    .ignoresSafeArea()
                
                if notificationService.notifications.isEmpty {
                    EmptyNotificationsView()
                } else {
                    List {
                        ForEach(notificationService.notifications) { notification in
                            NotificationRow(notification: notification)
                                .contentShape(Rectangle())
                                .onTapGesture {
                                    handleNotificationTap(notification)
                                }
                        }
                        .onDelete(perform: deleteNotifications)
                    }
                    .listStyle(.insetGrouped)
                }
            }
            .navigationTitle("Messages")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    if notificationService.unreadCount > 0 {
                        Button("Mark All Read") {
                            notificationService.markAllAsRead()
                        }
                    }
                }
            }
        }
    }
    
    private func handleNotificationTap(_ notification: Notification) {
        notificationService.markAsRead(notification.id)
        
        // Handle different notification types
        switch notification.type {
        case .share:
            // Navigate to shared posts
            selectedNotification = notification
        case .like, .comment:
            // Navigate to post
            selectedNotification = notification
        case .follow:
            // Navigate to user profile
            selectedNotification = notification
        case .goalCompleted:
            // Navigate to goal
            selectedNotification = notification
        }
    }
    
    private func deleteNotifications(at offsets: IndexSet) {
        for index in offsets {
            let notification = notificationService.notifications[index]
            notificationService.deleteNotification(notification.id)
        }
    }
}

struct NotificationRow: View {
    let notification: Notification
    
    var body: some View {
        HStack(spacing: 12) {
            // Icon
            ZStack {
                Circle()
                    .fill(iconColor.opacity(0.2))
                    .frame(width: 50, height: 50)
                
                Image(systemName: iconName)
                    .font(.system(size: 20))
                    .foregroundColor(iconColor)
            }
            
            // Content
            VStack(alignment: .leading, spacing: 4) {
                Text(notification.message)
                    .font(.system(.body, design: .rounded))
                    .fontWeight(notification.isRead ? .regular : .semibold)
                    .foregroundColor(.primary)
                
                Text(notification.timestamp, style: .relative)
                    .font(.system(.caption, design: .rounded))
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            if !notification.isRead {
                Circle()
                    .fill(Color.blue)
                    .frame(width: 8, height: 8)
            }
        }
        .padding(.vertical, 4)
    }
    
    private var iconName: String {
        switch notification.type {
        case .share:
            return "paperplane.fill"
        case .like:
            return "heart.fill"
        case .comment:
            return "bubble.right.fill"
        case .follow:
            return "person.badge.plus"
        case .goalCompleted:
            return "checkmark.circle.fill"
        }
    }
    
    private var iconColor: Color {
        switch notification.type {
        case .share:
            return .blue
        case .like:
            return .red
        case .comment:
            return .blue
        case .follow:
            return .green
        case .goalCompleted:
            return .orange
        }
    }
}

struct EmptyNotificationsView: View {
    var body: some View {
        VStack(spacing: 24) {
            Image(systemName: "bell.slash")
                .font(.system(size: 60))
                .foregroundStyle(
                    LinearGradient(
                        colors: [.gray, .gray.opacity(0.5)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
            
            VStack(spacing: 8) {
                Text("No Messages")
                    .font(.system(.title2, design: .rounded))
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                
                Text("Notifications and messages will appear here")
                    .font(.system(.body, design: .rounded))
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }
        }
    }
}

