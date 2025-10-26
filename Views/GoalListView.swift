import SwiftUI

struct GoalListView: View {
    @ObservedObject var goalStore: GoalStore
    
    var body: some View {
        List {
            ForEach(goalStore.goals) { goal in
                NavigationLink(destination: GoalDetailView(goal: goal, goalStore: goalStore)) {
                    GoalRowView(goal: goal)
                }
            }
            .onDelete(perform: deleteGoals)
        }
    }
    
    func deleteGoals(at offsets: IndexSet) {
        for index in offsets {
            goalStore.deleteGoal(goalStore.goals[index])
        }
    }
}

struct GoalRowView: View {
    let goal: Goal
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(goal.title)
                    .font(.headline)
                
                Spacer()
                
                if goal.isCompleted {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.green)
                }
            }
            
            Text(goal.description)
                .font(.subheadline)
                .foregroundColor(.gray)
                .lineLimit(2)
            
            HStack {
                Label(goal.category, systemImage: "tag.fill")
                    .font(.caption)
                    .foregroundColor(.blue)
                
                Spacer()
                
                Label(goal.targetDate, format: .dateTime.month().day())
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            
            ProgressView(value: goal.progress) {
                Text("\(Int(goal.progress * 100))% Complete")
                    .font(.caption)
            }
        }
        .padding(.vertical, 4)
    }
}

