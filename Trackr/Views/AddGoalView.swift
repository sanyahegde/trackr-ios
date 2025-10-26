import SwiftUI

struct AddGoalView: View {
    @ObservedObject var goalStore: GoalStore
    @Environment(\.dismiss) var dismiss
    
    @State private var title = ""
    @State private var description = ""
    @State private var selectedCategory = "General"
    @State private var targetDate = Date().addingTimeInterval(86400)
    @State private var privacyLevel: PrivacyLevel = .private
    
    let categories = ["General", "Work", "Fitness", "Learning", "Personal", "Finance"]
    let privacyLevels: [PrivacyLevel] = [.private, .friends, .public]
    
    var body: some View {
        NavigationView {
            ZStack {
                VintageColors.cream
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 20) {
                        // Goal Information Section
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Goal Information")
                                .font(.custom("Georgia", size: 18))
                                .fontWeight(.bold)
                                .foregroundColor(VintageColors.deepBrown)
                                .padding(.bottom, 4)
                            
                            TextField("Goal Title", text: $title)
                                .font(.custom("Georgia", size: 16))
                                .padding()
                                .background(Color.white)
                                .cornerRadius(10)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(VintageColors.sepia.opacity(0.3), lineWidth: 2)
                                )
                            
                            TextField("Description", text: $description, axis: .vertical)
                                .font(.custom("Georgia", size: 16))
                                .lineLimit(3...6)
                                .padding()
                                .background(Color.white)
                                .cornerRadius(10)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(VintageColors.sepia.opacity(0.3), lineWidth: 2)
                                )
                        }
                        .padding()
                        .vintageCard()
                        
                        // Details Section
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Details")
                                .font(.custom("Georgia", size: 18))
                                .fontWeight(.bold)
                                .foregroundColor(VintageColors.deepBrown)
                                .padding(.bottom, 4)
                            
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Category")
                                    .font(.custom("Georgia", size: 14))
                                    .foregroundColor(VintageColors.deepBrown)
                                
                                Picker("Category", selection: $selectedCategory) {
                                    ForEach(categories, id: \.self) { category in
                                        Text(category)
                                            .tag(category)
                                            .font(.custom("Georgia", size: 16))
                                    }
                                }
                                .pickerStyle(.menu)
                                .padding()
                                .background(Color.white)
                                .cornerRadius(10)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(VintageColors.sepia.opacity(0.3), lineWidth: 2)
                                )
                            }
                            
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Privacy")
                                    .font(.custom("Georgia", size: 14))
                                    .foregroundColor(VintageColors.deepBrown)
                                
                                Picker("Privacy", selection: $privacyLevel) {
                                    ForEach(privacyLevels, id: \.self) { privacy in
                                        Label(privacy.rawValue, systemImage: privacyIcon(for: privacy))
                                            .tag(privacy)
                                            .font(.custom("Georgia", size: 16))
                                    }
                                }
                                .pickerStyle(.menu)
                                .padding()
                                .background(Color.white)
                                .cornerRadius(10)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(VintageColors.sepia.opacity(0.3), lineWidth: 2)
                                )
                            }
                            
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Target Date")
                                    .font(.custom("Georgia", size: 14))
                                    .foregroundColor(VintageColors.deepBrown)
                                
                                DatePicker("Target Date", selection: $targetDate, displayedComponents: .date)
                                    .datePickerStyle(.compact)
                                    .font(.custom("Georgia", size: 16))
                                    .padding()
                                    .background(Color.white)
                                    .cornerRadius(10)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 10)
                                            .stroke(VintageColors.sepia.opacity(0.3), lineWidth: 2)
                                    )
                            }
                        }
                        .padding()
                        .vintageCard()
                        
                        // Add Button
                        Button(action: addGoal) {
                            Text("Add Goal")
                                .frame(maxWidth: .infinity)
                                .font(.custom("Georgia", size: 18))
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                                .padding()
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(title.isEmpty ? VintageColors.warmGray : VintageColors.burntOrange)
                                        .shadow(color: (title.isEmpty ? VintageColors.warmGray : VintageColors.burntOrange).opacity(0.3), radius: 6, x: 0, y: 3)
                                )
                        }
                        .disabled(title.isEmpty)
                    }
                    .padding()
                }
            }
            .navigationTitle("New Goal")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .font(.custom("Georgia", size: 16))
                    .foregroundColor(VintageColors.burntOrange)
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
            owner: goalStore.currentUser,
            privacyLevel: privacyLevel
        )
        
        goalStore.addGoal(newGoal)
        dismiss()
    }
    
    func privacyIcon(for privacy: PrivacyLevel) -> String {
        switch privacy {
        case .private: return "lock.fill"
        case .friends: return "person.2.fill"
        case .public: return "globe"
        }
    }
}

