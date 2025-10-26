import SwiftUI

struct MainSettingsView: View {
    @Environment(\.dismiss) var dismiss
    @AppStorage("hasSeenOnboarding") private var hasSeenOnboarding = false
    @State private var notifications = true
    @State private var darkMode = false
    @State private var showLogoutAlert = false
    
    var body: some View {
        NavigationView {
            List {
                Section("Appearance") {
                    Toggle("Dark Mode", isOn: $darkMode)
                        .onChange(of: darkMode) { _, newValue in
                            // Handle dark mode toggle
                        }
                    
                    Picker("Theme", selection: .constant("Default")) {
                        Text("Default").tag("Default")
                        Text("Warm").tag("Warm")
                        Text("Cool").tag("Cool")
                    }
                }
                
                Section("Privacy") {
                    Toggle("Show Profile", isOn: .constant(true))
                    Toggle("Show Goals", isOn: .constant(false))
                    Toggle("Show Stats", isOn: .constant(true))
                    Toggle("Location Services", isOn: $showLocation)
                    
                    NavigationLink(destination: BlockedUsersView()) {
                        HStack {
                            Image(systemName: "person.crop.circle.badge.minus")
                            Text("Blocked Users")
                        }
                    }
                }
                
                Section("Notifications") {
                    Toggle("Goal Reminders", isOn: $notifications)
                    Toggle("Friend Updates", isOn: .constant(true))
                    Toggle("Achievements", isOn: .constant(true))
                    Toggle("Weekly Digest", isOn: .constant(false))
                }
                
                Section("Account") {
                    NavigationLink(destination: EditProfileView()) {
                        HStack {
                            Image(systemName: "person.circle")
                            Text("Edit Profile")
                        }
                    }
                    
                    NavigationLink(destination: DataAndStorageView()) {
                        HStack {
                            Image(systemName: "internaldrive")
                            Text("Data & Storage")
                        }
                    }
                }
                
                Section("About") {
                    HStack {
                        Text("Version")
                        Spacer()
                        Text("1.0.0")
                            .foregroundColor(.secondary)
                    }
                    
                    Button("Rate on App Store") {
                        // Rate action
                    }
                    
                    Button("Contact Support") {
                        // Support action
                    }
                    
                    Link("Privacy Policy", destination: URL(string: "https://example.com/privacy")!)
                    Link("Terms of Service", destination: URL(string: "https://example.com/terms")!)
                }
                
                Section {
                    Button(role: .destructive) {
                        showLogoutAlert = true
                    } label: {
                        HStack {
                            Image(systemName: "rectangle.portrait.and.arrow.right")
                            Text("Log Out")
                        }
                        .foregroundColor(.red)
                    }
                    .alert("Log Out", isPresented: $showLogoutAlert) {
                        Button("Cancel", role: .cancel) { }
                        Button("Log Out", role: .destructive) {
                            // Handle logout
                        }
                    } message: {
                        Text("Are you sure you want to log out?")
                    }
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
    
    @State private var showLocation = false
}

struct BlockedUsersView: View {
    var body: some View {
        Text("No blocked users")
            .foregroundColor(.secondary)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .navigationTitle("Blocked Users")
            .navigationBarTitleDisplayMode(.inline)
    }
}

struct EditProfileView: View {
    var body: some View {
        Text("Edit Profile")
            .navigationTitle("Edit Profile")
            .navigationBarTitleDisplayMode(.inline)
    }
}

struct DataAndStorageView: View {
    var body: some View {
        List {
            Section("Storage") {
                HStack {
                    Text("Used")
                    Spacer()
                    Text("45 MB")
                        .foregroundColor(.secondary)
                }
            }
            
            Section("Actions") {
                Button("Clear Cache") {
                    // Clear cache
                }
                .foregroundColor(.blue)
            }
        }
        .navigationTitle("Data & Storage")
        .navigationBarTitleDisplayMode(.inline)
    }
}

