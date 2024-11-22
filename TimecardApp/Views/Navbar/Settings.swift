//
//  Settings.swift
//  TimecardApp
//
//  Created by Anastasia Runion on 11/22/24.
//


import SwiftUI

struct Settings: View {
    @ObservedObject var viewModel: TimecardListViewModel
    @State private var isManager = true // Example state for Manager
    @State private var isAdmin = true   // Example state for Admin
    
    var body: some View {
        NavigationView {
            List {
                // Shared among all
                Section(header: Text("Account Settings")) {
                    NavigationLink(destination: Text("EmployeeList")) {
                        HStack {
                            Image(systemName: "person.crop.circle")
                            Text("Employees")
                        }
                    }
                    NavigationLink(destination: Text("AddEmployee")) {
                        HStack {
                            Image(systemName: "person.crop.circle.badge.plus")
                            Text("Add Employee")
                        }
                    }
                    NavigationLink(destination: Text("Notifications")) {
                        HStack {
                            Image(systemName: "bell")
                            Text("Notifications")
                        }
                    }
                }
                
                // Manager-specific settings
                if isManager {
                    Section(header: Text("Manager Settings")) {
                        NavigationLink(destination: Text("Team Overview")) {
                            HStack {
                                Image(systemName: "person.2.fill")
                                Text("Team Overview")
                            }
                        }
                        NavigationLink(destination: Text("Approve Timecards")) {
                            HStack {
                                Image(systemName: "checkmark.circle.fill")
                                Text("Approve Timecards")
                            }
                        }
                        NavigationLink(destination: Text("Approve Leave Requests")) {
                            HStack {
                                Image(systemName: "checkmark")
                                Text("Approve Leave Requests")
                            }
                        }
                    }
                }
                
                // Admin-specific settings
                if isAdmin {
                    Section(header: Text("Admin Settings")) {
                        NavigationLink(destination: Text("Manage Employees")) {
                            HStack {
                                Image(systemName: "person.crop.circle.badge.plus")
                                Text("Manage Employees")
                            }
                        }
                        NavigationLink(destination: Text("Manage Timecards")) {
                            HStack {
                                Image(systemName: "calendar")
                                Text("Manage Timecards")
                            }
                        }
                        NavigationLink(destination: SystemsLogView(viewModel: viewModel)) { // Fixed initialization
                            HStack {
                                Image(systemName: "doc.text.magnifyingglass")
                                Text("System Logs")
                            }
                        }
                    }
                }
            }
            .navigationTitle("Settings")
        }
    }
}


//import SwiftUI
//
//struct Settings : View {
//    
//    var body: some View {
//        NavigationView{
//            List{
//                //Shared among all
//                Section(header: Text("Account Settings")) {
//                    
//                    NavigationLink(destination: Text("EmployeeList")) {
//                        HStack {
//                            Image(systemName: "person.crop.circle")
//                            Text("Employees")
//                        }
//                    }
//                    NavigationLink(destination: Text("AddEmployee")) {
//                        HStack {
//                            Image(systemName: "person.crop.circle.badge.plus")
//                            Text("Add Employee")
//                        }
//                    }
//                    NavigationLink(destination: Text("Notifications")) {
//                        HStack {
//                            Image(systemName: "bell")
//                            Text("Ae")
//                        }
//                    }
//                } //end of shared
//                
//                //Manager-specific settings
//                
//                // if isManager {
//                Section(header: Text("Manager Settings")) {
//                    NavigationLink(destination: Text("Team Overview")){
//                        Image(systemName: "person.2.fill")
//                        Text("Team Overview")
//                    }
//                    
//                    NavigationLink(destination: Text("Approve Timecards")){
//                        HStack
//                        {
//                            Image(systemName: "checkmark.circle.fill")
//                            Text("Approve Timecards")
//                        }
//                        
//                    }
//                    
//                    
//                    NavigationLink(destination: Text("Appove Leave Requests")){
//                        HStack{
//                            Image(systemName: "checkmark")
//                            Text("Approve Leave Requests")
//                        }
//                        
//                    }
//                    
//                } //ends manager
//                    
//                    // if isAdmin {
//                    Section(header: Text("Admin Settings")) {
//                        NavigationLink(destination: Text("Manage Employees")){
//                            Image(systemName: "person.crop.circle.badge.plus")
//                            Text("Manage Employees")
//                            
//                        }
//                        NavigationLink(destination: Text("Manage Timecards")){
//                            Image(systemName: "person.crop.circle.badge.plus")
//                            Text("Manage Timecards")
//                        }
//                        
//                        NavigationLink(destination: Text("System Logs")){
//                            HStack{
//                                Image(systemName: "doc.text.magnifyingglass")
//                                Text("System Logs")
//                            }
//                            
//                        }
//                        // }// end admin
//                    }
//                }
//                .navigationTitle("Settings")
//            }
//        }
//    }
//
