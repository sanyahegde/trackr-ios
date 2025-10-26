import SwiftUI

struct VintageColors {
    // Primary Vintage Palette
    static let cream = Color(red: 0.98, green: 0.96, blue: 0.90)
    static let parchment = Color(red: 0.95, green: 0.93, blue: 0.87)
    static let sepia = Color(red: 0.75, green: 0.65, blue: 0.55)
    static let burntOrange = Color(red: 0.85, green: 0.55, blue: 0.40)
    static let forestGreen = Color(red: 0.35, green: 0.55, blue: 0.40)
    static let sageGreen = Color(red: 0.65, green: 0.75, blue: 0.65)
    static let deepBrown = Color(red: 0.35, green: 0.25, blue: 0.20)
    static let dustyBlue = Color(red: 0.50, green: 0.60, blue: 0.70)
    static let mutedRed = Color(red: 0.80, green: 0.45, blue: 0.40)
    static let warmGray = Color(red: 0.70, green: 0.65, blue: 0.60)
    
    // Category Colors
    static func colorForCategory(_ category: String) -> Color {
        switch category.lowercased() {
        case "work": return burntOrange
        case "fitness": return forestGreen
        case "learning": return dustyBlue
        case "personal": return mutedRed
        case "finance": return sageGreen
        default: return sepia
        }
    }
}

