//
//  NotificationsView.swift
//  TimecardApp
//
//  Created by Anastasia Runion on 11/22/24.
//

import SwiftUI

struct NotificationsView : View {
    
    var body: some View {
        NavigationView{
            List{
                Section(header: Text("General Notifications")) {
                    Toggle("Enable Nofitications", isOn: .constant(true))
                    Toggle("Daily Reminders", isOn: .constant(true))
                    Toggle("Missed Timecard Alerts", isOn: .constant(true))
                }
                
                Section(header: Text("Timecard Notifications")) {
                    Toggle("Enable Timecard Notifications", isOn: .constant(true))
                    Toggle("Timecard Reminders", isOn: .constant(true))
                    Toggle("Approval Updates", isOn: .constant(true))
                }
            }
            .navigationTitle("Notifications")
            .listStyle(InsetGroupedListStyle())
        }
    }
}
