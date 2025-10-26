import SwiftUI

struct AddGoalView: View {
    @ObservedObject var goalStore: GoalStore
    @Environment(\.dismiss) var dismiss
    
    @State private var title = ""
    @State private var description = ""
    @State private var selectedCategory = "General"
    @State private var targetDate = Date().addingTimeInterval(86400)
    
    let categories = ["General", "Work", "Fitness", "Learning", "Personal", "Finance"]
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Goal Information")) {
                    TextField("Goal Title", text: $title)
                    TextField("Description", text: $description, axis: .vertical)
                        .lineLimit(3...6)
                }
                
                Section(header: Text("Details")) {
                    Picker("Category", selection: $selectedCategory) {
                        ForEach(categories, id: \.self) { category in
                            Text(category).tag(category)
                        }
                    }
                    
                    DatePicker("Target Date", selection: $targetDate, displayedComponents: .date)
                }
                
                Section {
                    Button(action: addGoal) {
                        Text("Add Goal")
                            .frame(maxWidth: .infinity)
                            .foregroundColor(.white)
                    }
                    .buttonStyle(.borderedProminent)
                    .disabled(title.isEmpty)
                }
            }
            .navigationTitle("New Goal")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
    
    func addGoal() {
        let newGoal = Goal(
            title: title,
            description: description,
            targetDate: targetDate,
            category: selectedCategory,
            owner: goalStore.currentUser
        )
        
        goalStore.addGoal(newGoal)
        dismiss()
    }
}

