# Swift API Client Examples for Trackr Go Backend

This document provides Swift code examples for integrating with the Trackr Go backend API.

## Base Configuration

```swift
import Foundation

class TrackrAPIService {
    static let shared = TrackrAPIService()
    private let baseURL = "http://localhost:8080/api/v1"
    private var accessToken: String?
    private var refreshToken: String?
    
    private init() {}
    
    // MARK: - Helper Methods
    
    private func makeRequest<T: Decodable>(
        endpoint: String,
        method: String = "GET",
        body: Encodable? = nil,
        requiresAuth: Bool = true
    ) async throws -> T {
        guard let url = URL(string: "\(baseURL)\(endpoint)") else {
            throw APIError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if requiresAuth, let token = accessToken {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        if let body = body {
            request.httpBody = try JSONEncoder().encode(body)
        }
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.invalidResponse
        }
        
        if httpResponse.statusCode == 401 {
            // Try to refresh token
            try await refreshAccessToken()
            return try await makeRequest(endpoint: endpoint, method: method, body: body, requiresAuth: requiresAuth)
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            throw APIError.httpError(httpResponse.statusCode)
        }
        
        return try JSONDecoder().decode(T.self, from: data)
    }
    
    private func refreshAccessToken() async throws {
        guard let refreshToken = refreshToken else {
            throw APIError.unauthorized
        }
        
        let request = RefreshTokenRequest(refreshToken: refreshToken)
        let response: AuthResponse = try await makeRequest(
            endpoint: "/auth/refresh",
            method: "POST",
            body: request,
            requiresAuth: false
        )
        
        self.accessToken = response.accessToken
        self.refreshToken = response.refreshToken
    }
}

// MARK: - Models

struct User: Codable, Identifiable {
    let id: UUID
    let email: String
    let name: String
    let username: String
    let createdAt: Date
    
    enum CodingKeys: String, CodingKey {
        case id, email, name, username
        case createdAt = "created_at"
    }
}

struct Goal: Codable, Identifiable {
    let id: UUID
    let userId: UUID
    let title: String
    let description: String?
    let frequency: String
    let createdAt: Date
    
    enum CodingKeys: String, CodingKey {
        case id, title, description, frequency
        case userId = "user_id"
        case createdAt = "created_at"
    }
}

struct CheckIn: Codable, Identifiable {
    let id: UUID
    let goalId: UUID
    let userId: UUID
    let note: String?
    let value: Double?
    let timestamp: Date
    
    enum CodingKeys: String, CodingKey {
        case id, note, value, timestamp
        case goalId = "goal_id"
        case userId = "user_id"
    }
}

struct Streak: Codable {
    let userId: UUID
    let goalId: UUID
    let currentStreak: Int
    let longestStreak: Int
    let lastCheckInDate: Date?
    
    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
        case goalId = "goal_id"
        case currentStreak = "current_streak"
        case longestStreak = "longest_streak"
        case lastCheckInDate = "last_checkin_date"
    }
}

struct Challenge: Codable, Identifiable {
    let id: UUID
    let creatorId: UUID
    let title: String
    let description: String?
    let durationDays: Int
    let startDate: Date
    let endDate: Date
    
    enum CodingKeys: String, CodingKey {
        case id, title, description
        case creatorId = "creator_id"
        case durationDays = "duration_days"
        case startDate = "start_date"
        case endDate = "end_date"
    }
}

struct Achievement: Codable, Identifiable {
    let id: UUID
    let userId: UUID
    let name: String
    let description: String?
    let icon: String?
    let achievedAt: Date
    
    enum CodingKeys: String, CodingKey {
        case id, name, description, icon
        case userId = "user_id"
        case achievedAt = "achieved_at"
    }
}

// MARK: - Request/Response Models

struct SignupRequest: Codable {
    let email: String
    let name: String
    let username: String
    let password: String
}

struct LoginRequest: Codable {
    let email: String
    let password: String
}

struct RefreshTokenRequest: Codable {
    let refreshToken: String
}

struct AuthResponse: Codable {
    let accessToken: String
    let refreshToken: String
    let user: User
    
    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case refreshToken = "refresh_token"
        case user
    }
}

struct CreateGoalRequest: Codable {
    let title: String
    let description: String?
    let frequency: String
}

struct CreateCheckInRequest: Codable {
    let note: String?
    let value: Double?
}

enum APIError: Error {
    case invalidURL
    case invalidResponse
    case httpError(Int)
    case unauthorized
    case decodingError
}
```

