//
//  ContentView.swift
//  TimecardApp
//
//  Created by Damian Rozycki on 10/4/24.
//
import SwiftUI

struct ContentView: View {
    @AppStorage("userId") private var userId: String?
    
    init() {
        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.configureWithOpaqueBackground()
        tabBarAppearance.backgroundColor = UIColor.white
        
        tabBarAppearance.stackedLayoutAppearance.normal.iconColor = UIColor.gray
        tabBarAppearance.stackedLayoutAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.gray]
        
        tabBarAppearance.stackedLayoutAppearance.selected.iconColor = UIColor.systemTeal
        tabBarAppearance.stackedLayoutAppearance.selected.titleTextAttributes = [.foregroundColor: UIColor.systemTeal]
        
        UITabBar.appearance().standardAppearance = tabBarAppearance
        UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
    }
    
    var body: some View {
        Group {
            if userId != nil {
                TabView {
                    CalendarView()
                        .tabItem {
                            Label("Calendar", systemImage: "person")
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
