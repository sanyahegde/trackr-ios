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
        ZStack {
            VintageColors.cream
                .ignoresSafeArea()
            
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    // Title Section
                    VStack(alignment: .leading, spacing: 12) {
                        Text(goal.title)
                            .font(.custom("Georgia", size: 28))
                            .fontWeight(.bold)
                            .foregroundColor(VintageColors.deepBrown)
                        
                        Text(goal.description)
                            .font(.custom("Georgia", size: 16))
                            .foregroundColor(VintageColors.warmGray)
                    }
                    .padding()
                    .vintageCard()
                    
                    // Details Section
                    VStack(spacing: 16) {
                        HStack {
                            Label("Category", systemImage: "tag.fill")
                                .font(.custom("Georgia", size: 14))
                                .foregroundColor(VintageColors.deepBrown)
                            
                            Spacer()
                            
                            Text(goal.category)
                                .font(.custom("Georgia", size: 14))
                                .fontWeight(.semibold)
                                .foregroundColor(VintageColors.colorForCategory(goal.category))
                        }
                        
                        Divider()
                            .background(VintageColors.sepia.opacity(0.3))
                        
                        HStack {
                            Label("Target Date", systemImage: "calendar")
                                .font(.custom("Georgia", size: 14))
                                .foregroundColor(VintageColors.deepBrown)
                            
                            Spacer()
                            
                            Text(goal.targetDate, format: .dateTime.month().day().year())
                                .font(.custom("Georgia", size: 14))
                                .foregroundColor(VintageColors.warmGray)
                        }
                    }
                    .padding()
                    .vintageCard()
                    
                    // Progress Section
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Progress")
                            .font(.custom("Georgia", size: 18))
                            .fontWeight(.semibold)
                            .foregroundColor(VintageColors.deepBrown)
                        
                        Text("\(Int(progress * 100))% Complete")
                            .font(.custom("Georgia", size: 14))
                            .foregroundColor(VintageColors.colorForCategory(goal.category))
                        
                        ProgressView(value: progress)
                            .progressViewStyle(VintageProgressStyle(color: VintageColors.colorForCategory(goal.category)))
                            .frame(height: 14)
                        
                        Slider(value: $progress, in: 0...1)
                            .tint(VintageColors.colorForCategory(goal.category))
                    }
                    .padding()
                    .vintageCard()
                    
                    // Completion Toggle
                    Toggle(isOn: $isCompleted) {
                        HStack {
                            Image(systemName: "checkmark.circle.fill")
                                .font(.title3)
                            Text("Mark as Completed")
                                .font(.custom("Georgia", size: 16))
                        }
                        .foregroundColor(VintageColors.deepBrown)
                    }
                    .padding()
                    .vintageCard()
                    
                    // Save Button
                    Button(action: updateGoal) {
                        Text("Save Changes")
                            .frame(maxWidth: .infinity)
                            .font(.custom("Georgia", size: 16))
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(VintageColors.burntOrange)
                                    .shadow(color: VintageColors.burntOrange.opacity(0.3), radius: 6, x: 0, y: 3)
                            )
                    }
                }
                .padding()
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

