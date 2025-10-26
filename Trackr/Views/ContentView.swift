import SwiftUI

struct ContentView: View {
    @EnvironmentObject var goalStore: GoalStore
    @State private var showingAddGoal = false
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(.systemGroupedBackground)
                    .ignoresSafeArea()
                
                VStack {
                    if goalStore.goals.isEmpty {
                        EmptyGoalsView()
                    } else {
                        GoalListView(goalStore: goalStore)
                    }
                }
            }
            .navigationTitle("Goals")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingAddGoal = true }) {
                        Image(systemName: "plus.circle.fill")
                            .font(.title2)
                            .foregroundColor(.blue)
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
        VStack(spacing: 24) {
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [Color.blue.opacity(0.1), Color.purple.opacity(0.1)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 120, height: 120)
                
                Image(systemName: "target")
                    .font(.system(size: 60))
                    .foregroundColor(.blue)
            }
            
            VStack(spacing: 8) {
                Text("No Goals Yet")
                    .font(.system(.title2, design: .rounded))
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                
                Text("Tap the + button to add your first goal!")
                    .font(.system(.body, design: .rounded))
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
        }
        .padding(40)
        .frame(maxWidth: .infinity)
    }
}

