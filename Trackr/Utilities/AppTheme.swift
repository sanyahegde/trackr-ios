import SwiftUI

// MARK: - Brand Identity
// Logo Concept: Two Interlocking Dots
// Reasoning: Represents shared connection, mutual accountability, and the bond between partners/small groups
// Visual: Two soft, overlapping circles that form a cohesive unit - symbolizing how consistency is built together

// MARK: - Color Palette
struct AppColors {
    // Primary Warm Palette
    static let primaryCoral = Color(red: 1.0, green: 0.45, blue: 0.45) // Warm coral
    static let primaryPeach = Color(red: 1.0, green: 0.65, blue: 0.55) // Soft peach
    static let primaryLavender = Color(red: 0.75, green: 0.65, blue: 0.95) // Gentle lavender
    static let primarySky = Color(red: 0.55, green: 0.80, blue: 1.0) // Sky blue
    static let primaryMint = Color(red: 0.55, green: 0.95, blue: 0.85) // Fresh mint
    static let primaryButter = Color(red: 1.0, green: 0.90, blue: 0.55) // Warm butter
    
    // Background & Surface Colors
    static let background = Color(red: 0.98, green: 0.97, blue: 0.99) // Soft white with hint of lavender
    static let surface = Color.white
    static let cardBackground = Color.white
    static let overlay = Color.black.opacity(0.1)
    
    // Text Colors
    static let textPrimary = Color(red: 0.15, green: 0.15, blue: 0.20)
    static let textSecondary = Color(red: 0.45, green: 0.45, blue: 0.50)
    static let textTertiary = Color(red: 0.65, green: 0.65, blue: 0.70)
    
    // Accent Colors
    static let success = Color(red: 0.35, green: 0.85, blue: 0.65) // Soft green
    static let warning = Color(red: 1.0, green: 0.75, blue: 0.45) // Warm orange
    static let error = Color(red: 1.0, green: 0.50, blue: 0.55) // Soft red
    static let info = Color(red: 0.55, green: 0.75, blue: 1.0) // Soft blue
    
    // Gradient Combinations
    static let gradientPrimary = LinearGradient(
        colors: [primaryCoral, primaryPeach],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let gradientSecondary = LinearGradient(
        colors: [primaryLavender, primarySky],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let gradientWarm = LinearGradient(
        colors: [primaryPeach, primaryButter],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let gradientCool = LinearGradient(
        colors: [primarySky, primaryMint],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
}

// MARK: - Typography
struct AppTypography {
    // Rounded, friendly sans-serif
    static func largeTitle(weight: Font.Weight = .bold) -> Font {
        .system(.largeTitle, design: .rounded).weight(weight)
    }
    
    static func title(weight: Font.Weight = .semibold) -> Font {
        .system(.title, design: .rounded).weight(weight)
    }
    
    static func title2(weight: Font.Weight = .semibold) -> Font {
        .system(.title2, design: .rounded).weight(weight)
    }
    
    static func title3(weight: Font.Weight = .semibold) -> Font {
        .system(.title3, design: .rounded).weight(weight)
    }
    
    static func headline(weight: Font.Weight = .semibold) -> Font {
        .system(.headline, design: .rounded).weight(weight)
    }
    
    static func body(weight: Font.Weight = .regular) -> Font {
        .system(.body, design: .rounded).weight(weight)
    }
    
    static func callout(weight: Font.Weight = .regular) -> Font {
        .system(.callout, design: .rounded).weight(weight)
    }
    
    static func subheadline(weight: Font.Weight = .regular) -> Font {
        .system(.subheadline, design: .rounded).weight(weight)
    }
    
    static func footnote(weight: Font.Weight = .regular) -> Font {
        .system(.footnote, design: .rounded).weight(weight)
    }
    
    static func caption(weight: Font.Weight = .regular) -> Font {
        .system(.caption, design: .rounded).weight(weight)
    }
}

// MARK: - Shape & Spacing
struct AppShapes {
    static let cornerRadius: CGFloat = 20
    static let cardCornerRadius: CGFloat = 24
    static let buttonCornerRadius: CGFloat = 16
    static let smallCornerRadius: CGFloat = 12
    
    static let shadow = ShadowStyle(
        color: Color.black.opacity(0.08),
        radius: 12,
        x: 0,
        y: 4
    )
    
    static let shadowLarge = ShadowStyle(
        color: Color.black.opacity(0.12),
        radius: 20,
        x: 0,
        y: 8
    )
    
    static let shadowSoft = ShadowStyle(
        color: AppColors.primaryCoral.opacity(0.15),
        radius: 16,
        x: 0,
        y: 6
    )
}

struct ShadowStyle {
    let color: Color
    let radius: CGFloat
    let x: CGFloat
    let y: CGFloat
}

struct AppSpacing {
    static let xs: CGFloat = 4
    static let sm: CGFloat = 8
    static let md: CGFloat = 16
    static let lg: CGFloat = 24
    static let xl: CGFloat = 32
    static let xxl: CGFloat = 48
}

// MARK: - Button Styles
struct AppButtonStyle {
    static let primary = PrimaryButtonStyle()
    static let secondary = SecondaryButtonStyle()
    static let ghost = GhostButtonStyle()
}

struct PrimaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(AppTypography.headline())
            .foregroundColor(.white)
            .padding(.horizontal, AppSpacing.lg)
            .padding(.vertical, AppSpacing.md)
            .background(AppColors.gradientPrimary)
            .cornerRadius(AppShapes.buttonCornerRadius)
            .shadow(
                color: AppColors.primaryCoral.opacity(configuration.isPressed ? 0.3 : 0.25),
                radius: configuration.isPressed ? 8 : 12,
                x: 0,
                y: configuration.isPressed ? 2 : 4
            )
            .scaleEffect(configuration.isPressed ? 0.96 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.6), value: configuration.isPressed)
    }
}

struct SecondaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(AppTypography.headline())
            .foregroundColor(AppColors.primaryCoral)
            .padding(.horizontal, AppSpacing.lg)
            .padding(.vertical, AppSpacing.md)
            .background(AppColors.primaryCoral.opacity(0.1))
            .cornerRadius(AppShapes.buttonCornerRadius)
            .scaleEffect(configuration.isPressed ? 0.96 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.6), value: configuration.isPressed)
    }
}

