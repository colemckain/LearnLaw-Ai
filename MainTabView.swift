import SwiftUI

struct MainTabView: View {
    @StateObject private var navigationCoordinator = NavigationCoordinator()
    
    var body: some View {
        TabView(selection: $navigationCoordinator.selectedTab) {
            HomeFeedView()
                .tabItem {
                    Image(systemName: "house")
                    Text("Home")
                }
                .tag(0)
                .environmentObject(navigationCoordinator)
            
            LearnView()
                .tabItem {
                    Image(systemName: "book")
                    Text("Learn")
                }
                .tag(1)
                .environmentObject(navigationCoordinator)
            
            AskAIBotView(bill: navigationCoordinator.aiSummaryBill)
                .tabItem {
                    Image(systemName: "brain.head.profile")
                    Text("Ask AI")
                }
                .tag(2)
                .environmentObject(navigationCoordinator)
            
            FollowingView()
                .tabItem {
                    Image(systemName: "heart")
                    Text("Following")
                }
                .tag(3)
                .environmentObject(navigationCoordinator)
            
            ProfileView()
                .tabItem {
                    Image(systemName: "person")
                    Text("Profile")
                }
                .tag(4)
                .environmentObject(navigationCoordinator)
        }
        .accentColor(ColorUtilities.patrioticBlue)
        .environmentObject(navigationCoordinator)
    }
}

struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView()
    }
} 