//
//  ManagerDashboard.swift
//  TimecardApp
//
//  Created by Anastasia Runion on 11/17/24.
//


//import SwiftUI
//
//struct ManagerPersonalDashboardView: View {
//    @State private var isClockedIn = false
//    @State private var clockInTime: Date? = nil
//    @State private var clockOutTime: Date? = nil
//    @State private var breakStartTime: Date? = nil
//    @State private var totalWorkedTime: TimeInterval = 0
//    @State private var totalBreakTime: TimeInterval = 0
//    @State private var showTimetableSheet = false
//    @State private var showClockingSheet = false
//
//    var body: some View {
//        NavigationView {
//            ScrollView {
//                VStack(spacing: 20) {
//                    // Header Section
//                    VStack(alignment: .leading, spacing: 5) {
//                        Text("Welcome, John Doe")
//                            .font(.largeTitle)
//                            .bold()
//                        Text("Monday, November 20, 2024")
//                            .font(.subheadline)
//                            .foregroundColor(.gray)
//                    }
//                    .padding(.horizontal)
//
//                    // Quick Stats Section
//                    HStack(spacing: 15) {
//                        QuickStatCard(title: "Team Size", value: "10", icon: "person.2.fill")
//                        QuickStatCard(title: "Pending Approvals", value: "3", icon: "clock.fill")
//                        QuickStatCard(title: "Hours Logged", value: "120h", icon: "calendar")
//                    }
//                    .padding(.horizontal)
//
//                    // Manager Insights Section
//                    VStack(alignment: .leading, spacing: 10) {
//                        Text("Manager Insights")
//                            .font(.headline)
//                            .padding(.horizontal)
//
//                        NavigationLink(destination: TeamSummaryView()) {
//                            ActionRow(title: "View Team", subtitle: "Manage your employees", icon: "person.2")
//                        }
//
//                        NavigationLink(destination: PendingApprovalsView()) {
//                            ActionRow(title: "Approve Requests", subtitle: "Review timecards", icon: "checkmark.seal")
//                        }
//
//                        NavigationLink(destination: WeeklyScheduleView(scheduleTitle: "Manager's Weekly Schedule", shifts: [
//                            "Mon: 9 AM - 5 PM",
//                            "Tue: 10 AM - 6 PM",
//                            "Wed: 9 AM - 5 PM",
//                            "Thu: 11 AM - 7 PM",
//                            "Fri: 9 AM - 5 PM"
//                        ])) {
//                            ActionRow(title: "View Manager Schedule", subtitle: "Your weekly schedule", icon: "calendar")
//                        }
//
//                        NavigationLink(destination: EmployeeScheduleListView(employees: [
//                            EmployeeSchedule(name: "John", schedule: [
//                                "Mon: 10 AM - 6 PM",
//                                "Wed: 10 AM - 6 PM",
//                                "Fri: 10 AM - 6 PM"
//                            ]),
//                            EmployeeSchedule(name: "Jane", schedule: [
//                                "Mon: 12 PM - 8 PM",
//                                "Tue: 12 PM - 8 PM",
//                                "Thu: 12 PM - 8 PM",
//                                "Fri: 12 PM - 8 PM"
//                            ]),
//                            EmployeeSchedule(name: "Alice", schedule: [
//                                "Tue: 9 AM - 5 PM",
//                                "Wed: 9 AM - 5 PM",
//                                "Thu: 9 AM - 5 PM"
//                            ])
//                        ])) {
//                            ActionRow(title: "View Employee Schedule", subtitle: "Team weekly schedule", icon: "calendar.badge.person.crop")
//                        }
//                    }
//                    .padding()
//                    .background(Color(.systemGray6))
//                    .cornerRadius(12)
//                    .padding(.horizontal)
//
//                    // Recent Activity Section
//                    VStack(alignment: .leading, spacing: 10) {
//                        Text("Recent Activity")
//                            .font(.headline)
//                            .padding(.horizontal)
//
//                        ForEach(["John submitted a timecard", "Jane requested leave", "Alice updated her schedule"], id: \ .self) { activity in
//                            ActivityRow(activity: activity, time: "2h ago")
//                        }
//                    }
//                    .padding()
//                    .background(Color(.systemGray6))
//                    .cornerRadius(12)
//                    .padding(.horizontal)
//                }
//                .padding(.vertical)
//            }
//            .navigationTitle("Manager's Dashboard")
//        }
//    }
//}
//
//// Components
//struct QuickStatCard: View {
//    let title: String
//    let value: String
//    let icon: String
//
//    var body: some View {
//        VStack(spacing: 8) {
//            Image(systemName: icon)
//                .font(.largeTitle)
//                .foregroundColor(.blue)
//            Text(value)
//                .font(.title)
//                .bold()
//            Text(title)
//                .font(.subheadline)
//                .foregroundColor(.gray)
//        }
//        .frame(maxWidth: .infinity)
//        .padding()
//        .background(Color.white)
//        .cornerRadius(12)
//        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
//    }
//}
//
//struct ActionRow: View {
//    let title: String
//    let subtitle: String
//    let icon: String
//
//    var body: some View {
//        HStack {
//            Image(systemName: icon)
//                .font(.title2)
//                .foregroundColor(.blue)
//                .frame(width: 40, height: 40)
//
//            VStack(alignment: .leading) {
//                Text(title)
//                    .font(.headline)
//                Text(subtitle)
//                    .font(.subheadline)
//                    .foregroundColor(.gray)
//            }
//            Spacer()
//            Image(systemName: "chevron.right")
//                .foregroundColor(.gray)
//        }
//        .padding(.vertical, 8)
//    }
//}
//
//struct ActivityRow: View {
//    let activity: String
//    let time: String
//
//    var body: some View {
//        HStack {
//            VStack(alignment: .leading) {
//                Text(activity)
//                    .font(.body)
//                Text(time)
//                    .font(.caption)
//                    .foregroundColor(.gray)
//            }
//            Spacer()
//        }
//        .padding(.vertical, 8)
//    }
//}
//
//struct WeeklyScheduleView: View {
//    let scheduleTitle: String
//    let shifts: [String]
//
//    var body: some View {
//        VStack(spacing: 20) {
//            Text(scheduleTitle)
//                .font(.headline)
//                .padding()
//
//            HStack(spacing: 10) {
//                ForEach(["Mon", "Tue", "Wed", "Thu", "Fri"], id: \ .self) { day in
//                    VStack {
//                        Text(day)
//                            .font(.headline)
//                        RoundedRectangle(cornerRadius: 8)
//                            .fill(Color.blue)
//                            .frame(width: 50, height: 50)
//                    }
//                }
//            }
//
//            List {
//                Section(header: Text("Detailed Schedule")) {
//                    ForEach(shifts, id: \ .self) { shift in
//                        Text(shift)
//                    }
//                }
//            }
//            .listStyle(PlainListStyle())
//        }
//        .padding()
//        .navigationTitle(scheduleTitle)
//    }
//}
//
//struct EmployeeScheduleListView: View {
//    let employees: [EmployeeSchedule]
//
//    var body: some View {
//        List {
//            ForEach(employees) { employee in
//                Section(header: Text(employee.name)) {
//                    ForEach(employee.schedule, id: \ .self) { shift in
//                        Text(shift)
//                    }
//                }
//            }
//        }
//        .navigationTitle("Employee Schedules")
//    }
//}
//
//struct EmployeeSchedule: Identifiable {
//    let id = UUID()
//    let name: String
//    let schedule: [String]
//}
//
//struct PendingApprovalsView: View {
//    let approvals = ["Leave Request: John Smith", "Shift Change: Jane Doe"]
//
//    var body: some View {
//        Form {
//            Section(header: Text("Pending Approvals")) {
//                ForEach(approvals, id: \ .self) { approval in
//                    HStack {
//                        Text(approval)
//                        Spacer()
//                        Image(systemName: "clock.arrow.circlepath")
//                            .foregroundColor(.orange)
//                    }
//                }
//            }
//        }
//        .navigationTitle("Pending Approvals")
//    }
//}
//
//struct TeamSummaryView: View {
//    let employees = ["John Smith", "Jane Doe", "Alice Johnson"]
//    
//    var body: some View {
//        Form {
//            Section(header: Text("Team Members")) {
//                Section(header: Text("Team Members")) {
//                    ForEach(employees, id: \.self) { employee in
//                        NavigationLink(destination: EmployeeProfileView(employeeName: employee)) {
//                            HStack {
//                                Text(employee)
//                                Spacer()
//                                Image(systemName: "person.circle")
//                                    .foregroundColor(.blue)
//                            }
//                        }
//                    }
//                }
//            }
//            .navigationTitle("Team Summary")
//        }
//    }
//    
//    struct EmployeeProfileView: View {
//        let employeeName: String
//        
//        var body: some View {
//            VStack(alignment: .leading, spacing: 20) {
//                Text("Profile of \(employeeName)")
//                    .font(.largeTitle)
//                    .padding()
//                
//                Text("Details and performance metrics will be fetched from the database.")
//                    .font(.subheadline)
//                    .foregroundColor(.gray)
//                    .padding(.horizontal)
//                
//                Spacer()
//            }
//            .navigationTitle(employeeName)
//        }
//    }
//    
//    struct TimetableSheetView: View {
//        var body: some View {
//            NavigationView {
//                VStack {
//                    Text("Timetable for Today")
//                        .font(.headline)
//                        .padding(.top)
//                    
//                    List {
//                        Text("John Smith: 10:00 AM - 6:00 PM")
//                        Text("Jane Doe: 12:00 PM - 8:00 PM")
//                        Text("Alice Johnson: 9:00 AM - 5:00 PM")
//                    }
//                    .listStyle(PlainListStyle())
//                    
//                    Spacer()
//                }
//                .padding()
//                .navigationTitle("Timetable")
//                .navigationBarTitleDisplayMode(.inline)
//            }
//        }
//    }
//    
//    struct ManagerPersonalDashboardView_Previews: PreviewProvider {
//        static var previews: some View {
//            ManagerPersonalDashboardView()
//        }
//    }
//    
    
    //import SwiftUI
    //
    //struct ManagerPersonalDashboardView: View {
    //    @State private var isClockedIn = false
    //    @State private var clockInTime: Date? = nil
    //    @State private var clockOutTime: Date? = nil
    //    @State private var breakStartTime: Date? = nil
    //    @State private var totalWorkedTime: TimeInterval = 0
    //    @State private var totalBreakTime: TimeInterval = 0
    //    @State private var showTimetableSheet = false
    //    @State private var showClockingSheet = false
    //
    //    var body: some View {
    //        NavigationView {
    //            ScrollView {
    //                VStack(spacing: 20) {
    //                    // Header Section
    //                    VStack(alignment: .leading, spacing: 5) {
    //                        Text("Welcome, John Doe")
    //                            .font(.largeTitle)
    //                            .bold()
    //                        Text("Monday, November 20, 2024")
    //                            .font(.subheadline)
    //                            .foregroundColor(.gray)
    //                    }
    //                    .padding(.horizontal)
    //
    //                    // Quick Stats Section
    //                    HStack(spacing: 15) {
    //                        QuickStatCard(title: "Team Size", value: "10", icon: "person.2.fill")
    //                        QuickStatCard(title: "Pending Approvals", value: "3", icon: "clock.fill")
    //                        QuickStatCard(title: "Hours Logged", value: "120h", icon: "calendar")
    //                    }
    //                    .padding(.horizontal)
    //
    //                    // Manager Insights Section
    //                    VStack(alignment: .leading, spacing: 10) {
    //                        Text("Manager Insights")
    //                            .font(.headline)
    //                            .padding(.horizontal)
    //
    //                        NavigationLink(destination: TeamSummaryView()) {
    //                            ActionRow(title: "View Team", subtitle: "Manage your employees", icon: "person.2")
    //                        }
    //
    //                        NavigationLink(destination: PendingApprovalsView()) {
    //                            ActionRow(title: "Approve Requests", subtitle: "Review timecards", icon: "checkmark.seal")
    //                        }
    //
    //                        NavigationLink(destination: WeeklyScheduleView(scheduleTitle: "Manager's Weekly Schedule", shifts: [
    //                            "Mon: 9 AM - 5 PM",
    //                            "Tue: 10 AM - 6 PM",
    //                            "Wed: 9 AM - 5 PM",
    //                            "Thu: 11 AM - 7 PM",
    //                            "Fri: 9 AM - 5 PM"
    //                        ])) {
    //                            ActionRow(title: "View Manager Schedule", subtitle: "Your weekly schedule", icon: "calendar")
    //                        }
    //
    //                        NavigationLink(destination: WeeklyScheduleView(scheduleTitle: "Employee Weekly Schedule", shifts: [
    //                            "Mon: John 10 AM - 6 PM, Jane 12 PM - 8 PM",
    //                            "Tue: Alice 9 AM - 5 PM, Jane 12 PM - 8 PM",
    //                            "Wed: John 10 AM - 6 PM, Alice 9 AM - 5 PM",
    //                            "Thu: Jane 12 PM - 8 PM, Alice 9 AM - 5 PM",
    //                            "Fri: John 10 AM - 6 PM, Jane 12 PM - 8 PM"
    //                        ])) {
    //                            ActionRow(title: "View Employee Schedule", subtitle: "Team weekly schedule", icon: "calendar.badge.person.crop")
    //                        }
    //                    }
    //                    .padding()
    //                    .background(Color(.systemGray6))
    //                    .cornerRadius(12)
    //                    .padding(.horizontal)
    //
    //                    // Recent Activity Section
    //                    VStack(alignment: .leading, spacing: 10) {
    //                        Text("Recent Activity")
    //                            .font(.headline)
    //                            .padding(.horizontal)
    //
    //                        ForEach(["John submitted a timecard", "Jane requested leave", "Alice updated her schedule"], id: \ .self) { activity in
    //                            ActivityRow(activity: activity, time: "2h ago")
    //                        }
    //                    }
    //                    .padding()
    //                    .background(Color(.systemGray6))
    //                    .cornerRadius(12)
    //                    .padding(.horizontal)
    //                }
    //                .padding(.vertical)
    //            }
    //            //.navigationTitle("Manager's Dashboard")
    //        }
    //    }
    //}
    //
    //// Components
    //struct QuickStatCard: View {
    //    let title: String
    //    let value: String
    //    let icon: String
    //
    //    var body: some View {
    //        VStack(spacing: 8) {
    //            Image(systemName: icon)
    //                .font(.largeTitle)
    //                .foregroundColor(.blue)
    //            Text(value)
    //                .font(.title)
    //                .bold()
    //            Text(title)
    //                .font(.subheadline)
    //                .foregroundColor(.gray)
    //        }
    //        .frame(maxWidth: .infinity)
    //        .padding()
    //        .background(Color.white)
    //        .cornerRadius(12)
    //        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
    //    }
    //}
    //
    //struct ActionRow: View {
    //    let title: String
    //    let subtitle: String
    //    let icon: String
    //
    //    var body: some View {
    //        HStack {
    //            Image(systemName: icon)
    //                .font(.title2)
    //                .foregroundColor(.blue)
    //                .frame(width: 40, height: 40)
    //
    //            VStack(alignment: .leading) {
    //                Text(title)
    //                    .font(.headline)
    //                Text(subtitle)
    //                    .font(.subheadline)
    //                    .foregroundColor(.gray)
    //            }
    //            Spacer()
    //            Image(systemName: "chevron.right")
    //                .foregroundColor(.gray)
    //        }
    //        .padding(.vertical, 8)
    //    }
    //}
    //
    //struct ActivityRow: View {
    //    let activity: String
    //    let time: String
    //
    //    var body: some View {
    //        HStack {
    //            VStack(alignment: .leading) {
    //                Text(activity)
    //                    .font(.body)
    //                Text(time)
    //                    .font(.caption)
    //                    .foregroundColor(.gray)
    //            }
    //            Spacer()
    //        }
    //        .padding(.vertical, 8)
    //    }
    //}
    //
    //struct WeeklyScheduleView: View {
    //    let scheduleTitle: String
    //    let shifts: [String]
    //
    //    var body: some View {
    //        VStack(spacing: 20) {
    //            Text(scheduleTitle)
    //                .font(.headline)
    //                .padding()
    //
    //            HStack(spacing: 10) {
    //                ForEach(["Mon", "Tue", "Wed", "Thu", "Fri"], id: \ .self) { day in
    //                    VStack {
    //                        Text(day)
    //                            .font(.headline)
    //                        RoundedRectangle(cornerRadius: 8)
    //                            .fill(Color.blue)
    //                            .frame(width: 50, height: 50)
    //                    }
    //                }
    //            }
    //
    //            List {
    //                Section(header: Text("Detailed Schedule")) {
    //                    ForEach(shifts, id: \ .self) { shift in
    //                        Text(shift)
    //                    }
    //                }
    //            }
    //            .listStyle(PlainListStyle())
    //        }
    //        .padding()
    //        .navigationTitle(scheduleTitle)
    //    }
    //}
    //
    //struct PendingApprovalsView: View {
    //    let approvals = ["Leave Request: John Smith", "Shift Change: Jane Doe"]
    //
    //    var body: some View {
    //        Form {
    //            Section(header: Text("Pending Approvals")) {
    //                ForEach(approvals, id: \ .self) { approval in
    //                    HStack {
    //                        Text(approval)
    //                        Spacer()
    //                        Image(systemName: "clock.arrow.circlepath")
    //                            .foregroundColor(.orange)
    //                    }
    //                }
    //            }
    //        }
    //        .navigationTitle("Pending Approvals")
    //    }
    //}
    //
    //struct TeamSummaryView: View {
    //    let employees = ["John Smith", "Jane Doe", "Alice Johnson"]
    //
    //    var body: some View {
    //        Form {
    //            Section(header: Text("Team Members")) {
    //                ForEach(employees, id: \ .self) { employee in
    //                    NavigationLink(destination: EmployeeProfileView(employeeName: employee)) {
    //                        HStack {
    //                            Text(employee)
    //                            Spacer()
    //                            Image(systemName: "person.circle")
    //                                .foregroundColor(.blue)
    //                        }
    //                    }
    //                }
    //            }
    //        }
    //        .navigationTitle("Team Summary")
    //    }
    //}
    //
    //struct EmployeeProfileView: View {
    //    let employeeName: String
    //
    //    var body: some View {
    //        VStack(alignment: .leading, spacing: 20) {
    //            Text("Profile of \(employeeName)")
    //                .font(.largeTitle)
    //                .padding()
    //
    //            Text("Details and performance metrics will be fetched from the database.")
    //
    //                .foregroundColor(.gray)
    //                .padding()
    //
    //            Spacer()
    //        }
    //        .navigationTitle(employeeName)
    //    }
    //}
    //
    //struct TimetableSheetView: View {
    //    var body: some View {
    //        NavigationView {
    //            VStack {
    //                Text("Timetable for Today")
    //                    .font(.headline)
    //                    .padding(.top)
    //
    //                List {
    //                    Text("John Smith: 10:00 AM - 6:00 PM")
    //                    Text("Jane Doe: 12:00 PM - 8:00 PM")
    //                    Text("Alice Johnson: 9:00 AM - 5:00 PM")
    //                }
    //                .listStyle(PlainListStyle())
    //
    //                Spacer()
    //            }
    //            .padding()
    //            .navigationTitle("Timetable")
    //            .navigationBarTitleDisplayMode(.inline)
    //        }
    //    }
    //}
    //
    //struct ManagerPersonalDashboardView_Previews: PreviewProvider {
    //    static var previews: some View {
    //        ManagerPersonalDashboardView()
    //    }
    //}
    
    
    //
    //import SwiftUI
    //
    //struct ManagerPersonalDashboardView: View {
    //    @State private var isClockedIn = false
    //    @State private var clockInTime: Date? = nil
    //    @State private var clockOutTime: Date? = nil
    //    @State private var breakStartTime: Date? = nil
    //    @State private var totalWorkedTime: TimeInterval = 0
    //    @State private var totalBreakTime: TimeInterval = 0
    //    @State private var showTimetableSheet = false
    //    @State private var showClockingSheet = false
    //
    //    var body: some View {
    //        NavigationView {
    //            ScrollView {
    //                VStack(spacing: 20) {
    //                    // Manager Insights
    //                    Section(header: Text("Manager Insights").font(.headline)) {
    //                        ZStack {
    //                            RoundedRectangle(cornerRadius: 10)
    //                                .fill(Color.white.opacity(0.2))
    //                                .shadow(radius: 5)
    //
    //                            VStack(alignment: .leading, spacing: 15) {
    //                                // Team Summary
    //                                NavigationLink(destination: TeamSummaryView()) {
    //                                    HStack {
    //                                        VStack(alignment: .leading, spacing: 5) {
    //                                            Text("Team Summary").font(.headline)
    //                                            Text("Clocked In: 5").font(.subheadline)
    //                                            Text("Scheduled: 12").font(.subheadline)
    //                                        }
    //                                        Spacer()
    //                                        Image(systemName: "chevron.right")
    //                                            .foregroundColor(.gray)
    //                                    }
    //                                    .padding()
    //                                    .background(Color.white.opacity(0.9))
    //                                    .cornerRadius(10)
    //                                }
    //
    //                                Divider()
    //
    //                                // Pending Approvals
    //                                NavigationLink(destination: PendingApprovalsView()) {
    //                                    HStack {
    //                                        VStack(alignment: .leading, spacing: 5) {
    //                                            Text("Pending Approvals").font(.headline)
    //                                            Text("Leave Requests: 3").font(.subheadline)
    //                                            Text("Shift Changes: 2").font(.subheadline)
    //                                        }
    //                                        Spacer()
    //                                        Image(systemName: "chevron.right")
    //                                            .foregroundColor(.gray)
    //                                    }
    //                                    .padding()
    //                                    .background(Color.white.opacity(0.9))
    //                                    .cornerRadius(10)
    //                                }
    //
    //                                Divider()
    //
    //                                // Upcoming Shifts
    //                                NavigationLink(destination: UpcomingShiftsView()) {
    //                                    HStack {
    //                                        VStack(alignment: .leading, spacing: 5) {
    //                                            Text("Upcoming Shifts").font(.headline)
    //                                            Text("John Smith: 10 AM - 6 PM").font(.subheadline)
    //                                            Text("Jane Doe: 12 PM - 8 PM").font(.subheadline)
    //                                        }
    //                                        Spacer()
    //                                        Image(systemName: "chevron.right")
    //                                            .foregroundColor(.gray)
    //                                    }
    //                                    .padding()
    //                                    .background(Color.white.opacity(0.9))
    //                                    .cornerRadius(10)
    //                                }
    //
    //                                Divider()
    //
    //                                // Performance Alerts
    //                                NavigationLink(destination: PerformanceAlertsView()) {
    //                                    HStack {
    //                                        VStack(alignment: .leading, spacing: 5) {
    //                                            Text("Performance Alerts").font(.headline)
    //                                            Text("3 Late Arrivals This Week").font(.subheadline)
    //                                            Text("2 Missed Shifts").font(.subheadline)
    //                                        }
    //                                        Spacer()
    //                                        Image(systemName: "chevron.right")
    //                                            .foregroundColor(.gray)
    //                                    }
    //                                    .padding()
    //                                    .background(Color.white.opacity(0.9))
    //                                    .cornerRadius(10)
    //                                }
    //                            }
    //                            .padding()
    //                        }
    //                    }
    //
    //                    // Clock In/Out Button
    //                    Button(action: {
    //                        showClockingSheet.toggle()
    //                    }) {
    //                        Text(isClockedIn ? "Clock Out" : "Clock In")
    //                            .font(.title)
    //                            .padding()
    //                            .frame(maxWidth: .infinity)
    //                            .background(isClockedIn ? Color.red : Color.green)
    //                            .foregroundColor(.white)
    //                            .cornerRadius(10)
    //                    }
    //                    .sheet(isPresented: $showClockingSheet) {
    //                        ClockingSheet(
    //                            isClockedIn: $isClockedIn,
    //                            clockInTime: $clockInTime,
    //                            clockOutTime: $clockOutTime,
    //                            breakStartTime: $breakStartTime,
    //                            totalWorkedTime: $totalWorkedTime,
    //                            totalBreakTime: $totalBreakTime
    //                        )
    //                    }
    //
    //                    // Timetable Section
    //                    Button(action: { showTimetableSheet.toggle() }) {
    //                        Text("View Timetable")
    //                            .font(.title2)
    //                            .padding()
    //                            .frame(maxWidth: .infinity)
    //                            .background(Color.blue)
    //                            .foregroundColor(.white)
    //                            .cornerRadius(10)
    //                    }
    //                    .sheet(isPresented: $showTimetableSheet) {
    //                        TimetableSheetView()
    //                    }
    //                }
    //                .padding()
    //            }
    //            .background(Color.teal.opacity(0.2))
    //            .navigationTitle("Manager's Dashboard")
    //        }
    //    }
    //}
    //
    //// Detail Views for Navigation
    //
    //struct TeamSummaryView: View {
    //    let employees = ["John Smith", "Jane Doe", "Alice Johnson"]
    //
    //    var body: some View {
    //        Form {
    //            Section(header: Text("Team Members")) {
    //                ForEach(employees, id: \ .self) { employee in
    //                    NavigationLink(destination: EmployeeProfileView(employeeName: employee)) {
    //                        HStack {
    //                            Text(employee)
    //                            Spacer()
    //                            Image(systemName: "person.circle")
    //                                .foregroundColor(.blue)
    //                        }
    //                    }
    //                }
    //            }
    //        }
    //        .navigationTitle("Team Summary")
    //    }
    //}
    //
    //struct PendingApprovalsView: View {
    //    let approvals = ["Leave Request: John Smith", "Shift Change: Jane Doe"]
    //
    //    var body: some View {
    //        Form {
    //            Section(header: Text("Pending Approvals")) {
    //                ForEach(approvals, id: \ .self) { approval in
    //                    HStack {
    //                        Text(approval)
    //                        Spacer()
    //                        Image(systemName: "clock.arrow.circlepath")
    //                            .foregroundColor(.orange)
    //                    }
    //                }
    //            }
    //        }
    //        .navigationTitle("Pending Approvals")
    //    }
    //}
    //
    //struct UpcomingShiftsView: View {
    //    let shifts = [
    //        "John Smith: 10:00 AM - 6:00 PM",
    //        "Jane Doe: 12:00 PM - 8:00 PM",
    //        "Alice Johnson: 9:00 AM - 5:00 PM"
    //    ]
    //
    //    var body: some View {
    //        Form {
    //            Section(header: Text("Upcoming Shifts")) {
    //                ForEach(shifts, id: \ .self) { shift in
    //                    HStack {
    //                        Text(shift)
    //                        Spacer()
    //                        Image(systemName: "calendar")
    //                            .foregroundColor(.green)
    //                    }
    //                }
    //            }
    //        }
    //        .navigationTitle("Upcoming Shifts")
    //    }
    //}
    //
    //struct PerformanceAlertsView: View {
    //    let alerts = [
    //        "Late Arrival: John Smith (3 times)",
    //        "Missed Shift: Jane Doe (2 times)"
    //    ]
    //
    //    var body: some View {
    //        Form {
    //            Section(header: Text("Performance Alerts")) {
    //                ForEach(alerts, id: \ .self) { alert in
    //                    HStack {
    //                        Text(alert)
    //                        Spacer()
    //                        Image(systemName: "exclamationmark.triangle")
    //                            .foregroundColor(.red)
    //                    }
    //                }
    //            }
    //        }
    //        .navigationTitle("Performance Alerts")
    //    }
    //}
    //
    //struct EmployeeProfileView: View {
    //    let employeeName: String
    //
    //    var body: some View {
    //        VStack(alignment: .leading, spacing: 20) {
    //            Text("Profile of \(employeeName)")
    //                .font(.largeTitle)
    //                .padding()
    //
    //            Text("Details and performance metrics will be fetched from the database.")
    //                .font(.subheadline)
    //                .foregroundColor(.gray)
    //                .padding(.horizontal)
    //
    //            Spacer()
    //        }
    //        .navigationTitle(employeeName)
    //    }
    //}
    //
    //struct TimetableSheetView: View {
    //    var body: some View {
    //        NavigationView {
    //            VStack {
    //                Text("Timetable for Today")
    //                    .font(.headline)
    //                    .padding(.top)
    //
    //                List {
    //                    Text("John Smith: 10:00 AM - 6:00 PM")
    //                    Text("Jane Doe: 12:00 PM - 8:00 PM")
    //                    Text("Alice Johnson: 9:00 AM -5:00 PM")
    //                }
    //                .listStyle(PlainListStyle())
    //
    //                Spacer()
    //            }
    //            .padding()
    //            .navigationTitle("Timetable")
    //            .navigationBarTitleDisplayMode(.inline)
    //        }
    //    }
    //}
    //
    //struct ManagerPersonalDashboard_View: PreviewProvider {
    //    static var previews: some View {
    //        ManagerPersonalDashboardView()
    //    }
    //}
    //
    //#Preview {
    //    ManagerPersonalDashboardView()
    //}
    
    
    
    //import SwiftUI
    //
    //struct ManagerPersonalDashboardView: View {
    //    @State private var isClockedIn = false
    //    @State private var clockInTime: Date? = nil
    //    @State private var clockOutTime: Date? = nil
    //    @State private var breakStartTime: Date? = nil
    //    @State private var totalWorkedTime: TimeInterval = 0
    //    @State private var totalBreakTime: TimeInterval = 0
    //    @State private var showTimetableSheet = false
    //    @State private var showClockingSheet = false
    //
    //    var body: some View {
    //        NavigationView {
    //            ScrollView {
    //                VStack(spacing: 20) {
    //                    // Manager Insights Section
    //                    HStack(spacing: 10) {
    //                        InsightCard(title: "Team Size", value: "2", icon: "person.2.fill", color: .blue)
    //                        InsightCard(title: "Pending", value: "0", icon: "exclamationmark.circle.fill", color: .orange)
    //                        InsightCard(title: "This Week", value: "32.0h", icon: "clock.fill", color: .green)
    //                    }
    //
    //                    // Quick Actions Section
    //                    VStack(alignment: .leading, spacing: 10) {
    //                        Text("Quick Actions")
    //                            .font(.headline)
    //                            .padding(.horizontal)
    //
    //                        ActionRow(title: "View Team", subtitle: "Manage your employees", icon: "person.2", actionText: "2 Members", actionColor: .blue) {
    //                            // Navigate to Team Summary
    //                        }
    //
    //                        ActionRow(title: "Pending Approvals", subtitle: "Review timecards", icon: "exclamationmark.circle", actionText: "0", actionColor: .orange) {
    //                            // Navigate to Pending Approvals
    //                        }
    //                    }
    //                    .background(Color.white)
    //                    .cornerRadius(10)
    //                    .shadow(radius: 5)
    //                    .padding(.horizontal)
    //
    //                    // Recent Activity Section
    //                    VStack(alignment: .leading, spacing: 10) {
    //                        Text("Recent Activity")
    //                            .font(.headline)
    //                            .padding(.horizontal)
    //
    //                        ForEach(0..<3) { _ in
    //                            RecentActivityRow(employeeName: "John Doe", activity: "Submitted timecard", timeAgo: "2h ago")
    //                        }
    //                    }
    //                    .background(Color.white)
    //                    .cornerRadius(10)
    //                    .shadow(radius: 5)
    //                    .padding(.horizontal)
    //                }
    //                .padding(.top)
    //            }
    //            .background(Color(.systemGroupedBackground))
    //            .navigationTitle("Dashboard")
    //        }
    //    }
    //}
    //
    //// Custom Card for Insights
    //struct InsightCard: View {
    //    let title: String
    //    let value: String
    //    let icon: String
    //    let color: Color
    //
    //    var body: some View {
    //        VStack(spacing: 8) {
    //            Image(systemName: icon)
    //                .font(.title)
    //                .foregroundColor(color)
    //            Text(value)
    //                .font(.title2)
    //                .fontWeight(.bold)
    //            Text(title)
    //                .font(.subheadline)
    //                .foregroundColor(.gray)
    //        }
    //        .frame(maxWidth: .infinity)
    //        .padding()
    //        .background(Color.white)
    //        .cornerRadius(10)
    //        .shadow(radius: 5)
    //    }
    //}
    //
    //// Custom Row for Quick Actions
    //struct ActionRow: View {
    //    let title: String
    //    let subtitle: String
    //    let icon: String
    //    let actionText: String
    //    let actionColor: Color
    //    let action: () -> Void
    //
    //    var body: some View {
    //        HStack {
    //            Image(systemName: icon)
    //                .font(.title2)
    //                .foregroundColor(.gray)
    //                .frame(width: 40, height: 40)
    //
    //            VStack(alignment: .leading, spacing: 4) {
    //                Text(title)
    //                    .font(.headline)
    //                Text(subtitle)
    //                    .font(.subheadline)
    //                    .foregroundColor(.gray)
    //            }
    //
    //            Spacer()
    //
    //            Button(action: action) {
    //                Text(actionText)
    //                    .font(.subheadline)
    //                    .foregroundColor(actionColor)
    //            }
    //        }
    //        .padding()
    //    }
    //}
    //
    //// Custom Row for Recent Activity
    //struct RecentActivityRow: View {
    //    let employeeName: String
    //    let activity: String
    //    let timeAgo: String
    //
    //    var body: some View {
    //        HStack(spacing: 12) {
    //            Image(systemName: "person.circle")
    //                .font(.title)
    //                .foregroundColor(.blue)
    //
    //            VStack(alignment: .leading, spacing: 4) {
    //                Text(employeeName)
    //                    .font(.headline)
    //                Text(activity)
    //                    .font(.subheadline)
    //                    .foregroundColor(.gray)
    //            }
    //
    //            Spacer()
    //
    //            Text(timeAgo)
    //                .font(.subheadline)
    //                .foregroundColor(.gray)
    //        }
    //        .padding()
    //    }
    //}
    //
    //#Preview {
    //    ManagerPersonalDashboardView()
    //}
    
    
    //
    //import SwiftUI
    //
    //struct ManagerPersonalDashboardView: View {
    //    @State private var isClockedIn = false
    //    @State private var clockInTime: Date? = nil
    //    @State private var clockOutTime: Date? = nil
    //    @State private var showClockingSheet = false
    //
    //    var body: some View {
    //        NavigationView {
    //            ScrollView {
    //                VStack(spacing: 20) {
    //                    // Manager Insights
    //                    Section(header: Text("Manager Insights").font(.headline)) {
    //                        VStack(spacing: 15) {
    //                            // Team Summary
    //                            NavigationLink(destination: TeamSummaryView()) {
    //                                InsightRow(title: "Team Summary", details: ["Clocked In: 5", "Scheduled: 12"])
    //                            }
    //
    //                            Divider()
    //
    //                            // Weekly Work Shifts
    //                            NavigationLink(destination: WeeklyWorkShiftView()) {
    //                                InsightRow(title: "Weekly Work Shifts", details: ["Days: Mon - Fri"])
    //                            }
    //                        }
    //                    }
    //
    //                    // Clock In/Out Button
    //                    Button(action: {
    //                        showClockingSheet.toggle()
    //                    }) {
    //                        Text(isClockedIn ? "Clock Out" : "Clock In")
    //                            .font(.title)
    //                            .padding()
    //                            .frame(maxWidth: .infinity)
    //                            .background(isClockedIn ? Color.red : Color.green)
    //                            .foregroundColor(.white)
    //                            .cornerRadius(10)
    //                    }
    //                    .sheet(isPresented: $showClockingSheet) {
    //                        ClockingSheetView(
    //                            isClockedIn: $isClockedIn,
    //                            clockInTime: $clockInTime,
    //                            clockOutTime: $clockOutTime
    //                        )
    //                    }
    //                }
    //                .padding()
    //            }
    //            .navigationTitle("Manager's Dashboard")
    //        }
    //    }
    //}
    //
    //// Detail Views
    //struct TeamSummaryView: View {
    //    var body: some View {
    //        List {
    //            Section(header: Text("Team Members")) {
    //                ForEach(["John Smith", "Jane Doe", "Alice Johnson"], id: \ .self) { employee in
    //                    Text(employee)
    //                }
    //            }
    //        }
    //        .navigationTitle("Team Summary")
    //    }
    //}
    //
    //struct WeeklyWorkShiftView: View {
    //    let days = ["Mon", "Tue", "Wed", "Thu", "Fri"]
    //    let shifts = [
    //        "John Smith: 10 AM - 6 PM",
    //        "Jane Doe: 12 PM - 8 PM",
    //        "Alice Johnson: 9 AM - 5 PM"
    //    ]
    //
    //    var body: some View {
    //        VStack(spacing: 20) {
    //            // Weekly Overview
    //            HStack(spacing: 10) {
    //                ForEach(days, id: \ .self) { day in
    //                    VStack {
    //                        Text(day)
    //                            .font(.headline)
    //                        Image(systemName: Bool.random() ? "checkmark.circle.fill" : "xmark.circle.fill")
    //                            .foregroundColor(Bool.random() ? .green : .red)
    //                    }
    //                }
    //            }
    //            .padding()
    //
    //            // Scheduled Shifts
    //            List {
    //                Section(header: Text("Scheduled Shifts")) {
    //                    ForEach(shifts, id: \ .self) { shift in
    //                        Text(shift)
    //                    }
    //                }
    //            }
    //        }
    //        .padding()
    //        .navigationTitle("Weekly Work Shifts")
    //    }
    //}
    //
    //struct InsightRow: View {
    //    let title: String
    //    let details: [String]
    //
    //    var body: some View {
    //        HStack {
    //            VStack(alignment: .leading, spacing: 5) {
    //                Text(title).font(.headline)
    //                ForEach(details, id: \ .self) { detail in
    //                    Text(detail).font(.subheadline)
    //                }
    //            }
    //            Spacer()
    //            Image(systemName: "chevron.right")
    //                .foregroundColor(.gray)
    //        }
    //        .padding()
    //        .background(Color.white)
    //        .cornerRadius(10)
    //        .shadow(radius: 2)
    //    }
    //}
    //
    //struct ClockingSheetView: View {
    //    @Binding var isClockedIn: Bool
    //    @Binding var clockInTime: Date?
    //    @Binding var clockOutTime: Date?
    //
    //    var body: some View {
    //        VStack {
    //            Text(isClockedIn ? "Clock Out" : "Clock In")
    //                .font(.largeTitle)
    //                .padding()
    //
    //            Button(action: {
    //                if isClockedIn {
    //                    clockOutTime = Date()
    //                } else {
    //                    clockInTime = Date()
    //                }
    //                isClockedIn.toggle()
    //            }) {
    //                Text(isClockedIn ? "Confirm Clock Out" : "Confirm Clock In")
    //                    .font(.title2)
    //                    .padding()
    //                    .frame(maxWidth: .infinity)
    //                    .background(isClockedIn ? Color.red : Color.green)
    //                    .foregroundColor(.white)
    //                    .cornerRadius(10)
    //            }
    //            .padding()
    //
    //            Spacer()
    //        }
    //        .padding()
    //    }
    //}
    //
    //struct ManagerPersonalDashboardView_Previews: PreviewProvider {
    //    static var previews: some View {
    //        ManagerPersonalDashboardView()
    //    }
    //}
    
    
    
    import SwiftUI
    
    struct ManagerPersonalDashboardView: View {
        @State private var isClockedIn = false
        @State private var clockInTime: Date? = nil
        @State private var clockOutTime: Date? = nil
        @State private var breakStartTime: Date? = nil
        @State private var totalWorkedTime: TimeInterval = 0
        @State private var totalBreakTime: TimeInterval = 0
        @State private var showTimetableSheet = false
        @State private var showClockingSheet = false
    
        var body: some View {
            NavigationView {
                ScrollView {
                    VStack(spacing: 20) {
                        // Manager Insights
                        Section(header: Text("Manager Insights").font(.headline)) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color.white.opacity(0.2))
                                    .shadow(radius: 5)
    
                                VStack(alignment: .leading, spacing: 15) {
                                    // Team Summary
                                    NavigationLink(destination: TeamSummaryView()) {
                                        HStack {
                                            VStack(alignment: .leading, spacing: 5) {
                                                Text("Team Summary").font(.headline)
                                                Text("Clocked In: 5").font(.subheadline)
                                                Text("Scheduled: 12").font(.subheadline)
                                            }
                                            Spacer()
                                            Image(systemName: "chevron.right")
                                                .foregroundColor(.gray)
                                        }
                                        .padding()
                                        .background(Color.white.opacity(0.9))
                                        .cornerRadius(10)
                                    }
    
                                    Divider()
    
                                    // Pending Approvals
                                    NavigationLink(destination: PendingApprovalsView()) {
                                        HStack {
                                            VStack(alignment: .leading, spacing: 5) {
                                                Text("Pending Approvals").font(.headline)
                                                Text("Leave Requests: 3").font(.subheadline)
                                                Text("Shift Changes: 2").font(.subheadline)
                                            }
                                            Spacer()
                                            Image(systemName: "chevron.right")
                                                .foregroundColor(.gray)
                                        }
                                        .padding()
                                        .background(Color.white.opacity(0.9))
                                        .cornerRadius(10)
                                    }
    
                                    Divider()
    
                                    // Manager's Weekly Schedule
                                    NavigationLink(destination: WeeklyScheduleView(scheduleTitle: "Manager's Weekly Schedule")) {
                                        HStack {
                                            VStack(alignment: .leading, spacing: 5) {
                                                Text("Manager's Weekly Schedule").font(.headline)
                                                Text("Days: Mon - Fri").font(.subheadline)
                                            }
                                            Spacer()
                                            Image(systemName: "chevron.right")
                                                .foregroundColor(.gray)
                                        }
                                        .padding()
                                        .background(Color.white.opacity(0.9))
                                        .cornerRadius(10)
                                    }
    
                                    Divider()
    
                                    // Employee Weekly Schedule
                                    NavigationLink(destination: WeeklyScheduleView(scheduleTitle: "Employee Weekly Schedule")) {
                                        HStack {
                                            VStack(alignment: .leading, spacing: 5) {
                                                Text("Employee Weekly Schedule").font(.headline)
                                                Text("Days: Mon - Fri").font(.subheadline)
                                            }
                                            Spacer()
                                            Image(systemName: "chevron.right")
                                                .foregroundColor(.gray)
                                        }
                                        .padding()
                                        .background(Color.white.opacity(0.9))
                                        .cornerRadius(10)
                                    }
    
                                    Divider()
    
                                    // Performance Alerts
                                    NavigationLink(destination: PerformanceAlertsView()) {
                                        HStack {
                                            VStack(alignment: .leading, spacing: 5) {
                                                Text("Performance Alerts").font(.headline)
                                                Text("3 Late Arrivals This Week").font(.subheadline)
                                                Text("2 Missed Shifts").font(.subheadline)
                                            }
                                            Spacer()
                                            Image(systemName: "chevron.right")
                                                .foregroundColor(.gray)
                                        }
                                        .padding()
                                        .background(Color.white.opacity(0.9))
                                        .cornerRadius(10)
                                    }
                                }
                                .padding()
                            }
                        }
    
                        // Clock In/Out Button
                        Button(action: {
                            showClockingSheet.toggle()
                        }) {
                            Text(isClockedIn ? "Clock Out" : "Clock In")
                                .font(.title)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(isClockedIn ? Color.red : Color.green)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                        .sheet(isPresented: $showClockingSheet) {
                            ClockingSheet(
                                isClockedIn: $isClockedIn,
                                clockInTime: $clockInTime,
                                clockOutTime: $clockOutTime,
                                breakStartTime: $breakStartTime,
                                totalWorkedTime: $totalWorkedTime,
                                totalBreakTime: $totalBreakTime
                            )
                        }
    
                        // Timetable Section
                        Button(action: { showTimetableSheet.toggle() }) {
                            Text("View Timetable")
                                .font(.title2)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                        .sheet(isPresented: $showTimetableSheet) {
                            TimetableSheetView()
                        }
                    }
                    .padding()
                }
                .background(Color.teal.opacity(0.2))
                .navigationTitle("Manager's Dashboard")
            }
        }
    }
    
    struct WeeklyScheduleView: View {
        let scheduleTitle: String
    
        let days = ["Mon", "Tue", "Wed", "Thu", "Fri"]
        let shifts = [
            "John Smith: 10 AM - 6 PM",
            "Jane Doe: 12 PM - 8 PM",
            "Alice Johnson: 9 AM - 5 PM"
        ]
    
        var body: some View {
            VStack(spacing: 20) {
                Text(scheduleTitle)
                    .font(.headline)
                    .padding()
    
                HStack(spacing: 10) {
                    ForEach(days, id: \ .self) { day in
                        VStack {
                            Text(day)
                                .font(.headline)
                            Image(systemName: Bool.random() ? "checkmark.circle.fill" : "xmark.circle.fill")
                                .foregroundColor(Bool.random() ? .green : .red)
                        }
                    }
                }
                .padding()
    
                List {
                    Section(header: Text("Scheduled Shifts")) {
                        ForEach(shifts, id: \ .self) { shift in
                            Text(shift)
                        }
                    }
                }
            }
            .padding()
            .navigationTitle(scheduleTitle)
        }
    }
    //
    //struct ClockingSheet: View {
    //    @Binding var isClockedIn: Bool
    //    @Binding var clockInTime: Date?
    //    @Binding var clockOutTime: Date?
    //    @Binding var breakStartTime: Date?
    //    @Binding var totalWorkedTime: TimeInterval
    //    @Binding var totalBreakTime: TimeInterval
    //
    //    var body: some View {
    //        VStack {
    //            Text(isClockedIn ? "Clock Out" : "Clock In")
    //                .font(.largeTitle)
    //                .padding()
    //
    //            Button(action: {
    //                if isClockedIn {
    //                    clockOutTime = Date()
    //                } else {
    //                    clockInTime = Date()
    //                }
    //                isClockedIn.toggle()
    //            }) {
    //                Text(isClockedIn ? "Confirm Clock Out" : "Confirm Clock In")
    //                    .font(.title2)
    //                    .padding()
    //                    .frame(maxWidth: .infinity)
    //                    .background(isClockedIn ? Color.red : Color.green)
    //                    .foregroundColor(.white)
    //                    .cornerRadius(10)
    //            }
    //            .padding()
    //
    //            Spacer()
    //        }
    //        .padding()
    //    }
    //}
    
    struct TimetableSheetView: View {
        var body: some View {
            NavigationView {
                VStack {
                    Text("Timetable for Today")
                        .font(.headline)
                        .padding(.top)
    
                    List {
                        Text("John Smith: 10:00 AM - 6:00 PM")
                        Text("Jane Doe: 12:00 PM - 8:00 PM")
                        Text("Alice Johnson: 9:00 AM -5:00 PM")
                    }
                    .listStyle(PlainListStyle())
    
                    Spacer()
                }
                .padding()
                .navigationTitle("Timetable")
                .navigationBarTitleDisplayMode(.inline)
            }
        }
    }
    
    
    struct TeamSummaryView: View {
    let employees = ["John Smith", "Jane Doe", "Alice Johnson"]
    
    var body: some View {
        Form {
            Section(header: Text("Team Members")) {
                ForEach(employees, id: \.self) { employee in
                    NavigationLink(destination: EmployeeProfileView(employeeName: employee)) {
                        HStack {
                            Text(employee)
                            Spacer()
                            Image(systemName: "person.circle")
                                .foregroundColor(.blue)
                        }
                    }
                }
            }
        }
        .navigationTitle("Team Summary")
    }
    }
    
    struct PendingApprovalsView: View {
    let approvals = ["Leave Request: John Smith", "Shift Change: Jane Doe"]
    
    var body: some View {
        Form {
            Section(header: Text("Pending Approvals")) {
                ForEach(approvals, id: \.self) { approval in
                    HStack {
                        Text(approval)
                        Spacer()
                        Image(systemName: "clock.arrow.circlepath")
                            .foregroundColor(.orange)
                    }
                }
            }
        }
        .navigationTitle("Pending Approvals")
    }
    }
    
    struct PerformanceAlertsView: View {
    let alerts = [
        "Late Arrival: John Smith (3 times)",
        "Missed Shift: Jane Doe (2 times)"
    ]
    
    var body: some View {
        Form {
            Section(header: Text("Performance Alerts")) {
                ForEach(alerts, id: \.self) { alert in
                    HStack {
                        Text(alert)
                        Spacer()
                        Image(systemName: "exclamationmark.triangle")
                            .foregroundColor(.red)
                    }
                }
            }
        }
        .navigationTitle("Performance Alerts")
    }
    }
    
    struct EmployeeProfileView: View {
    let employeeName: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Profile of \(employeeName)")
                .font(.largeTitle)
                .padding()
    
            Text("Details and performance metrics will be fetched from the database.")
                .font(.subheadline)
                .foregroundColor(.gray)
                .padding(.horizontal)
    
            Spacer()
        }
        .navigationTitle(employeeName)
    }
    }
    
    struct ManagerPersonalDashboardView_Previews: PreviewProvider {
    static var previews: some View {
        ManagerPersonalDashboardView()
    }
    }
    
    //
    //import SwiftUI
    //
    //struct ManagerPersonalDashboardView: View {
    //    @State private var isClockedIn = false
    //    @State private var clockInTime: Date? = nil
    //    @State private var clockOutTime: Date? = nil
    //    @State private var breakStartTime: Date? = nil
    //    @State private var totalWorkedTime: TimeInterval = 0
    //    @State private var totalBreakTime: TimeInterval = 0
    //
    //    var body: some View {
    //        NavigationView {
    //            VStack(spacing: 20) {
    //                // Summary Cards
    //                HStack(spacing: 15) {
    //                    SummaryCard(title: "Team Size", value: "5", icon: "person.2.fill")
    //                    SummaryCard(title: "Pending", value: "3", icon: "clock.fill")
    //                    SummaryCard(title: "This Week", value: "32h", icon: "calendar")
    //                }
    //                .padding()
    //
    //                // Quick Actions
    //                VStack(alignment: .leading, spacing: 10) {
    //                    Text("Quick Actions")
    //                        .font(.headline)
    //                        .padding(.leading)
    //
    //                    ActionRow(title: "View Team", subtitle: "Manage your employees", icon: "person.2", destination: TeamSummaryView())
    //                    Divider()
    //                    ActionRow(title: "Pending Approvals", subtitle: "Review timecards", icon: "checkmark.seal", destination: PendingApprovalsView())
    //                }
    //                .background(Color(.systemGray6))
    //                .cornerRadius(10)
    //                .padding()
    //
    //                // Recent Activity
    //                VStack(alignment: .leading, spacing: 10) {
    //                    Text("Recent Activity")
    //                        .font(.headline)
    //                        .padding(.leading)
    //
    //                    List {
    //                        ActivityRow(name: "John Doe", activity: "Submitted timecard", time: "2h ago")
    //                        ActivityRow(name: "Jane Smith", activity: "Requested leave", time: "4h ago")
    //                        ActivityRow(name: "Alice Johnson", activity: "Updated schedule", time: "1d ago")
    //                    }
    //                    .listStyle(PlainListStyle())
    //                }
    //                .background(Color(.systemGray6))
    //                .cornerRadius(10)
    //                .padding()
    //
    //                Spacer()
    //            }
    //            .navigationTitle("Dashboard")
    //        }
    //    }
    //}
    //
    //// Components
    //struct SummaryCard: View {
    //    let title: String
    //    let value: String
    //    let icon: String
    //
    //    var body: some View {
    //        VStack(spacing: 10) {
    //            Image(systemName: icon)
    //                .font(.largeTitle)
    //                .foregroundColor(.blue)
    //            Text(value)
    //                .font(.title)
    //                .fontWeight(.bold)
    //            Text(title)
    //                .font(.subheadline)
    //                .foregroundColor(.gray)
    //        }
    //        .frame(maxWidth: .infinity)
    //        .padding()
    //        .background(Color.white)
    //        .cornerRadius(10)
    //        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
    //    }
    //}
    //
    //struct ActionRow<Destination: View>: View {
    //    let title: String
    //    let subtitle: String
    //    let icon: String
    //    let destination: Destination
    //
    //    var body: some View {
    //        NavigationLink(destination: destination) {
    //            HStack {
    //                Image(systemName: icon)
    //                    .font(.title2)
    //                    .foregroundColor(.blue)
    //                VStack(alignment: .leading, spacing: 5) {
    //                    Text(title)
    //                        .font(.headline)
    //                    Text(subtitle)
    //                        .font(.subheadline)
    //                        .foregroundColor(.gray)
    //                }
    //                Spacer()
    //                Image(systemName: "chevron.right")
    //                    .foregroundColor(.gray)
    //            }
    //            .padding()
    //        }
    //    }
    //}
    //
    //struct ActivityRow: View {
    //    let name: String
    //    let activity: String
    //    let time: String
    //
    //    var body: some View {
    //        HStack {
    //            VStack(alignment: .leading) {
    //                Text(name)
    //                    .font(.headline)
    //                Text(activity)
    //                    .font(.subheadline)
    //                    .foregroundColor(.gray)
    //            }
    //            Spacer()
    //            Text(time)
    //                .font(.subheadline)
    //                .foregroundColor(.gray)
    //        }
    //        .padding(.vertical, 5)
    //    }
    //}
    //
    //// Weekly Schedule
    //struct WeeklyScheduleView: View {
    //    let scheduleTitle: String
    //    let shifts: [String]
    //
    //    var body: some View {
    //        VStack(spacing: 20) {
    //            Text(scheduleTitle)
    //                .font(.headline)
    //                .padding()
    //
    //            HStack(spacing: 10) {
    //                ForEach(shifts, id: \ .self) { shift in
    //                    VStack {
    //                        Text(shift.prefix(3))
    //                            .font(.headline)
    //                        RoundedRectangle(cornerRadius: 5)
    //                            .fill(Color.blue)
    //                            .frame(width: 40, height: 40)
    //                    }
    //                }
    //            }
    //
    //            List {
    //                Section(header: Text("Detailed Schedule")) {
    //                    ForEach(shifts, id: \ .self) { shift in
    //                        Text(shift)
    //                    }
    //                }
    //            }
    //            .listStyle(PlainListStyle())
    //        }
    //        .padding()
    //        .navigationTitle(scheduleTitle)
    //    }
    //}
    //
    //struct TeamSummaryView: View {
    //    var body: some View {
    //        Text("Team Summary View")
    //    }
    //}
    //
    //struct PendingApprovalsView: View {
    //    var body: some View {
    //        Text("Pending Approvals View")
    //    }
    //}
    //
    //struct ManagerPersonalDashboardView_Previews: PreviewProvider {
    //    static var previews: some View {
    //        ManagerPersonalDashboardView()
    //    }
    //}
    
    //
    //import SwiftUI
    //
    //struct ManagerPersonalDashboardView: View {
    //    @State private var isClockedIn = false
    //    @State private var clockInTime: Date? = nil
    //    @State private var clockOutTime: Date? = nil
    //    @State private var showClockingSheet = false
    //
    //    var body: some View {
    //        NavigationView {
    //            ScrollView {
    //                VStack(spacing: 20) {
    //                    // Manager Insights
    //                    Section(header: Text("Manager Insights").font(.headline)) {
    //                        VStack(spacing: 15) {
    //                            // Team Summary
    //                            NavigationLink(destination: TeamSummaryView()) {
    //                                InsightRow(title: "Team Summary", details: ["Clocked In: 5", "Scheduled: 12"])
    //                            }
    //
    //                            Divider()
    //
    //                            // Manager's Weekly Schedule
    //                            NavigationLink(destination: WeeklyScheduleView(scheduleTitle: "Manager's Weekly Schedule", shifts: [
    //                                "Mon: 9 AM - 5 PM",
    //                                "Tue: 10 AM - 6 PM",
    //                                "Wed: 9 AM - 5 PM",
    //                                "Thu: 11 AM - 7 PM",
    //                                "Fri: 9 AM - 5 PM"
    //                            ])) {
    //                                InsightRow(title: "Manager's Weekly Schedule", details: ["Days: Mon - Fri"])
    //                            }
    //
    //                            Divider()
    //
    //                            // Employee Weekly Schedule
    //                            NavigationLink(destination: WeeklyScheduleView(scheduleTitle: "Employee Weekly Schedule", shifts: [
    //                                "Mon: John 10 AM - 6 PM, Jane 12 PM - 8 PM",
    //                                "Tue: Alice 9 AM - 5 PM, Jane 12 PM - 8 PM",
    //                                "Wed: John 10 AM - 6 PM, Alice 9 AM - 5 PM",
    //                                "Thu: Jane 12 PM - 8 PM, Alice 9 AM - 5 PM",
    //                                "Fri: John 10 AM - 6 PM, Jane 12 PM - 8 PM"
    //                            ])) {
    //                                InsightRow(title: "Employee Weekly Schedule", details: ["Days: Mon - Fri"])
    //                            }
    //
    //                            Divider()
    //
    //                            // Performance Alerts
    //                            NavigationLink(destination: PerformanceAlertsView()) {
    //                                InsightRow(title: "Performance Alerts", details: ["3 Late Arrivals This Week", "2 Missed Shifts"])
    //                            }
    //                        }
    //                    }
    //
    //                    // Clock In/Out Button
    //                    Button(action: {
    //                        showClockingSheet.toggle()
    //                    }) {
    //                        Text(isClockedIn ? "Clock Out" : "Clock In")
    //                            .font(.title)
    //                            .padding()
    //                            .frame(maxWidth: .infinity)
    //                            .background(isClockedIn ? Color.red : Color.green)
    //                            .foregroundColor(.white)
    //                            .cornerRadius(10)
    //                    }
    //                    .sheet(isPresented: $showClockingSheet) {
    //                        ClockingSheetView(
    //                            isClockedIn: $isClockedIn,
    //                            clockInTime: $clockInTime,
    //                            clockOutTime: $clockOutTime
    //                        )
    //                    }
    //                }
    //                .padding()
    //            }
    //            .navigationTitle("Manager's Dashboard")
    //        }
    //    }
    //}
    //
    //// Components
    //struct InsightRow: View {
    //    let title: String
    //    let details: [String]
    //
    //    var body: some View {
    //        HStack {
    //            VStack(alignment: .leading, spacing: 5) {
    //                Text(title).font(.headline)
    //                ForEach(details, id: \ .self) { detail in
    //                    Text(detail).font(.subheadline)
    //                }
    //            }
    //            Spacer()
    //            Image(systemName: "chevron.right")
    //                .foregroundColor(.gray)
    //        }
    //        .padding()
    //        .background(Color.white)
    //        .cornerRadius(10)
    //        .shadow(radius: 2)
    //    }
    //}
    //
    //struct WeeklyScheduleView: View {
    //    let scheduleTitle: String
    //    let shifts: [String]
    //
    //    var body: some View {
    //        VStack(spacing: 20) {
    //            Text(scheduleTitle)
    //                .font(.headline)
    //                .padding()
    //
    //            HStack(spacing: 10) {
    //                ForEach(shifts, id: \ .self) { shift in
    //                    VStack {
    //                        Text(shift.prefix(3))
    //                            .font(.headline)
    //                        RoundedRectangle(cornerRadius: 5)
    //                            .fill(Color.blue)
    //                            .frame(width: 40, height: 40)
    //                    }
    //                }
    //            }
    //
    //            List {
    //                Section(header: Text("Detailed Schedule")) {
    //                    ForEach(shifts, id: \ .self) { shift in
    //                        Text(shift)
    //                    }
    //                }
    //            }
    //            .listStyle(PlainListStyle())
    //        }
    //        .padding()
    //        .navigationTitle(scheduleTitle)
    //    }
    //}
    //
    //struct ClockingSheetView: View {
    //    @Binding var isClockedIn: Bool
    //    @Binding var clockInTime: Date?
    //    @Binding var clockOutTime: Date?
    //
    //    var body: some View {
    //        VStack {
    //            Text(isClockedIn ? "Clock Out" : "Clock In")
    //                .font(.largeTitle)
    //                .padding()
    //
    //            Button(action: {
    //                if isClockedIn {
    //                    clockOutTime = Date()
    //                } else {
    //                    clockInTime = Date()
    //                }
    //                isClockedIn.toggle()
    //            }) {
    //                Text(isClockedIn ? "Confirm Clock Out" : "Confirm Clock In")
    //                    .font(.title2)
    //                    .padding()
    //                    .frame(maxWidth: .infinity)
    //                    .background(isClockedIn ? Color.red : Color.green)
    //                    .foregroundColor(.white)
    //                    .cornerRadius(10)
    //            }
    //            .padding()
    //
    //            Spacer()
    //        }
    //        .padding()
    //    }
    //}
    //
    //struct PerformanceAlertsView: View {
    //    let alerts = [
    //        "Late Arrival: John Smith (3 times)",
    //        "Missed Shift: Jane Doe (2 times)"
    //    ]
    //
    //    var body: some View {
    //        Form {
    //            Section(header: Text("Performance Alerts")) {
    //                ForEach(alerts, id: \ .self) { alert in
    //                    HStack {
    //                        Text(alert)
    //                        Spacer()
    //                        Image(systemName: "exclamationmark.triangle")
    //                            .foregroundColor(.red)
    //                    }
    //                }
    //            }
    //        }
    //        .navigationTitle("Performance Alerts")
    //    }
    //}
    //
    //struct TeamSummaryView: View {
    //    let employees = ["John Smith", "Jane Doe", "Alice Johnson"]
    //
    //    var body: some View {
    //        Form {
    //            Section(header: Text("Team Members")) {
    //                ForEach(employees, id: \ .self) { employee in
    //                    Text(employee)
    //                }
    //            }
    //        }
    //        .navigationTitle("Team Summary")
    //    }
    //}
    //
    //struct ManagerPersonalDashboardView_Previews: PreviewProvider {
    //    static var previews: some View {
    //        ManagerPersonalDashboardView()
    //    }
    //}
    

