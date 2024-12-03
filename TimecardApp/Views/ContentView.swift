import SwiftUI

struct ContentView: View {
    @AppStorage("userId") private var userId: String?
    @AppStorage("isManager") private var isManager: Bool = false
    
    init() {
        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.configureWithOpaqueBackground()
        tabBarAppearance.backgroundColor = UIColor.white
        
        UITabBar.appearance().standardAppearance = tabBarAppearance
        UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
    }
    
    var body: some View {
        Group {
            if userId != nil {
                TabView {
                    if isManager {
                        ManagerDashboardView()
                            .tabItem {
                                Label("Team", systemImage: "person.3.fill") // Changed icon to be more manager-like
                            }
                    }
                    
                    WeeklySummaryView()
                        .tabItem {
                            Label("Weekly", systemImage: "calendar")
                        }
                    
                    TimecardListView()
                        .tabItem {
                            Label("Timecards", systemImage: "clock")
                        }
                    
                    ProfileView()
                        .tabItem {
                            Label("Profile", systemImage: "person")
                        }
                }
            } else {
                LoginView()
            }
        }
    }
}
