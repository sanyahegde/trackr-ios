import Foundation
import SwiftUI

struct Post: Identifiable {
    let id: UUID
    let userId: UUID
    let userName: String
    let profileImageURL: String?
    let goalId: UUID?
    let goalTitle: String?
    let caption: String
    let imageURL: String?
    let location: PostLocation?
    let timestamp: Date
    var likes: Int
    var isLiked: Bool
    var comments: [Comment]
    
    struct PostLocation {
        let latitude: Double
        let longitude: Double
        let cityName: String
        
        var coordinate: CLLocationCoordinate2D {
            CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        }
    }
    
    init(id: UUID = UUID(), userId: UUID, userName: String, profileImageURL: String? = nil, goalId: UUID?, goalTitle: String?, caption: String, imageURL: String? = nil, location: PostLocation? = nil, timestamp: Date = Date(), likes: Int = 0, isLiked: Bool = false, comments: [Comment] = []) {
        self.id = id
        self.userId = userId
        self.userName = userName
        self.profileImageURL = profileImageURL
        self.goalId = goalId
        self.goalTitle = goalTitle
        self.caption = caption
        self.imageURL = imageURL
        self.location = location
        self.timestamp = timestamp
        self.likes = likes
        self.isLiked = isLiked
        self.comments = comments
    }
}

import CoreLocation
extension Post.PostLocation {
    var clLocation: CLLocation {
        CLLocation(latitude: latitude, longitude: longitude)
    }
}

