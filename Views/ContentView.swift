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
            ZStack {
                // Vintage background
                VintageColors.cream
                    .ignoresSafeArea()
                
                VStack {
                    if goalStore.goals.isEmpty {
                        EmptyGoalsView()
                    } else {
                        GoalListView(goalStore: goalStore)
                    }
                }
            }
            .navigationTitle("Trackr")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingAddGoal = true }) {
                        Image(systemName: "plus.circle.fill")
                            .font(.title2)
                            .foregroundColor(VintageColors.burntOrange)
                            .shadow(color: VintageColors.burntOrange.opacity(0.3), radius: 4)
                    }
                }
            }
            .sheet(isPresented: $showingAddGoal) {
                AddGoalView(goalStore: goalStore)
            }
            .accentColor(VintageColors.burntOrange)
        }
    }
}

struct EmptyGoalsView: View {
    var body: some View {
        VStack(spacing: 24) {
            ZStack {
                Circle()
                    .fill(VintageColors.sepia.opacity(0.1))
                    .frame(width: 120, height: 120)
                
                Image(systemName: "target")
                    .font(.system(size: 60))
                    .foregroundColor(VintageColors.burntOrange)
            }
            
            VStack(spacing: 8) {
                Text("No Goals Yet")
                    .font(.custom("Georgia", size: 24))
                    .fontWeight(.bold)
                    .foregroundColor(VintageColors.deepBrown)
                
                Text("Add your first goal to get started!")
                    .font(.custom("Georgia", size: 16))
                    .foregroundColor(VintageColors.warmGray)
                    .multilineTextAlignment(.center)
            }
        }
        .padding(40)
        .frame(maxWidth: .infinity)
    }
}

