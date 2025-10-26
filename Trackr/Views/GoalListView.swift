import SwiftUI

struct GoalListView: View {
    @ObservedObject var goalStore: GoalStore
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                ForEach(goalStore.goals) { goal in
                    NavigationLink(destination: GoalDetailView(goal: goal, goalStore: goalStore)) {
                        AnimatedGoalCard(goal: goal)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding()
        }
    }
}

struct GoalRowView: View {
    let goal: Goal
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                // Category color indicator
                RoundedRectangle(cornerRadius: 4)
                    .fill(VintageColors.colorForCategory(goal.category))
                    .frame(width: 4, height: 40)
                
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text(goal.title)
                            .font(.custom("Georgia", size: 20))
                            .fontWeight(.bold)
                            .foregroundColor(VintageColors.deepBrown)
                        
                        Spacer()
                        
                        if goal.isCompleted {
                            ZStack {
                                Circle()
                                    .fill(VintageColors.sageGreen.opacity(0.2))
                                    .frame(width: 32, height: 32)
                                
                                Image(systemName: "checkmark.circle.fill")
                                    .font(.title3)
                                    .foregroundColor(VintageColors.forestGreen)
                            }
                        }
                    }
                    
                    Text(goal.description)
                        .font(.custom("Georgia", size: 14))
                        .foregroundColor(VintageColors.warmGray)
                        .lineLimit(2)
                    
                    // Category and Date
                    HStack(spacing: 12) {
                        Label {
                            Text(goal.category)
                                .font(.custom("Georgia", size: 12))
                                .foregroundColor(VintageColors.colorForCategory(goal.category))
                        } icon: {
                            Image(systemName: "tag.fill")
                                .font(.caption)
                                .foregroundColor(VintageColors.colorForCategory(goal.category))
                        }
                        
                        Spacer()
                        
                        Label {
                            Text(goal.targetDate, format: .dateTime.month(.abbreviated).day())
                                .font(.custom("Georgia", size: 12))
                                .foregroundColor(VintageColors.warmGray)
                        } icon: {
                            Image(systemName: "calendar")
                                .font(.caption)
                                .foregroundColor(VintageColors.warmGray)
                        }
                    }
                    
                    // Progress Bar
                    VStack(alignment: .leading, spacing: 4) {
                        HStack {
                            Text("Progress")
                                .font(.custom("Georgia", size: 12))
                                .foregroundColor(VintageColors.deepBrown.opacity(0.7))
                            
                            Spacer()
                            
                            Text("\(Int(goal.progress * 100))%")
                                .font(.custom("Georgia", size: 12))
                                .fontWeight(.semibold)
                                .foregroundColor(VintageColors.deepBrown)
                        }
                        
                        ProgressView(value: goal.progress)
                            .progressViewStyle(VintageProgressStyle(color: VintageColors.colorForCategory(goal.category)))
                    }
                }
            }
        }
        .padding(16)
        .vintageCard()
    }
}

