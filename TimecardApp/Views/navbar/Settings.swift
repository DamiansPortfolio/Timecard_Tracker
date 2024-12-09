//
//  Settings.swift
//  TimecardApp
//
//  Created by Anastasia Runion on 11/22/24.
//
//

//
//import SwiftUI
//
//struct Settings: View {
//    @ObservedObject var viewModel: TimecardListViewModel
//    @ObservedObject var leaveRequestViewModel: LeaveRequestViewModel = LeaveRequestViewModel()
//    @State private var isManager: Bool = UserDefaults.standard.bool(forKey: "isManager")
//    @State private var isAdmin: Bool = UserDefaults.standard.bool(forKey: "isAdmin")
//    @State private var userId: String = UserDefaults.standard.string(forKey: "userId") ?? ""
//
//    var body: some View {
//        NavigationView {
//            List {
//                // Shared Settings
//                Section(header: Text("Account Settings")) {
//                    NavigationLink(destination: AddLeaveRequests(viewModel: leaveRequestViewModel)) {
//                        HStack {
//                            Image(systemName: "calendar.badge.plus")
//                            Text("Request Leave")
//                        }
//                    }
//                    NavigationLink(destination: Text("Payroll")) {
//                        HStack {
//                            Image(systemName: "dollarsign.circle")
//                            Text("Manage Payroll")
//                        }
//                    }
//                    NavigationLink(destination: Text("Notifications")) {
//                        HStack {
//                            Image(systemName: "bell.badge")
//                            Text("Notifications | View Alerts & Updates")
//                        }
//                    }
//                }
//
//                // Manager-specific settings
//                if isManager {
//                    Section(header: Text("Manager Settings")) {
//                        NavigationLink(destination: Text("Team Overview")) {
//                            HStack {
//                                Image(systemName: "person.2.fill")
//                                Text("Team Overview")
//                            }
//                        }
//                        NavigationLink(destination: Text("Approve Timecards")) {
//                            HStack {
//                                Image(systemName: "checkmark.circle.fill")
//                                Text("Approve Timecards")
//                            }
//                        }
//                        NavigationLink(destination: Text("Approve Leave Requests")) {
//                            HStack {
//                                Image(systemName: "checkmark")
//                                Text("Approve Leave Requests")
//                            }
//                        }
//                    }
//                }
//
//                // Admin-specific settings
//                if isAdmin {
//                    Section(header: Text("Admin Settings")) {
//                        NavigationLink(destination: Text("Manage Employees")) {
//                            HStack {
//                                Image(systemName: "person.crop.circle.badge.plus")
//                                Text("Manage Employees")
//                            }
//                        }
//                        NavigationLink(destination: Text("Manage Timecards")) {
//                            HStack {
//                                Image(systemName: "calendar")
//                                Text("Manage Timecards")
//                            }
//                        }
//                        NavigationLink(destination: SystemsLogView(viewModel: viewModel)) {
//                            HStack {
//                                Image(systemName: "doc.text.magnifyingglass")
//                                Text("System Logs")
//                            }
//                        }
//                    }
//                }
//            }
//            .navigationTitle("Settings")
//        }
//        .onAppear {
//            updateRolesFromUserDefaults()
//        }
//    }
//
//    /// Updates the roles (`isManager`, `isAdmin`) from UserDefaults
//    private func updateRolesFromUserDefaults() {
//        self.isManager = UserDefaults.standard.bool(forKey: "isManager")
//        self.isAdmin = UserDefaults.standard.bool(forKey: "isAdmin")
//        self.userId = UserDefaults.standard.string(forKey: "userId") ?? ""
//    }
//}
//


import SwiftUI
import FirebaseFirestore

struct Settings: View {
    @ObservedObject var viewModel: TimecardListViewModel
    @ObservedObject var leaveRequestViewModel: LeaveRequestViewModel = LeaveRequestViewModel()
    
