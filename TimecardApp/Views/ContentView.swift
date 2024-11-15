import SwiftUI

struct ContentView: View {
    @AppStorage("userId") private var userId: String?
    //
    init() {
        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.configureWithOpaqueBackground()
        tabBarAppearance.backgroundColor = UIColor.white
        
        UITabBar.appearance().standardAppearance = tabBarAppearance
        UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
    }
    //
    var body: some View {
        Group {
            if userId != nil {
                TabView {
                    CalendarView()
                        .tabItem {
                            Label("Calendar", systemImage: "calendar")
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
