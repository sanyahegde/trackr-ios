import SwiftUI

struct GoalDetailView: View {
    let goal: Goal
    @ObservedObject var goalStore: GoalStore
    @State private var progress: Double
    @State private var isCompleted: Bool
    
    init(goal: Goal, goalStore: GoalStore) {
        self.goal = goal
        self.goalStore = goalStore
        _progress = State(initialValue: goal.progress)
        _isCompleted = State(initialValue: goal.isCompleted)
    }
    
    var body: some View {
        Form {
            Section {
                VStack(alignment: .leading, spacing: 16) {
                    Text(goal.title)
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Text(goal.description)
                        .font(.body)
                        .foregroundColor(.gray)
                    
                    Divider()
                    
                    HStack {
                        Label("Category", systemImage: "tag.fill")
                        Spacer()
                        Text(goal.category)
                            .foregroundColor(.blue)
                    }
                    
                    HStack {
                        Label("Target Date", systemImage: "calendar")
                        Spacer()
                        Text(goal.targetDate, format: .dateTime.month().day().year())
                            .foregroundColor(.gray)
                    }
                    
                    Divider()
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Progress")
                            .font(.headline)
                        
                        ProgressView(value: progress) {
                            Text("\(Int(progress * 100))%")
                                .font(.caption)
                        }
                        
                        Slider(value: $progress, in: 0...1)
                    }
                    
                    Toggle(isOn: $isCompleted) {
                        Label("Mark as Completed", systemImage: "checkmark.circle.fill")
                    }
                    .tint(.green)
                }
            }
            
            Section {
                Button(action: updateGoal) {
                    Text("Save Changes")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
            }
        }
        .navigationTitle("Goal Details")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    func updateGoal() {
        var updatedGoal = goal
        updatedGoal.progress = progress
        updatedGoal.isCompleted = isCompleted
        goalStore.updateGoal(updatedGoal)
    }
}

