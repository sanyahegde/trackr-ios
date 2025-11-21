import Foundation

class APIService: ObservableObject {
    static let shared = APIService()
    private let baseURL = "http://localhost:8080/api/v1"
    
    private init() {}
    
    // MARK: - Posts
    
    func fetchPosts() async throws -> [Post] {
        // Use /feed endpoint instead of /posts
        guard let url = URL(string: "\(baseURL)/feed") else {
            throw APIError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        // TODO: Add auth token
        // request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            if let errorString = String(data: data, encoding: .utf8) {
                print("API Error: \(errorString)")
            }
            throw APIError.invalidResponse
        }
        
        // Backend returns { "posts": [...] }
        let feedResponse = try JSONDecoder().decode(FeedResponse.self, from: data)
        return feedResponse.posts.map { $0.toPost() }
    }
    
    func createPost(userId: UUID, goalId: UUID?, goalTitle: String?, caption: String, image: Data?) async throws -> Post {
        guard let url = URL(string: "\(baseURL)/posts") else {
            throw APIError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Get auth token from AuthManager (TODO: implement actual JWT)
        // For now, we'll handle auth in middleware
        // request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        // Build JSON body
        var body: [String: Any] = [
            "caption": caption
        ]
        
        if let goalId = goalId {
            body["goal_id"] = goalId.uuidString
        }
        
        // Note: Image upload would need separate endpoint or multipart/form-data
        // For now, skip image in JSON request
        if let imageData = image {
            // TODO: Upload image first and get URL, or use multipart endpoint
            // For now, just create post without image
        }
        
        request.httpBody = try JSONSerialization.data(withJSONObject: body)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 201 else {
            if let errorString = String(data: data, encoding: .utf8) {
                print("API Error: \(errorString)")
            }
            throw APIError.invalidResponse
        }
        
        let postResponse = try JSONDecoder().decode(PostResponse.self, from: data)
        return postResponse.toPost()
    }
    
    func toggleLike(postId: UUID, userId: UUID) async throws -> Bool {
        guard let url = URL(string: "\(baseURL)/posts/\(postId.uuidString)/like") else {
            throw APIError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body = ["userId": userId.uuidString]
        request.httpBody = try JSONEncoder().encode(body)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw APIError.invalidResponse
        }
        
        let result = try JSONDecoder().decode(LikeResponse.self, from: data)
        return result.liked
    }
    
    // MARK: - Users
    
    func searchUsers(query: String) async throws -> [User] {
        let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        guard let url = URL(string: "\(baseURL)/users?search=\(encodedQuery)") else {
            throw APIError.invalidURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw APIError.invalidResponse
        }
        
        let users = try JSONDecoder().decode([UserResponse].self, from: data)
        return users.map { $0.toUser() }
    }
}

// MARK: - Response Models

struct PostResponse: Codable {
    let id: String
    let user_id: String
    let user_name: String?
    let username: String?
    let profile_image_url: String?
    let goal_id: String?
    let goal_title: String?
    let caption: String
    let image_url: String?
    let location: LocationResponse?
    let likes_count: Int
    let is_liked: Bool?
    let created_at: String
    let comments: [CommentResponse]?
    
    func toPost() -> Post {
        Post(
            id: UUID(uuidString: id) ?? UUID(),
            userId: UUID(uuidString: user_id) ?? UUID(),
            userName: user_name ?? username ?? "Unknown",
            profileImageURL: profile_image_url,
            goalId: goal_id != nil ? UUID(uuidString: goal_id!) : nil,
            goalTitle: goal_title,
            caption: caption,
            imageURL: image_url,
            location: location?.toLocation(),
            timestamp: ISO8601DateFormatter().date(from: created_at) ?? Date(),
            likes: likes_count,
            isLiked: is_liked ?? false,
            comments: comments?.map { $0.toComment() } ?? []
        )
    }
}

struct LocationResponse: Codable {
    let latitude: Double
    let longitude: Double
    let cityName: String?
    
    func toLocation() -> Post.PostLocation {
        Post.PostLocation(
            latitude: latitude,
            longitude: longitude,
            cityName: cityName ?? "Unknown"
        )
    }
}

struct CommentResponse: Codable {
    let id: String
    let user_id: String
    let user_name: String?
    let username: String?
    let text: String
    let likes_count: Int
    let created_at: String
    
    func toComment() -> Comment {
        Comment(
            id: UUID(uuidString: id) ?? UUID(),
            userId: UUID(uuidString: user_id) ?? UUID(),
            userName: user_name ?? username ?? "Unknown",
            text: text,
            timestamp: ISO8601DateFormatter().date(from: created_at) ?? Date(),
            likes: likes_count
        )
    }
}

struct UserResponse: Codable {
    let id: String
    let name: String
    let username: String
    let email: String?
    let profile_image_url: String?
    let followers_count: Int
    let following_count: Int
    
    func toUser() -> User {
        User(
            id: UUID(uuidString: id) ?? UUID(),
            name: name,
            username: username
        )
    }
}

struct FeedResponse: Codable {
    let posts: [PostResponse]
}

struct LikeResponse: Codable {
    let liked: Bool
}

enum APIError: Error {
    case invalidURL
    case invalidResponse
    case decodingError
    case networkError(Error)
}