## Authentication

```swift
extension TrackrAPIService {
    // MARK: - Authentication
    
    func signup(email: String, name: String, username: String, password: String) async throws -> User {
        let request = SignupRequest(
            email: email,
            name: name,
            username: username,
            password: password
        )
        
        let response: AuthResponse = try await makeRequest(
            endpoint: "/auth/signup",
            method: "POST",
            body: request,
            requiresAuth: false
        )
        
        self.accessToken = response.accessToken
        self.refreshToken = response.refreshToken
        
        return response.user
    }
    
    func login(email: String, password: String) async throws -> User {
        let request = LoginRequest(email: email, password: password)
        
        let response: AuthResponse = try await makeRequest(
            endpoint: "/auth/login",
            method: "POST",
            body: request,
            requiresAuth: false
        )
        
        self.accessToken = response.accessToken
        self.refreshToken = response.refreshToken
        
        return response.user
    }
    
    func logout() {
        accessToken = nil
        refreshToken = nil
    }
    
    func getCurrentUser() async throws -> User {
        try await makeRequest(endpoint: "/auth/me", method: "GET")
    }
}
```

## Users

```swift
extension TrackrAPIService {
    // MARK: - Users
    
    func getUser(id: UUID) async throws -> User {
        try await makeRequest(endpoint: "/users/\(id.uuidString)")
    }
    
    func getFollowers(userId: UUID) async throws -> [User] {
        try await makeRequest(endpoint: "/users/\(userId.uuidString)/followers")
    }
    
    func getFollowing(userId: UUID) async throws -> [User] {
        try await makeRequest(endpoint: "/users/\(userId.uuidString)/following")
    }
    
    func followUser(userId: UUID) async throws {
        let _: EmptyResponse = try await makeRequest(
            endpoint: "/users/follow/\(userId.uuidString)",
            method: "POST"
        )
    }
    
    func unfollowUser(userId: UUID) async throws {
        let _: EmptyResponse = try await makeRequest(
            endpoint: "/users/follow/\(userId.uuidString)",
            method: "DELETE"
        )
    }
    
    func searchUsers(query: String) async throws -> [User] {
        let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        return try await makeRequest(endpoint: "/users/search?q=\(encodedQuery)")
    }
}

struct EmptyResponse: Codable {}
```

## Goals

```swift
extension TrackrAPIService {
    // MARK: - Goals
    
    func createGoal(title: String, description: String?, frequency: String) async throws -> Goal {
        let request = CreateGoalRequest(
            title: title,
            description: description,
            frequency: frequency
        )
        
        return try await makeRequest(
            endpoint: "/goals",
            method: "POST",
            body: request
        )
    }
    
    func getGoals() async throws -> [Goal] {
        try await makeRequest(endpoint: "/goals")
    }
    
    func getGoal(id: UUID) async throws -> Goal {
        try await makeRequest(endpoint: "/goals/\(id.uuidString)")
    }
    
    func updateGoal(id: UUID, title: String?, description: String?, frequency: String?) async throws -> Goal {
        var updateRequest: [String: Any] = [:]
        if let title = title { updateRequest["title"] = title }
        if let description = description { updateRequest["description"] = description }
        if let frequency = frequency { updateRequest["frequency"] = frequency }
        
        let body = try JSONSerialization.data(withJSONObject: updateRequest)
        return try await makeRequest(
            endpoint: "/goals/\(id.uuidString)",
            method: "PATCH",
            body: body
        )
    }
    
    func deleteGoal(id: UUID) async throws {
        let _: EmptyResponse = try await makeRequest(
            endpoint: "/goals/\(id.uuidString)",
            method: "DELETE"
        )
    }
}
```

## Check-ins

