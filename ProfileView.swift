import SwiftUI

struct ProfileView: View {
    @StateObject private var progressManager = ProgressManager.shared
    @StateObject private var followingManager = FollowingManager.shared
    @StateObject private var achievementManager = AchievementManager.shared
    
    @State private var username = "Civic Citizen"
    @State private var email = "citizen@example.com"
    @State private var joinDate = Date().addingTimeInterval(-7776000) // 90 days ago
    @State private var postsCreated = 23
    
    @State private var showingSettings = false
    @State private var showingEditProfile = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Profile Header
                    VStack(spacing: 16) {
                        // Avatar and Basic Info
                        VStack(spacing: 12) {
                            ZStack {
                                Circle()
                                    .fill(ColorUtilities.patrioticBlue.opacity(0.2))
                                    .frame(width: 100, height: 100)
                                
                                Text(String(username.prefix(1)))
                                    .font(.largeTitle)
                                    .fontWeight(.bold)
                                    .foregroundColor(ColorUtilities.patrioticBlue)
                            }
                            
                            VStack(spacing: 4) {
                                Text(username)
                                    .font(.title2)
                                    .fontWeight(.bold)
                                    .foregroundColor(.primary)
                                
                                Text("Level \(progressManager.currentLevel) • \(progressManager.totalPoints) points")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                        }
                        
                        // Stats Row
                        HStack(spacing: 30) {
                            StatItem(value: "\(followingManager.followedBillIDs.count)", label: "Bills")
                            StatItem(value: "\(postsCreated)", label: "Posts")
                        }
                        
                        // Action Buttons
                        HStack(spacing: 12) {
                            Button(action: {
                                showingEditProfile = true
                            }) {
                                Text("Edit Profile")
                                    .font(.subheadline)
                                    .fontWeight(.medium)
                                    .foregroundColor(ColorUtilities.patrioticBlue)
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 8)
                                    .background(ColorUtilities.patrioticBlue.opacity(0.1))
                                    .cornerRadius(8)
                            }
                            
                            Button(action: {
                                showingSettings = true
                            }) {
                                Image(systemName: "gearshape")
                                    .font(.title3)
                                    .foregroundColor(ColorUtilities.patrioticBlue)
                                    .frame(width: 44, height: 44)
                                    .background(ColorUtilities.patrioticBlue.opacity(0.1))
                                    .cornerRadius(8)
                            }
                        }
                    }
                    .padding()
                    .background(Color(.systemBackground))
                    .cornerRadius(16)
                    .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 1)
                    
                    // Progress Section
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Progress")
                            .font(.headline)
                            .fontWeight(.semibold)
                        
                        VStack(spacing: 12) {
                            let levelProgress = progressManager.getLevelProgress()
                            ProgressRow(
                                title: "Level Progress",
                                current: levelProgress.current,
                                total: levelProgress.total,
                                color: ColorUtilities.patrioticBlue
                            )
                            
                            let weeklyProgress = progressManager.getWeeklyGoalProgress()
                            ProgressRow(
                                title: "Weekly Goal",
                                current: weeklyProgress.current,
                                total: weeklyProgress.total,
                                color: .green
                            )
                            
                            let monthlyProgress = progressManager.getMonthlyActivityProgress()
                            ProgressRow(
                                title: "Monthly Activity",
                                current: monthlyProgress.current,
                                total: monthlyProgress.total,
                                color: .orange
                            )
                        }
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(12)
                    }
                    
                    // Achievements Section
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Achievements")
                            .font(.headline)
                            .fontWeight(.semibold)
                        
                        LazyVGrid(columns: [
                            GridItem(.flexible()),
                            GridItem(.flexible())
                        ], spacing: 12) {
                            ForEach(achievementManager.achievements) { achievement in
                                AchievementCard(achievement: achievement)
                            }
                        }
                    }
                    
                    // Account Info
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Account")
                            .font(.headline)
                            .fontWeight(.semibold)
                        
                        VStack(spacing: 0) {
                            AccountRow(
                                icon: "envelope",
                                title: "Email",
                                value: email
                            )
                            
                            Divider()
                            
                            AccountRow(
                                icon: "calendar",
                                title: "Member Since",
                                value: dateFormatter.string(from: joinDate)
                            )
                            
                            Divider()
                            
                            AccountRow(
                                icon: "location",
                                title: "Location",
                                value: "United States"
                            )
                        }
                        .background(Color(.systemBackground))
                        .cornerRadius(12)
                        .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 1)
                    }
                }
                .padding()
            }
            .navigationTitle("Profile")
            .navigationBarTitleDisplayMode(.large)
        }
        .sheet(isPresented: $showingSettings) {
            SettingsView()
        }
        .sheet(isPresented: $showingEditProfile) {
            EditProfileView(username: $username, email: $email)
        }
    }
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }
}

