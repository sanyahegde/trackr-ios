import SwiftUI

struct AnimatedGoalCard: View {
    let goal: Goal
    @State private var isFlipped = false
    @State private var dragOffset = CGSize.zero
    @State private var isCompleted = false
    @Namespace private var cardNamespace
    
    var body: some View {
        VStack(spacing: 0) {
            if isFlipped {
                CardBackView(goal: goal, isFlipped: $isFlipped)
                    .matchedGeometryEffect(id: "card", in: cardNamespace)
            } else {
                CardFrontView(
                    goal: goal,
                    dragOffset: $dragOffset,
                    isCompleted: $isCompleted,
                    onFlip: { flipCard() }
                )
                .matchedGeometryEffect(id: "card", in: cardNamespace)
            }
        }
        .rotation3DEffect(
            .degrees(isFlipped ? 180 : 0),
            axis: (x: 0, y: 1, z: 0),
            perspective: 0.5
        )
        .animation(.spring(response: 0.6, dampingFraction: 0.8), value: isFlipped)
        .gesture(
            DragGesture()
                .onChanged { value in
                    dragOffset = value.translation
                }
                .onEnded { value in
                    if abs(value.translation.width) > 100 {
                        if value.translation.width > 0 {
                            // Swipe right to complete
                            withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                                isCompleted = true
                            }
                            // Haptic feedback
                            let generator = UIImpactFeedbackGenerator(style: .medium)
                            generator.impactOccurred()
                        }
                        dragOffset = .zero
                    } else {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                            dragOffset = .zero
                        }
                    }
                }
        )
        .scaleEffect(isCompleted ? 0.9 : 1.0)
        .opacity(isCompleted ? 0.5 : 1.0)
    }
    
    private func flipCard() {
        withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
            isFlipped.toggle()
        }
    }
}

struct CardFrontView: View {
    let goal: Goal
    @Binding var dragOffset: CGSize
    @Binding var isCompleted: Bool
    let onFlip: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Header
            HStack {
                RoundedRectangle(cornerRadius: 4)
                    .fill(VintageColors.colorForCategory(goal.category))
                    .frame(width: 4, height: 50)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(goal.title)
                        .font(.system(.title3, design: .rounded))
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                    
                    Text(goal.description)
                        .font(.system(.subheadline, design: .rounded))
                        .foregroundColor(.secondary)
                        .lineLimit(2)
                }
                
                Spacer()
                
                Button(action: onFlip) {
                    Image(systemName: "info.circle.fill")
                        .font(.title3)
                        .foregroundColor(.blue)
                }
            }
            
            // Progress Section
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text("Progress")
                        .font(.system(.caption, design: .rounded))
                        .foregroundColor(.secondary)
                    
                    Spacer()
                    
                    Text("\(Int(goal.progress * 100))%")
                        .font(.system(.caption, design: .rounded))
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)
                }
                
                GeometryReader { geometry in
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 6)
                            .fill(Color.gray.opacity(0.2))
                            .frame(height: 8)
                        
                        RoundedRectangle(cornerRadius: 6)
                            .fill(
                                LinearGradient(
                                    colors: [VintageColors.colorForCategory(goal.category), VintageColors.colorForCategory(goal.category).opacity(0.6)],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .frame(width: geometry.size.width * CGFloat(goal.progress), height: 8)
                            .animation(.spring(response: 0.6), value: goal.progress)
                    }
                }
                .frame(height: 8)
            }
            
            // Footer
            HStack {
                Label(goal.category, systemImage: "tag.fill")
                    .font(.system(.caption, design: .rounded))
                    .foregroundColor(VintageColors.colorForCategory(goal.category))
                
                Spacer()
                
                Label {
                    Text(goal.targetDate, format: .dateTime.month(.abbreviated).day())
                } icon: {
                    Image(systemName: "calendar")
                }
                .font(.system(.caption, design: .rounded))
                .foregroundColor(.secondary)
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color(.systemBackground))
                .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
        )
        .offset(dragOffset)
        .rotationEffect(.degrees(dragOffset.width / 20))
    }
}

struct CardBackView: View {
    let goal: Goal
    @Binding var isFlipped: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Goal Details")
                .font(.system(.title2, design: .rounded))
                .fontWeight(.bold)
            
            VStack(alignment: .leading, spacing: 12) {
                DetailRow(label: "Category", value: goal.category, color: VintageColors.colorForCategory(goal.category))
                DetailRow(label: "Target", value: goal.targetDate.formatted(date: .long, time: .omitted), color: .blue)
                DetailRow(label: "Privacy", value: goal.privacyLevel.rawValue, color: .green)
            }
            
            Spacer()
            
            Button(action: { isFlipped.toggle() }) {
                Text("Done")
                    .font(.system(.body, design: .rounded))
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.blue)
                    )
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color(.systemBackground))
                .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
        )
    }
}

struct DetailRow: View {
    let label: String
    let value: String
    let color: Color
    
    var body: some View {
        HStack {
            Text(label)
                .font(.system(.caption, design: .rounded))
                .foregroundColor(.secondary)
            
            Spacer()
            
            Text(value)
                .font(.system(.caption, design: .rounded))
                .foregroundColor(color)
        }
    }
}

