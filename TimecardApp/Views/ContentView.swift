//
//  ContentView.swift
//  TimecardApp
//
//  Created by Damian Rozycki on 10/4/24.
//

import SwiftUI

struct ContentView: View {
    init() {
        // Customize the appearance of the tab bar
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .white // Set the tab bar background to white
        
        // Customize tab bar item appearance
        let itemAppearance = UITabBarItemAppearance()
        let selectedColor = UIColor.systemTeal
        let unselectedColor = UIColor.gray
        
        // Set colors for the selected state (teal)
        itemAppearance.selected.titleTextAttributes = [.foregroundColor: selectedColor]
        itemAppearance.selected.iconColor = selectedColor
        
        // Set colors for the unselected state (gray)
        itemAppearance.normal.titleTextAttributes = [.foregroundColor: unselectedColor]
        itemAppearance.normal.iconColor = unselectedColor
        
        appearance.stackedLayoutAppearance = itemAppearance
        
        UITabBar.appearance().standardAppearance = appearance
        
        // For iOS 15 and later, update the scrollEdgeAppearance as well
        if #available(iOS 15.0, *) {
            UITabBar.appearance().scrollEdgeAppearance = appearance
        }
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

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