struct GhostButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(AppTypography.body())
            .foregroundColor(AppColors.textSecondary)
            .padding(.horizontal, AppSpacing.md)
            .padding(.vertical, AppSpacing.sm)
            .background(Color.clear)
            .scaleEffect(configuration.isPressed ? 0.96 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.6), value: configuration.isPressed)
    }
}

// MARK: - Card Style
struct AppCardStyle: ViewModifier {
    var padding: CGFloat = AppSpacing.md
    var backgroundColor: Color = AppColors.cardBackground
    
    func body(content: Content) -> some View {
        content
            .padding(padding)
            .background(backgroundColor)
            .cornerRadius(AppShapes.cardCornerRadius)
            .shadow(
                color: AppShapes.shadow.color,
                radius: AppShapes.shadow.radius,
                x: AppShapes.shadow.x,
                y: AppShapes.shadow.y
            )
    }
}

extension View {
    func appCard(padding: CGFloat = AppSpacing.md, backgroundColor: Color = AppColors.cardBackground) -> some View {
        modifier(AppCardStyle(padding: padding, backgroundColor: backgroundColor))
    }
}

// MARK: - Avatar Style
struct AppAvatar: View {
    let name: String
    let size: CGFloat
    let gradient: LinearGradient
    
    init(name: String, size: CGFloat = 44, gradient: LinearGradient? = nil) {
        self.name = name
        self.size = size
        self.gradient = gradient ?? AppColors.gradientPrimary
    }
    
    var body: some View {
        ZStack {
            Circle()
                .fill(gradient)
                .frame(width: size, height: size)
                .shadow(color: AppShapes.shadow.color, radius: AppShapes.shadow.radius * 0.5, x: 0, y: 2)
            
            Text(name.prefix(1).uppercased())
                .font(.system(size: size * 0.4, design: .rounded))
                .fontWeight(.bold)
                .foregroundColor(.white)
        }
    }
}

// MARK: - Logo Component
struct AppLogo: View {
    let size: CGFloat
    
    init(size: CGFloat = 48) {
        self.size = size
    }
    
    var body: some View {
        ZStack {
            // Two interlocking dots
            HStack(spacing: size * 0.15) {
                Circle()
                    .fill(AppColors.gradientPrimary)
                    .frame(width: size * 0.65, height: size * 0.65)
                    .shadow(color: AppColors.primaryCoral.opacity(0.3), radius: 8, x: 0, y: 4)
                
                Circle()
                    .fill(AppColors.gradientSecondary)
                    .frame(width: size * 0.65, height: size * 0.65)
                    .shadow(color: AppColors.primaryLavender.opacity(0.3), radius: 8, x: 0, y: 4)
            }
        }
        .frame(width: size, height: size)
    }
}

// MARK: - Gradient Background
struct AppGradientBackground: View {
    var body: some View {
        LinearGradient(
            colors: [
                AppColors.background,
                AppColors.primaryLavender.opacity(0.05),
                AppColors.primarySky.opacity(0.03)
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .ignoresSafeArea()
    }
}

