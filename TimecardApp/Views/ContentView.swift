//import SwiftUI
//
//struct ContentView: View {
//    @AppStorage("userId") private var userId: String?
//    @AppStorage("isManager") private var isManager: Bool = false
//    
//    init() {
//        let tabBarAppearance = UITabBarAppearance()
//        tabBarAppearance.configureWithOpaqueBackground()
//        tabBarAppearance.backgroundColor = UIColor.white
//        
//        UITabBar.appearance().standardAppearance = tabBarAppearance
//        UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
//    }
//    
//    var body: some View {
//        Group {
//            if userId != nil {
//                TabView {
//                    if isManager {
//                        ManagerDashboardView()
//                            .tabItem {
//                                Label("Team", systemImage: "person.3.fill") // Changed icon to be more manager-like
//                            }
//                    }
//                    
//                    WeeklySummaryView()
//                        .tabItem {
//                            Label("Weekly", systemImage: "calendar")
//                        }
//                    
//                    TimecardListView()
//                        .tabItem {
//                            Label("Timecards", systemImage: "clock")
//                        }
//                    
//                    ProfileView()
//                        .tabItem {
//                            Label("Profile", systemImage: "person")
//                        }
//                }
//            } else {
//                LoginView()
//            }
//        }
//    }
//}


import SwiftUI

struct ContentView: View {
    @AppStorage("userId") private var userId: String?
    @AppStorage("isManager") private var isManager: Bool = false
    
    @StateObject private var viewModel = TimecardListViewModel()
//    @State private var showingNotifications = false
//    @State private var showingSettings = false
    
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
                                Label("Manager", systemImage: "person.2.fill") // Changed icon to be more manager-like
                            }
                    }
                    
                    WeeklySummaryView()
                        .tabItem {
                            Label("Weekly Summary", systemImage: "calendar")
                        }
                    
                    TimecardListView(viewModel: viewModel)
                        .tabItem {
                            Label("Timecards", systemImage: "clock")
                        }
                    
                    ProfileView()
                        .tabItem {
                            Label("Profile", systemImage: "person")
                        }
                    Settings(viewModel: viewModel)
                        .tabItem {
                            Label("Settings", systemImage: "gearshape")
                        }
                }
            } else {
                LoginView()
            }
        }
    }
}