```swift
extension TrackrAPIService {
    // MARK: - Check-ins
    
    func createCheckIn(goalId: UUID, note: String?, value: Double?) async throws -> CheckIn {
        let request = CreateCheckInRequest(note: note, value: value)
        
        return try await makeRequest(
            endpoint: "/goals/\(goalId.uuidString)/checkins",
            method: "POST",
            body: request
        )
    }
    
    func getCheckIns(goalId: UUID) async throws -> [CheckIn] {
        try await makeRequest(endpoint: "/goals/\(goalId.uuidString)/checkins")
    }
    
    func getFeed(friendsOnly: Bool = false) async throws -> [CheckIn] {
        let endpoint = friendsOnly ? "/feed?friends_only=true" : "/feed"
        return try await makeRequest(endpoint: endpoint)
    }
}
```

## Streaks

```swift
extension TrackrAPIService {
    // MARK: - Streaks
    
    func getStreaks() async throws -> [Streak] {
        try await makeRequest(endpoint: "/streaks")
    }
    
    func getStreak(goalId: UUID) async throws -> Streak {
        try await makeRequest(endpoint: "/streaks/\(goalId.uuidString)")
    }
}
```

## Challenges

```swift
extension TrackrAPIService {
    // MARK: - Challenges
    
    func createChallenge(
        title: String,
        description: String?,
        durationDays: Int,
        startDate: Date,
        endDate: Date
    ) async throws -> Challenge {
        struct CreateChallengeRequest: Codable {
            let title: String
            let description: String?
            let durationDays: Int
            let startDate: Date
            let endDate: Date
            
            enum CodingKeys: String, CodingKey {
                case title, description
                case durationDays = "duration_days"
                case startDate = "start_date"
                case endDate = "end_date"
            }
        }
        
        let request = CreateChallengeRequest(
            title: title,
            description: description,
            durationDays: durationDays,
            startDate: startDate,
            endDate: endDate
        )
        
        return try await makeRequest(
            endpoint: "/challenges",
            method: "POST",
            body: request
        )
    }
    
    func getChallenges() async throws -> [Challenge] {
        try await makeRequest(endpoint: "/challenges")
    }
    
    func joinChallenge(challengeId: UUID) async throws {
        let _: EmptyResponse = try await makeRequest(
            endpoint: "/challenges/\(challengeId.uuidString)/join",
            method: "POST"
        )
    }
    
    func getChallengeProgress(challengeId: UUID) async throws -> [String: Any] {
        // This would return progress metrics
        // Implementation depends on your progress structure
        try await makeRequest(endpoint: "/challenges/\(challengeId.uuidString)/progress")
    }
}
```

## Achievements

```swift
extension TrackrAPIService {
    // MARK: - Achievements
    
    func getAchievements() async throws -> [Achievement] {
        try await makeRequest(endpoint: "/achievements")
    }
}
```

## Usage Example

```swift
import SwiftUI

class GoalViewModel: ObservableObject {
    @Published var goals: [Goal] = []
    @Published var isLoading = false
    
    func loadGoals() {
        isLoading = true
        Task {
            do {
                let goals = try await TrackrAPIService.shared.getGoals()
                await MainActor.run {
                    self.goals = goals
                    self.isLoading = false
                }
            } catch {
                print("Error loading goals: \(error)")
                await MainActor.run {
                    self.isLoading = false
                }
            }
        }
    }
    
    func createGoal(title: String, description: String?) {
        Task {
            do {
                let goal = try await TrackrAPIService.shared.createGoal(
                    title: title,
                    description: description,
                    frequency: "daily"
                )
                await MainActor.run {
                    self.goals.append(goal)
                }
            } catch {
                print("Error creating goal: \(error)")
            }
        }
    }
}
```

## Notes

1. **Base URL**: Update `baseURL` to match your backend URL (for physical devices, use your Mac's IP address instead of localhost)

2. **Date Formatting**: The API uses ISO8601 format. Make sure your `JSONDecoder` handles dates correctly:

```swift
let decoder = JSONDecoder()
decoder.dateDecodingStrategy = .iso8601
```

3. **Error Handling**: Implement proper error handling in your view models

4. **Token Refresh**: The service automatically refreshes tokens on 401 errors

5. **Thread Safety**: Use `@MainActor` for UI updates from async operations

