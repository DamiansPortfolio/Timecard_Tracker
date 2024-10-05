//
//  ContentView.swift
//  TimecardApp
//
//  Created by Damian Rozycki on 10/4/24.
//
import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            TimecardListView()
                .tabItem {
                    Label("Timecards", systemImage: "clock")
                }
            JobCodeListView()
                .tabItem {
                    Label("Job Codes", systemImage: "list.bullet")
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