    @State private var isManager: Bool = UserDefaults.standard.bool(forKey: "isManager")
    @State private var isAdmin: Bool = UserDefaults.standard.bool(forKey: "isAdmin")
    @State private var isClockInOutEnabled: Bool = false
    @State private var isSelectHoursEnabled: Bool = false
    @State private var isLoading: Bool = true
    @State private var errorMessage: String?

    var body: some View {
        NavigationView {
            List {
                // Shared Settings
                Section(header: Text("Account Settings")) {
                    NavigationLink(destination: AddLeaveRequests(viewModel: leaveRequestViewModel)) {
                        HStack {
                            Image(systemName: "calendar.badge.plus")
                            Text("Request Leave")
                        }
                    }
                    NavigationLink(destination: Text("Payroll")) {
                        HStack {
                            Image(systemName: "dollarsign.circle")
                            Text("Manage Payroll")
                        }
                    }
                    NavigationLink(destination: Text("Notifications")) {
                        HStack {
                            Image(systemName: "bell.badge")
                            Text("Notifications | View Alerts & Updates")
                        }
                    }
                }

                // Manager-specific Settings
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

                // Admin-specific Settings
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
                        NavigationLink(destination: SystemsLogView(viewModel: viewModel)) {
                            HStack {
                                Image(systemName: "doc.text.magnifyingglass")
                                Text("System Logs")
                            }
                        }

                        // Timecard Mode Toggles
                        Toggle(isOn: $isClockInOutEnabled) {
                            HStack {
                                Image(systemName: "clock")
                                Text("Enable Clock In/Out")
                            }
                        }
                        .onChange(of: isClockInOutEnabled) { newValue in
                            if newValue {
                                isSelectHoursEnabled = false
                                saveToggleState(clockInOut: true, selectHours: false)
                            }
                        }

                        Toggle(isOn: $isSelectHoursEnabled) {
                            HStack {
                                Image(systemName: "hourglass")
                                Text("Enable Select Hours")
                            }
                        }
                        .onChange(of: isSelectHoursEnabled) { newValue in
                            if newValue {
                                isClockInOutEnabled = false
                                saveToggleState(clockInOut: false, selectHours: true)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Settings")
            .onAppear {
                fetchToggleStates()
                updateRolesFromUserDefaults()
            }
        }
    }

    // Fetch toggle states from Firestore
    private func fetchToggleStates() {
        let db = Firestore.firestore()
        let documentId = "timecardSettings" // Replace with your Firestore document ID

        db.collection("adminSettings").document(documentId).getDocument { snapshot, error in
            if let error = error {
                print("Error fetching toggle states: \(error.localizedDescription)")
                self.errorMessage = "Failed to fetch toggle states."
                self.isLoading = false
                return
            }

            guard let data = snapshot?.data() else {
                print("No data found for toggle states.")
                self.isLoading = false
                return
            }

            // Update the toggle states from Firestore
            self.isClockInOutEnabled = data["ClockInOutEnabled"] as? Bool ?? false
            self.isSelectHoursEnabled = data["SelectHoursEnabled"] as? Bool ?? false
            self.isLoading = false
        }
    }

    // Save the toggle state to Firestore
    private func saveToggleState(clockInOut: Bool, selectHours: Bool) {
        let db = Firestore.firestore()
        let documentId = "timecardSettings" // Replace with your Firestore document ID

        db.collection("adminSettings").document(documentId).setData([
            "ClockInOutEnabled": clockInOut,
            "SelectHoursEnabled": selectHours
        ], merge: true) { error in
            if let error = error {
                print("Error saving toggle states: \(error.localizedDescription)")
                self.errorMessage = "Failed to save toggle states."
            } else {
                print("Toggle states successfully saved: ClockInOut=\(clockInOut), SelectHours=\(selectHours)")
            }
        }
    }

    // Update roles (`isManager`, `isAdmin`) from UserDefaults
    private func updateRolesFromUserDefaults() {
        self.isManager = UserDefaults.standard.bool(forKey: "isManager")
        self.isAdmin = UserDefaults.standard.bool(forKey: "isAdmin")
    }
}
