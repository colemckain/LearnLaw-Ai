import SwiftUI

struct FollowingView: View {
    @ObservedObject private var followingManager = FollowingManager.shared
    @ObservedObject private var billDataManager = BillDataManager.shared
    
    var followedFederalBills: [Bill] {
        billDataManager.recentBills.filter { followingManager.followedBillIDs.contains($0.id) }
    }
    
    var followedCaliforniaBills: [CaliforniaBill] {
        billDataManager.recentCaliforniaBills.filter { followingManager.followedCaliforniaBillIDs.contains($0.id) }
    }
    
    var totalFollowedBills: Int {
        followedFederalBills.count + followedCaliforniaBills.count
    }
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                if totalFollowedBills == 0 {
                    Spacer()
                    Text("You haven't followed any bills yet.")
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                    Spacer()
                } else {
                    ScrollView {
                        LazyVStack(spacing: 16) {
                            // Federal Bills Section
                            if !followedFederalBills.isEmpty {
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("Federal Bills")
                                        .font(.headline)
                                        .fontWeight(.semibold)
                                        .foregroundColor(.primary)
                                        .padding(.horizontal)
                                    
                                    ForEach(followedFederalBills) { bill in
                                        BillFeedCard(bill: bill)
                                    }
                                }
                            }
                            
                            // California Bills Section
                            if !followedCaliforniaBills.isEmpty {
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("California Bills")
                                        .font(.headline)
                                        .fontWeight(.semibold)
                                        .foregroundColor(.primary)
                                        .padding(.horizontal)
                                    
                                    ForEach(followedCaliforniaBills) { bill in
                                        CaliforniaBillFeedCard(bill: bill)
                                    }
                                }
                            }
                        }
                        .padding(.vertical)
                    }
                }
            }
            .navigationTitle("Following")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct FilterButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.caption)
                .fontWeight(.medium)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(isSelected ? ColorUtilities.patrioticBlue : Color(.systemGray5))
                .foregroundColor(isSelected ? .white : .primary)
                .cornerRadius(16)
        }
    }
}

struct FollowingView_Previews: PreviewProvider {
    static var previews: some View {
        FollowingView()
    }
} 