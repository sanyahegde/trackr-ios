import SwiftUI
import PhotosUI

struct CreatePostView: View {
    @ObservedObject var viewModel: HomeFeedViewModel
    @Environment(\.dismiss) var dismiss
    
    @State private var caption = ""
    @State private var selectedPhoto: PhotosPickerItem?
    @State private var selectedImage: UIImage?
    @State private var showLocation = false
    @State private var selectedGoal: Goal?
    @State private var isProcessing = false
    
    let availableGoals: [Goal] = [] // Will be passed from parent
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(.systemBackground)
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Instagram-style split view
                    if let image = selectedImage {
                        // Image preview on left
                        GeometryReader { geometry in
                            VStack(spacing: 0) {
                                Image(uiImage: image)
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: geometry.size.width, height: geometry.size.height)
                                    .clipped()
                            }
                        }
                        .frame(height: UIScreen.main.bounds.height * 0.5)
                        
                        Divider()
                    }
                    
                    // Bottom section for controls
                    VStack(spacing: 16) {
                        // Top controls
                        if let image = selectedImage {
                            HStack {
                                // Photo picker
                                PhotosPicker(
                                    selection: $selectedPhoto,
                                    matching: .images
                                ) {
                                    HStack(spacing: 8) {
                                        Image(systemName: "photo")
                                        Text("Change Photo")
                                    }
                                    .font(.system(.body, design: .rounded))
                                }
                                
                                Spacer()
                                
                                Button(action: { 
                                    withAnimation(.spring()) {
                                        selectedImage = nil 
                                    }
                                }) {
                                    Image(systemName: "trash")
                                        .foregroundColor(.red)
                                }
                            }
                            .padding(.horizontal)
                        } else {
                            // Initial photo picker button
                            PhotosPicker(
                                selection: $selectedPhoto,
                                matching: .images
                            ) {
                                VStack(spacing: 12) {
                                    Image(systemName: "photo.on.rectangle")
                                        .font(.system(size: 60))
                                        .foregroundColor(.blue)
                                    
                                    Text("Choose Photo")
                                        .font(.system(.title3, design: .rounded))
                                        .fontWeight(.semibold)
                                    
                                    Text("Share a moment from your goal journey")
                                        .font(.system(.subheadline, design: .rounded))
                                        .foregroundColor(.secondary)
                                        .multilineTextAlignment(.center)
                                }
                                .frame(maxWidth: .infinity)
                                .padding(40)
                                .background(Color(.systemGray6))
                                .cornerRadius(20)
                            }
                            .padding()
                        }
                        
                        ScrollView {
                            VStack(spacing: 16) {
                                // Caption input
                                VStack(alignment: .leading, spacing: 8) {
                                    HStack {
                                        Image(systemName: "text.bubble")
                                            .foregroundColor(.blue)
                                        Text("Write a caption")
                                            .font(.system(.headline, design: .rounded))
                                    }
                                    
                                    TextField("What's on your mind?", text: $caption, axis: .vertical)
                                        .font(.system(.body, design: .rounded))
                                        .padding()
                                        .background(Color(.systemGray6))
                                        .cornerRadius(12)
                                        .lineLimit(4...10)
                                }
                                .padding(.horizontal)
                                
                                // Goal selector
                                VStack(alignment: .leading, spacing: 8) {
                                    HStack {
                                        Image(systemName: "target")
                                            .foregroundColor(.orange)
                                        Text("Link to Goal")
                                            .font(.system(.headline, design: .rounded))
                                    }
                                    
                                    Picker("Goal", selection: $selectedGoal) {
                                        Text("None").tag(Goal?.none)
                                        ForEach(availableGoals) { goal in
                                            Text(goal.title).tag(Optional(goal))
                                        }
                                    }
                                    .pickerStyle(.menu)
                                    .padding()
                                    .background(Color(.systemGray6))
                                    .cornerRadius(12)
                                }
                                .padding(.horizontal)
                                
                                // Location toggle
                                Toggle(isOn: $showLocation) {
                                    HStack {
                                        Image(systemName: "location.fill")
                                            .foregroundColor(.red)
                                        Text("Tag Location")
                                            .font(.system(.body, design: .rounded))
                                    }
                                }
                                .padding()
                                .background(Color(.systemGray6))
                                .cornerRadius(12)
                                .padding(.horizontal)
                                
                                // Post button
                                Button(action: {
                                    createPost()
                                }) {
                                    HStack {
                                        if isProcessing {
                                            ProgressView()
                                                .progressViewStyle(.circular)
                                                .tint(.white)
                                        } else {
                                            Text("Post")
                                                .font(.system(.headline, design: .rounded))
                                                .fontWeight(.semibold)
                                        }
                                    }
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(
                                        RoundedRectangle(cornerRadius: 16)
                                            .fill(selectedImage != nil || !caption.isEmpty ? 
                                                  LinearGradient(colors: [.blue, .purple], startPoint: .leading, endPoint: .trailing) : 
                                                  LinearGradient(colors: [.gray], startPoint: .leading, endPoint: .trailing))
                                    )
                                }
                                .disabled(isProcessing || (selectedImage == nil && caption.isEmpty))
                                .padding(.horizontal)
                                .padding(.top, 8)
                            }
                        }
                    }
                    .background(Color(.systemBackground))
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
            .onChange(of: selectedPhoto) { _, newItem in
                Task {
                    if let data = try? await newItem?.loadTransferable(type: Data.self),
                       let uiImage = UIImage(data: data) {
                        withAnimation {
                            selectedImage = uiImage
                        }
                    }
                }
            }
        }
    }
    
    private func createPost() {
        guard !isProcessing else { return }
        isProcessing = true
        
        HapticManager.shared.impact(.medium)
        
        Task {
            do {
                // Convert UIImage to Data
                var imageData: Data? = nil
                if let selectedImage = selectedImage {
                    imageData = selectedImage.jpegData(compressionQuality: 0.8)
                }
                
                // Get current user ID (in real app, from auth)
                let userId = UUID() // TODO: Get from AuthManager
                
                // Create post via API
                let newPost = try await APIService.shared.createPost(
                    userId: userId,
                    goalId: selectedGoal?.id,
                    goalTitle: selectedGoal?.title,
                    caption: caption,
                    image: imageData
                )
                
                await MainActor.run {
                    viewModel.addPost(newPost)
                    HapticManager.shared.notification(.success)
                    isProcessing = false
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        dismiss()
                    }
                }
            } catch {
                await MainActor.run {
                    print("⚠️ API not available, creating post locally: \(error)")
                    
                    // Get current user ID (in real app, from auth)
                    let currentUserId = UUID(uuidString: "00000000-0000-0000-0000-000000000001") ?? UUID()
                    
                    // Create post locally with mock data when API fails
                    let mockPost = Post(
                        userId: currentUserId,
                        userName: "You", // TODO: Get from AuthManager
                        goalId: selectedGoal?.id,
                        goalTitle: selectedGoal?.title,
                        caption: caption,
                        imageURL: nil, // In real app, would upload image first
                        timestamp: Date(),
                        likes: 0,
                        isLiked: false,
                        comments: []
                    )
                    
                    viewModel.addPost(mockPost)
                    HapticManager.shared.notification(.success)
                    isProcessing = false
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        dismiss()
                    }
                }
            }
        }
    }
}

