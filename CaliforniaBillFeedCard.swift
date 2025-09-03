import SwiftUI

struct CaliforniaBillFeedCard: View {
    let bill: CaliforniaBill
    @State private var showingDetails = false
    @State private var showingAIView = false
    @ObservedObject private var followingManager = FollowingManager.shared
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Bill header
            HStack {
                Text(bill.billNumber)
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(ColorUtilities.patrioticBlue)
                
                Spacer()
                
                Text(bill.house)
                    .font(.caption)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(ColorUtilities.patrioticBlue.opacity(0.1))
                    .foregroundColor(ColorUtilities.patrioticBlue)
                    .cornerRadius(8)
            }
            
            // Bill title
            Text(bill.displayTitle)
                .font(.subheadline)
                .fontWeight(.medium)
                .lineLimit(3)
                .multilineTextAlignment(.leading)
            
            // Bill author
            Text("Author: \(bill.author)")
                .font(.caption)
                .foregroundColor(.secondary)
            
            // Status and date
            HStack {
                Text(bill.status)
                    .font(.caption)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(bill.statusColor.opacity(0.1))
                    .foregroundColor(bill.statusColor)
                    .cornerRadius(8)
                
                Spacer()
                
                Text(bill.formattedDate)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            // Last action
            if !bill.lastAction.isEmpty {
                Text(bill.lastAction)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
            }
            
            // Action buttons
            HStack {
                Spacer()
                
                // Ask AI button
                Button(action: {
                    showingAIView = true
                }) {
                    HStack {
                        Image(systemName: "brain.head.profile")
                        Text("Ask AI")
                    }
                    .font(.caption)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                }
                
                // Follow button
                Button(action: {
                    if followingManager.isFollowing(bill: bill) {
                        followingManager.unfollow(bill: bill)
                    } else {
                        followingManager.follow(bill: bill)
                    }
                }) {
                    HStack {
                        Image(systemName: followingManager.isFollowing(bill: bill) ? "heart.fill" : "heart")
                        Text(followingManager.isFollowing(bill: bill) ? "Unfollow" : "Follow")
                    }
                    .font(.caption)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(followingManager.isFollowing(bill: bill) ? Color.red : Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                }
            }
        }
        .padding(16)
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
        .onTapGesture {
            showingDetails = true
        }
        .sheet(isPresented: $showingDetails) {
            CaliforniaBillDetailView(bill: bill)
        }
        .sheet(isPresented: $showingAIView) {
            CaliforniaBillAIView(bill: bill)
        }
    }
}

// MARK: - California Bill Detail View
struct CaliforniaBillDetailView: View {
    let bill: CaliforniaBill
    @State private var billDetails: CaliforniaBillDetails?
    @State private var isLoading = false
    @State private var errorMessage: String?
    @State private var showingAIView = false
    @Environment(\.dismiss) private var dismiss
    @ObservedObject private var followingManager = FollowingManager.shared
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    if isLoading {
                        ProgressView("Loading bill details...")
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                    } else if let error = errorMessage {
                        Text("Error: \(error)")
                            .foregroundColor(.red)
                            .padding()
                    } else {
                        // Bill header
                        VStack(alignment: .leading, spacing: 8) {
                            Text(bill.billNumber)
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(ColorUtilities.patrioticBlue)
                            
                            Text(bill.house)
                                .font(.caption)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(ColorUtilities.patrioticBlue.opacity(0.1))
                                .foregroundColor(ColorUtilities.patrioticBlue)
                                .cornerRadius(8)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        
                        // Bill title
                        Text(bill.displayTitle)
                            .font(.headline)
                            .fontWeight(.medium)
                        
                        // Bill author
                        Text("Author: \(bill.author)")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        
                        // Status and date
                        HStack {
                            Text(bill.status)
                                .font(.caption)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(bill.statusColor.opacity(0.1))
                                .foregroundColor(bill.statusColor)
                                .cornerRadius(8)
                            
                            Spacer()
                            
                            Text(bill.formattedDate)
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        
                        // Last action
                        if !bill.lastAction.isEmpty {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Last Action")
                                    .font(.subheadline)
                                    .fontWeight(.medium)
                                
                                Text(bill.lastAction)
                                    .font(.body)
                                    .foregroundColor(.secondary)
                            }
                        }
                        
                        // Bill description
                        if let description = bill.description, !description.isEmpty {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Description")
                                    .font(.subheadline)
                                    .fontWeight(.medium)
                                
                                Text(description)
                                    .font(.body)
                                    .foregroundColor(.secondary)
                            }
                        }
                        
                        // Actions history
                        if let details = billDetails, let actions = details.actions, !actions.isEmpty {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Action History")
                                    .font(.subheadline)
                                    .fontWeight(.medium)
                                
                                ForEach(actions.prefix(5), id: \.date) { action in
                                    VStack(alignment: .leading, spacing: 2) {
                                        Text(action.description)
                                            .font(.caption)
                                            .fontWeight(.medium)
                                        
                                        HStack {
                                            Text(action.chamber)
                                                .font(.caption2)
                                                .foregroundColor(.secondary)
                                            
                                            Spacer()
                                            
                                            Text(action.date)
                                                .font(.caption2)
                                                .foregroundColor(.secondary)
                                        }
                                    }
                                    .padding(.vertical, 4)
                                    .padding(.horizontal, 8)
                                    .background(Color(.systemGray6))
                                    .cornerRadius(6)
                                }
                            }
                        }
                        
                        // External link
                        if let url = bill.url, !url.isEmpty {
                            Link("View on California Legislature Website", destination: URL(string: url)!)
                                .font(.caption)
                                .foregroundColor(ColorUtilities.patrioticBlue)
                        }
                    }
                }
                .padding()
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    HStack(spacing: 12) {
                        // Ask AI button
                        Button(action: {
                            showingAIView = true
                        }) {
                            HStack {
                                Image(systemName: "brain.head.profile")
                                Text("Ask AI")
                            }
                            .foregroundColor(.blue)
                        }
                        
                        // Follow button
                        Button(action: {
                            if followingManager.isFollowing(bill: bill) {
                                followingManager.unfollow(bill: bill)
                            } else {
                                followingManager.follow(bill: bill)
                            }
                        }) {
                            HStack {
                                Image(systemName: followingManager.isFollowing(bill: bill) ? "heart.fill" : "heart")
                                Text(followingManager.isFollowing(bill: bill) ? "Unfollow" : "Follow")
                            }
                            .foregroundColor(followingManager.isFollowing(bill: bill) ? .red : .green)
                        }
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
        .onAppear {
            loadBillDetails()
        }
        .sheet(isPresented: $showingAIView) {
            CaliforniaBillAIView(bill: bill)
        }
    }
    
    private func loadBillDetails() {
        isLoading = true
        errorMessage = nil
        
        Task {
            do {
                let details = try await BillDataManager.shared.getCaliforniaBillDetails(billId: bill.id)
                await MainActor.run {
                    self.billDetails = details
                    self.isLoading = false
                }
            } catch {
                await MainActor.run {
                    self.errorMessage = error.localizedDescription
                    self.isLoading = false
                }
            }
        }
    }
}
