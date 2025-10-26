import SwiftUI

struct ContentView: View {
    @StateObject private var goalStore: GoalStore
    @State private var showingAddGoal = false
    
    init() {
        let sampleUser = User(name: "You", username: "user1")
        _goalStore = StateObject(wrappedValue: GoalStore(currentUser: sampleUser))
    }
    
    var body: some View {
        NavigationView {
            VStack {
                if goalStore.goals.isEmpty {
                    EmptyGoalsView()
                } else {
                    GoalListView(goalStore: goalStore)
                }
            }
            .navigationTitle("Trackr")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingAddGoal = true }) {
                        Image(systemName: "plus.circle.fill")
                            .font(.title2)
                    }
                }
            }
            .sheet(isPresented: $showingAddGoal) {
                AddGoalView(goalStore: goalStore)
            }
        }
    }
}

struct EmptyGoalsView: View {
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "target")
                .font(.system(size: 80))
                .foregroundColor(.gray)
            
            Text("No Goals Yet")
                .font(.title2)
                .fontWeight(.semibold)
            
            Text("Add your first goal to get started!")
                .font(.subheadline)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
        }
        .padding()
    }
}

