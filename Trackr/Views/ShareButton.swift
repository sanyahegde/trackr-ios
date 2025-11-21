import SwiftUI

struct ShareButton: View {
    let post: Post
    @State private var showingShareSheet = false
    @State private var showingFriendPicker = false
    @StateObject private var friendshipService = FriendshipService.shared
    
    var body: some View {
        Button(action: {
            HapticManager.shared.impact(.light)
            showingFriendPicker = true
        }) {
            Image(systemName: "paperplane")
                .font(.system(size: 24))
                .foregroundColor(.primary)
        }
        .sheet(isPresented: $showingFriendPicker) {
            ShareToFriendsView(post: post)
        }
    }
}

struct ShareToFriendsView: View {
    let post: Post
    @Environment(\.dismiss) var dismiss
    @StateObject private var friendshipService = FriendshipService.shared
    @StateObject private var notificationService = NotificationService.shared
    @StateObject private var sharedPostsViewModel = SharedPostsViewModel.shared
    @State private var selectedFriends: Set<UUID> = []
    @State private var isSharing = false
    
    var mutualFriends: [User] {
        friendshipService.getMutualFriendsAsUsers()
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(.systemGroupedBackground)
                    .ignoresSafeArea()
                
                if mutualFriends.isEmpty {
                    VStack(spacing: 16) {
                        Image(systemName: "person.2.slash")
                            .font(.system(size: 60))
                            .foregroundColor(.secondary)
                        
                        Text("No Mutual Friends")
                            .font(.system(.title2, design: .rounded))
                            .fontWeight(.semibold)
                        
                        Text("You need to be mutual friends with someone to share with them.")
                            .font(.system(.body, design: .rounded))
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                    }
                } else {
                    List {
                        Section {
                            ForEach(mutualFriends) { friend in
                                FriendSelectionRow(
                                    friend: friend,
                                    isSelected: selectedFriends.contains(friend.id)
                                ) {
                                    if selectedFriends.contains(friend.id) {
                                        selectedFriends.remove(friend.id)
                                    } else {
                                        selectedFriends.insert(friend.id)
                                    }
                                }
                            }
                        } header: {
                            Text("Share with Mutual Friends")
                        } footer: {
                            Text("Only mutual friends (people you follow who also follow you) can see shared posts.")
                        }
                    }
                }
            }
            .navigationTitle("Share Post")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: sharePost) {
                        if isSharing {
                            ProgressView()
                        } else {
                            Text("Share")
                                .fontWeight(.semibold)
                        }
                    }
                    .disabled(selectedFriends.isEmpty || isSharing)
                }
            }
        }
    }
    
    private func sharePost() {
        guard !selectedFriends.isEmpty else { return }
        
        isSharing = true
        HapticManager.shared.impact(.medium)
        
        // Share with selected friends and create notifications
        let currentUser = User(
            id: UUID(uuidString: "00000000-0000-0000-0000-000000000001") ?? UUID(),
            name: "You",
            username: "you"
        )
        
        // Create notifications and shared posts for each friend
        for friendId in selectedFriends {
            if let friend = mutualFriends.first(where: { $0.id == friendId }) {
                // Create notification for the friend
                notificationService.createShareNotification(from: currentUser, post: post)
                
                // Create shared post entry
                let sharedPost = SharedPost(
                    originalPost: post,
                    sharedBy: currentUser,
                    message: nil
                )
                sharedPostsViewModel.addSharedPost(sharedPost)
            }
        }
        
        // Simulate sharing
        Task {
            try? await Task.sleep(nanoseconds: 500_000_000) // 0.5 seconds
            
            await MainActor.run {
                HapticManager.shared.notification(.success)
                isSharing = false
                dismiss()
            }
        }
    }
}

struct FriendSelectionRow: View {
    let friend: User
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: colorsForName(friend.name),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 50, height: 50)
                    .overlay(
                        Text(friend.name.prefix(1))
                            .font(.system(.title3, design: .rounded))
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                    )
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(friend.name)
                        .font(.system(.body, design: .rounded))
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)
                    
                    Text("@\(friend.username)")
                        .font(.system(.caption, design: .rounded))
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                    .font(.system(size: 24))
                    .foregroundColor(isSelected ? .blue : .gray)
            }
            .padding(.vertical, 4)
        }
        .buttonStyle(.plain)
    }
    
    func colorsForName(_ name: String) -> [Color] {
        let colors: [[Color]] = [
            [.blue, .purple],
            [.pink, .red],
            [.orange, .yellow],
            [.green, .mint],
            [.purple, .blue],
            [.indigo, .purple]
        ]
        return colors[abs(name.hashValue) % colors.count]
    }
}

