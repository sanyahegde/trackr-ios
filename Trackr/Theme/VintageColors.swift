import SwiftUI

struct VintageColors {
    // Light Mode Colors
    private static let lightCream = Color(red: 0.98, green: 0.96, blue: 0.90)
    private static let lightParchment = Color(red: 0.95, green: 0.93, blue: 0.87)
    private static let lightDeepBrown = Color(red: 0.35, green: 0.25, blue: 0.20)
    private static let lightWarmGray = Color(red: 0.70, green: 0.65, blue: 0.60)
    
    // Dark Mode Colors
    private static let darkBackground = Color(red: 0.12, green: 0.12, blue: 0.15)
    private static let darkCard = Color(red: 0.18, green: 0.18, blue: 0.22)
    private static let darkText = Color(red: 0.95, green: 0.95, blue: 0.97)
    private static let darkSecondary = Color(red: 0.65, green: 0.65, blue: 0.70)
    
    // Adaptive Colors - Support Dark Mode
    static var cream: Color {
        Color(UIColor { traitCollection in
            traitCollection.userInterfaceStyle == .dark ? UIColor(darkBackground) : UIColor(lightCream)
        })
    }
    
    static var parchment: Color {
        Color(UIColor { traitCollection in
            traitCollection.userInterfaceStyle == .dark ? UIColor(darkCard) : UIColor(lightParchment)
        })
    }
    
    static var deepBrown: Color {
        Color(UIColor { traitCollection in
            traitCollection.userInterfaceStyle == .dark ? UIColor(darkText) : UIColor(lightDeepBrown)
        })
    }
    
    static var warmGray: Color {
        Color(UIColor { traitCollection in
            traitCollection.userInterfaceStyle == .dark ? UIColor(darkSecondary) : UIColor(lightWarmGray)
        })
    }
    
    // Accent Colors (same in both modes, but with better contrast in dark)
    static let sepia = Color(red: 0.75, green: 0.65, blue: 0.55)
    static let burntOrange = Color(red: 0.85, green: 0.55, blue: 0.40)
    static let forestGreen = Color(red: 0.35, green: 0.55, blue: 0.40)
    static let sageGreen = Color(red: 0.65, green: 0.75, blue: 0.65)
    static let dustyBlue = Color(red: 0.50, green: 0.60, blue: 0.70)
    static let mutedRed = Color(red: 0.80, green: 0.45, blue: 0.40)
    
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

