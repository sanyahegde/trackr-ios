import Foundation
import SwiftUI

struct Post: Identifiable, Codable {
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
    var claps: Int
    var fires: Int
    
    struct PostLocation: Codable {
        let latitude: Double
        let longitude: Double
        let cityName: String
        
        var coordinate: CLLocationCoordinate2D {
            CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        }
    }
    
    init(id: UUID = UUID(), userId: UUID, userName: String, profileImageURL: String? = nil, goalId: UUID?, goalTitle: String?, caption: String, imageURL: String? = nil, location: PostLocation? = nil, timestamp: Date = Date(), likes: Int = 0, claps: Int = 0, fires: Int = 0) {
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
        self.claps = claps
        self.fires = fires
    }
}

import CoreLocation
extension Post.PostLocation {
    var clLocation: CLLocation {
        CLLocation(latitude: latitude, longitude: longitude)
    }
}