struct StatItem: View {
    let value: String
    let label: String
    
    var body: some View {
        VStack(spacing: 4) {
            Text(value)
                .font(.title3)
                .fontWeight(.bold)
                .foregroundColor(.primary)
            
            Text(label)
                .font(.caption)
                .foregroundColor(.secondary)
        }
    }
}

struct ProgressRow: View {
    let title: String
    let current: Int
    let total: Int
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.medium)
                
                Spacer()
                
                Text("\(current)/\(total)")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            ProgressView(value: Double(current), total: Double(total))
                .progressViewStyle(LinearProgressViewStyle(tint: color))
        }
    }
}

struct AchievementCard: View {
    let achievement: Achievement
    
    var body: some View {
        VStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(achievement.isUnlocked ? achievement.color.opacity(0.2) : Color.gray.opacity(0.2))
                    .frame(width: 50, height: 50)
                
                Image(systemName: achievement.icon)
                    .font(.title2)
                    .foregroundColor(achievement.isUnlocked ? achievement.color : .gray)
            }
            
            VStack(spacing: 4) {
                Text(achievement.title)
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(achievement.isUnlocked ? .primary : .secondary)
                    .multilineTextAlignment(.center)
                
                if achievement.isUnlocked, let date = achievement.dateUnlocked {
                    Text(dateFormatter.string(from: date))
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 1)
        .opacity(achievement.isUnlocked ? 1.0 : 0.6)
    }
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter
    }
}

struct AccountRow: View {
    let icon: String
    let title: String
    let value: String
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.subheadline)
                .foregroundColor(.blue)
                .frame(width: 20)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Text(value)
                    .font(.subheadline)
                    .foregroundColor(.primary)
            }
            
            Spacer()
        }
        .padding()
    }
}

struct SettingsView: View {
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Preferences")) {
                    SettingsRow(icon: "bell", title: "Notifications", subtitle: "Manage your notification preferences")
                    SettingsRow(icon: "eye", title: "Privacy", subtitle: "Control your privacy settings")
                    SettingsRow(icon: "globe", title: "Language", subtitle: "English")
                }
                
                Section(header: Text("Support")) {
                    SettingsRow(icon: "questionmark.circle", title: "Help & FAQ", subtitle: "Get help and find answers")
                    SettingsRow(icon: "envelope", title: "Contact Us", subtitle: "Send us feedback")
                }
                
                Section(header: Text("About")) {
                    SettingsRow(icon: "info.circle", title: "Version", subtitle: "1.0.0")
                    SettingsRow(icon: "doc.text", title: "Terms of Service", subtitle: "Read our terms")
                    SettingsRow(icon: "hand.raised", title: "Privacy Policy", subtitle: "Read our privacy policy")
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(trailing: Button("Done") {
                presentationMode.wrappedValue.dismiss()
            })
        }
    }
}

struct SettingsRow: View {
    let icon: String
    let title: String
    let subtitle: String
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.subheadline)
                .foregroundColor(.blue)
                .frame(width: 20)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.subheadline)
                    .foregroundColor(.primary)
                
                Text(subtitle)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding(.vertical, 4)
    }
}

struct EditProfileView: View {
    @Binding var username: String
    @Binding var email: String
    @Environment(\.presentationMode) var presentationMode
    @State private var tempUsername: String = ""
    @State private var tempEmail: String = ""
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Profile Information")) {
                    HStack {
                        Text("Username")
                        Spacer()
                        TextField("Username", text: $tempUsername)
                            .multilineTextAlignment(.trailing)
                    }
                    
                    HStack {
                        Text("Email")
                        Spacer()
                        TextField("Email", text: $tempEmail)
                            .multilineTextAlignment(.trailing)
                            .keyboardType(.emailAddress)
                    }
                }
            }
            .navigationTitle("Edit Profile")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                leading: Button("Cancel") {
                    presentationMode.wrappedValue.dismiss()
                },
                trailing: Button("Save") {
                    username = tempUsername
                    email = tempEmail
                    presentationMode.wrappedValue.dismiss()
                }
            )
            .onAppear {
                tempUsername = username
                tempEmail = email
            }
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
} 