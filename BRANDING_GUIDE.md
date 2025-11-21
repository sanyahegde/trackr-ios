# 🎨 Trackr Branding & Design System

## Logo Concept: Two Interlocking Dots

**Chosen Concept:** Two interlocking dots forming a cohesive unit

**Reasoning:**
- Represents shared connection and mutual accountability
- Symbolizes the bond between partners and small groups
- Visual metaphor for building consistency together
- Soft, friendly, approachable aesthetic
- Works beautifully at all scales (icon, app logo, hero image)

**Visual Description:**
Two soft, overlapping circles with gradient fills (coral-peach and lavender-sky). The circles connect at a shared point, creating a sense of unity and partnership. Shadows provide depth and warmth.

---

## Color Palette

### Primary Warm Colors
- **Primary Coral:** `#FF7373` - Warm, energetic, inviting
- **Primary Peach:** `#FFA68C` - Soft, friendly, approachable
- **Primary Lavender:** `#BFA6F2` - Calming, supportive, gentle
- **Primary Sky:** `#8CCDFF` - Fresh, optimistic, clear
- **Primary Mint:** `#8CF2D9` - Refreshing, balanced, healthy
- **Primary Butter:** `#FFE68C` - Warm, cozy, positive

### Background Colors
- **Background:** Soft white with hint of lavender `#FAF7FC`
- **Surface:** Pure white `#FFFFFF`
- **Card Background:** White with subtle shadows
- **Overlay:** Black at 10% opacity

### Text Colors
- **Text Primary:** Dark charcoal `#262633`
- **Text Secondary:** Medium gray `#737380`
- **Text Tertiary:** Light gray `#A6A6B3`

### Accent Colors
- **Success:** Soft green `#59D9A6`
- **Warning:** Warm orange `#FFBF73`
- **Error:** Soft red `#FF808C`
- **Info:** Soft blue `#8CBFFF`

### Gradient Combinations
1. **Primary Gradient:** Coral → Peach (warm, energetic)
2. **Secondary Gradient:** Lavender → Sky (calming, fresh)
3. **Warm Gradient:** Peach → Butter (cozy, positive)
4. **Cool Gradient:** Sky → Mint (refreshing, balanced)

---

## Typography

**Font Family:** SF Pro Rounded (system font with rounded design)

### Type Scale
- **Large Title:** Bold, 34pt - Hero text, main headlines
- **Title:** Semibold, 28pt - Section headers
- **Title 2:** Semibold, 22pt - Card titles
- **Title 3:** Semibold, 20pt - Subsection headers
- **Headline:** Semibold, 17pt - Emphasis text
- **Body:** Regular, 17pt - Primary body text
- **Callout:** Regular, 16pt - Secondary body text
- **Subheadline:** Regular, 15pt - Supporting text
- **Footnote:** Regular, 13pt - Metadata, timestamps
- **Caption:** Regular, 12pt - Fine print

**Characteristics:**
- Rounded, friendly, approachable
- Social media energy, NOT corporate
- Clean and readable at all sizes
- Consistent weight hierarchy

---

## Shape Language & Components

### Corner Radius
- **Cards:** 24px - Main content containers
- **Buttons:** 16px - Interactive elements
- **Small Elements:** 12px - Badges, chips
- **Avatar:** Full circle

### Shadows
- **Card Shadow:** Soft, subtle (`black 8%`, 12px blur, 4px offset)
- **Button Shadow:** Colored, warm (`coral 25%`, 12px blur, 4px offset)
- **Elevated Shadow:** Larger, deeper (`black 12%`, 20px blur, 8px offset)

### Spacing System
- **XS:** 4px
- **SM:** 8px
- **MD:** 16px (default)
- **LG:** 24px
- **XL:** 32px
- **XXL:** 48px

### Button Styles
1. **Primary Button:**
   - Gradient background (coral-peach)
   - White text
   - Rounded corners (16px)
   - Soft colored shadow
   - Scale animation on press

2. **Secondary Button:**
   - Coral text on light coral background (10% opacity)
   - Rounded corners (16px)
   - Subtle scale animation

3. **Ghost Button:**
   - Transparent background
   - Secondary text color
   - Minimal styling
   - Scale animation

---

## Avatar System

**Design:** Circular with gradient background based on user name hash

**Gradients Used:**
- Primary (Coral-Peach)
- Secondary (Lavender-Sky)
- Warm (Peach-Butter)
- Cool (Sky-Mint)

**Sizes:**
- Small: 24px
- Medium: 40px
- Large: 64px

**Features:**
- First letter of name as white text
- Soft shadow for depth
- Consistent gradient assignment per user

---

## Logo Component

**Visual:** Two interlocking dots with gradient fills

**Implementation:**
- Left dot: Primary gradient (coral-peach)
- Right dot: Secondary gradient (lavender-sky)
- Overlapping at center
- Soft shadows for depth
- Scalable from 24px to 128px

**Usage:**
- App icon
- Navigation bar logo (32px)
- Empty states (80px)
- Splash screen (128px)

---

## Component Guidelines

### Cards
- White background
- 24px corner radius
- Soft shadow
- Generous padding (16px default)
- Spacing between cards: 24px

### Buttons
- Minimum touch target: 44x44px
- Rounded corners: 16px
- Clear visual feedback (scale + haptics)
- Gradient backgrounds for primary actions
- Text buttons for secondary actions

### Icons
- SF Symbols preferred
- Rounded style where possible
- Consistent sizing (20-28px)
- Warm, friendly colors

### Images
- Full-width in cards
- Aspect ratio maintained
- Rounded top corners matching card
- Soft loading states

---

## Micro-Interactions

### Animations
1. **Button Press:** Scale to 96% with spring animation
2. **Card Tap:** Subtle lift effect
3. **Like:** Bounce animation with color change
4. **Loading:** Gentle pulsing progress indicator
5. **Empty States:** Fade in with slight scale

### Haptics
- Light impact: Button taps, toggles
- Medium impact: Confirmations, important actions
- Success notification: Completion states
- Error notification: Failures

---

## Design Principles

1. **Warm & Inviting:** Soft colors, rounded shapes, friendly typography
2. **Emotionally Supportive:** Calming palette, encouraging language
3. **Social & Intimate:** Close-knit community feel, personal connections
4. **Soft & Cozy:** No harsh edges, comfortable spacing, gentle shadows
5. **Positive Energy:** Bright but not overwhelming, optimistic tones

---

## Screen-Specific Guidelines

### Feed
- Large post cards with generous spacing
- Profile avatars prominently displayed
- Action buttons easily accessible
- Smooth scrolling with refresh gesture

### Profile
- Gradient header with large avatar
- Clear stat cards
- Friendly bio section
- Easy navigation to settings

### Messages
- Conversation list with avatars
- Unread indicators with coral accent
- Chat bubbles with rounded corners
- Soft keyboard appearance

### Goals
- Progress cards with visual indicators
- Encouraging empty states
- Celebration animations
- Clear call-to-action buttons

---

## Accessibility

- Minimum contrast ratios met (WCAG AA)
- Touch targets minimum 44x44px
- Text scales with system settings
- Color not sole indicator of state
- Haptic feedback for important actions

---

## Implementation Notes

All theme values are centralized in `AppTheme.swift`:
- `AppColors` - All color definitions
- `AppTypography` - Font system
- `AppShapes` - Corner radius and shadows
- `AppSpacing` - Spacing system
- `AppButtonStyle` - Button configurations
- `AppCardStyle` - Card modifier
- `AppAvatar` - Avatar component
- `AppLogo` - Logo component

Use these throughout the app for consistency.

