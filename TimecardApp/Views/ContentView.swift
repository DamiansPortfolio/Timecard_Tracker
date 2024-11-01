//
//  ContentView.swift
//  TimecardApp
//
//  Created by Damian Rozycki on 10/4/24.
//

import SwiftUI

struct ContentView: View {
    init() {
            // Customize the tab bar appearance
            let tabBarAppearance = UITabBarAppearance()
            tabBarAppearance.configureWithOpaqueBackground()
            tabBarAppearance.backgroundColor = UIColor.systemTeal
            
            // Configure the appearance for normal state (inactive)
            tabBarAppearance.stackedLayoutAppearance.normal.iconColor = UIColor.gray // Set inactive icon color
            tabBarAppearance.stackedLayoutAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.gray] // Set inactive title color
            
            // Configure the appearance for selected state (active)
            tabBarAppearance.stackedLayoutAppearance.selected.iconColor = UIColor.white // Set active icon color
            tabBarAppearance.stackedLayoutAppearance.selected.titleTextAttributes = [.foregroundColor: UIColor.white] // Set active title color
            
            // Apply the appearance settings
            UITabBar.appearance().standardAppearance = tabBarAppearance
            UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
        }

    var body: some View {
        TabView {
            JobCodeListView()
                .tabItem {
                    Label("Job Codes", systemImage: "list.bullet")
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
    }
}

#Preview {
        ContentView()
}
