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
    
    let availableGoals: [Goal] = [] // Will be passed from parent
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(.systemGroupedBackground)
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        // Selected image preview
                        if let image = selectedImage {
                            Image(uiImage: image)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(height: 300)
                                .cornerRadius(20)
                                .overlay(
                                    Button(action: { selectedImage = nil }) {
                                        Image(systemName: "xmark.circle.fill")
                                            .font(.system(size: 30))
                                            .foregroundColor(.white)
                                            .background(Circle().fill(Color.black.opacity(0.5)))
                                    }
                                    .padding(8),
                                    alignment: .topTrailing
                                )
                        }
                        
                        // Photo picker
                        PhotosPicker(
                            selection: $selectedPhoto,
                            matching: .images,
                            photoLibrary: .shared()
                        ) {
                            HStack {
                                Image(systemName: "photo.fill")
                                    .font(.system(size: 24))
                                
                                Text(selectedImage == nil ? "Add Photo" : "Change Photo")
                                    .font(.system(.body, design: .rounded))
                            }
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(LinearGradient(
                                        colors: [.blue, .purple],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    ))
                            )
                        }
                        .onChange(of: selectedPhoto) { _, newItem in
                            Task {
                                if let data = try? await newItem?.loadTransferable(type: Data.self),
                                   let uiImage = UIImage(data: data) {
                                    selectedImage = uiImage
                                }
                            }
                        }
                        
                        // Caption input
                        VStack(alignment: .leading, spacing: 8) {
                            Text("What's on your mind?")
                                .font(.system(.headline, design: .rounded))
                                .foregroundColor(.primary)
                            
                            TextField("Share your progress...", text: $caption, axis: .vertical)
                                .font(.system(.body, design: .rounded))
                                .padding()
                                .background(Color(.systemGray6))
                                .cornerRadius(12)
                                .lineLimit(3...8)
                        }
                        
                        // Goal selector
                        if !availableGoals.isEmpty {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Link to Goal")
                                    .font(.system(.headline, design: .rounded))
                                
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
                        }
                        
                        // Location toggle
                        Toggle(isOn: $showLocation) {
                            HStack {
                                Image(systemName: "location.fill")
                                    .foregroundColor(.blue)
                                
                                Text("Add Location")
                                    .font(.system(.body, design: .rounded))
                            }
                        }
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(12)
                    }
                    .padding()
                }
            }
            .navigationTitle("Create Post")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Post") {
                        createPost()
                    }
                    .fontWeight(.semibold)
                    .disabled(caption.isEmpty && selectedImage == nil)
                }
            }
        }
    }
    
    private func createPost() {
        let newPost = Post(
            userId: UUID(),
            userName: "You",
            goalId: selectedGoal?.id,
            goalTitle: selectedGoal?.title,
            caption: caption,
            imageURL: nil, // Will handle image upload in real app
            timestamp: Date()
        )
        
        viewModel.addPost(newPost)
        HapticManager.shared.notification(.success)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            dismiss()
        }
    }
}

