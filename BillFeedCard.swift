import SwiftUI

class NavigationCoordinator: ObservableObject {
    @Published var selectedTab: Int = 0 // 0: Home, 1: Learn, 2: Ask AI, etc.
    @Published var aiSummaryBill: Bill? = nil
}

struct CardStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color.white)
            .cornerRadius(12)
            .shadow(color: Color(.sRGBLinear, white: 0, opacity: 0.08), radius: 6, x: 0, y: 2)
    }
}

extension View {
    func cardStyle() -> some View {
        self.modifier(CardStyle())
    }
}

struct BillFeedCard: View {
    let bill: Bill
    @ObservedObject private var followingManager = FollowingManager.shared
    @EnvironmentObject var navigationCoordinator: NavigationCoordinator
    @State private var showDetail = false

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(bill.title)
                .font(.title3)
                .fontWeight(.semibold)
                .foregroundColor(.primary)
                .padding(.bottom, 2)
            Text("Date: \(bill.updateDate ?? "Unknown")")
                .font(.subheadline)
                .foregroundColor(.secondary)
            if let status = bill.latestAction?.text {
                Text(status)
                    .font(.body)
                    .fontWeight(.medium)
                    .foregroundColor(.blue)
                    .lineLimit(2)
            }
            HStack(spacing: 16) {
                Button(action: { showDetail = true }) {
                    HStack {
                        Image(systemName: "doc.text.magnifyingglass")
                        Text("Details")
                    }
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .padding(.vertical, 8)
                    .background(ColorUtilities.patrioticBlue)
                    .foregroundColor(.white)
                    .cornerRadius(12)
                }
                .sheet(isPresented: $showDetail) {
                    BillDetailView(bill: bill)
                }
                Button(action: {
                    navigationCoordinator.aiSummaryBill = bill
                    navigationCoordinator.selectedTab = 2
                }) {
                    HStack {
                        Image(systemName: "brain.head.profile")
                        Text("AI Summary")
                            .lineLimit(1)
                    }
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .padding(.vertical, 8)
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(12)
                }
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
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .padding(.vertical, 8)
                    .background(followingManager.isFollowing(bill: bill) ? Color.red : ColorUtilities.patrioticBlue)
                    .foregroundColor(.white)
                    .cornerRadius(12)
                }
            }
            .frame(maxWidth: .infinity)
        }
        .padding(.vertical, 24)
        .padding(.horizontal, 20)
        .frame(minHeight: 160)
        .background(
            RoundedRectangle(cornerRadius: 22)
                .fill(Color(.systemBackground))
                .shadow(color: Color(.sRGBLinear, white: 0, opacity: 0.13), radius: 14, x: 0, y: 6)
        )
        .padding(.horizontal, 8)
        .padding(.vertical, 10)
    }
} 