//
//  EmployeeDashboard.swift
//  TimecardApp
//
//  Created by Anastasia Runion on 11/17/24.
//

//
//import SwiftUI
//
//struct EmployeeDashboardView: View {
//    @State private var showTimecardSheet = false
//    @State private var showProfileSheet = false
//
//    var body: some View {
//        NavigationView {
//            ScrollView {
//                VStack(spacing: 20) {
//                    // Employee Summary
//                    HStack(spacing: 10) {
//                        InsightCard(title: "Hours Worked", value: "40.0h", icon: "clock.fill", color: .green)
//                        InsightCard(title: "Pending Approvals", value: "1", icon: "exclamationmark.circle.fill", color: .orange)
//                        InsightCard(title: "Shifts This Week", value: "5", icon: "calendar", color: .blue)
//                    }
//
//                    // Quick Actions
//                    VStack(alignment: .leading, spacing: 10) {
//                        Text("Quick Actions")
//                            .font(.headline)
//                            .padding(.horizontal)
//
//                        ActionRow(title: "View Timecards", subtitle: "Check your work hours", icon: "doc.text", actionText: "View", actionColor: .blue) {
//                            showTimecardSheet.toggle()
//                        }
//                        .sheet(isPresented: $showTimecardSheet) {
//                            TimecardView()
//                        }
//
//                        ActionRow(title: "Update Profile", subtitle: "Edit your personal details", icon: "person.crop.circle", actionText: "Edit", actionColor: .green) {
//                            showProfileSheet.toggle()
//                        }
//                        .sheet(isPresented: $showProfileSheet) {
//                            ProfileView()
//                        }
//                    }
//                    .background(Color.white)
//                    .cornerRadius(10)
//                    .shadow(radius: 5)
//                    .padding(.horizontal)
//
//                    // Recent Activity
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
//            .navigationTitle("Employee Dashboard")
//        }
//    }
//}
//
//// Timecard View
//struct TimecardView: View {
//    var body: some View {
//        NavigationView {
//            VStack {
//                Text("Your Timecards")
//                    .font(.headline)
//                    .padding()
//
//                List {
//                    ForEach(0..<5) { index in
//                        HStack {
//                            Text("Week \(index + 1)")
//                            Spacer()
//                            Text("40.0h")
//                                .foregroundColor(.gray)
//                        }
//                    }
//                }
//                .listStyle(PlainListStyle())
//
//                Spacer()
//            }
//            .navigationTitle("Timecards")
//            .navigationBarTitleDisplayMode(.inline)
//        }
//    }
//}
//
////// Profile View
////struct ProfileView: View {
////    @State private var name = "John Doe"
////    @State private var email = "johndoe@example.com"
////    @State private var phone = "(123) 456-7890"
////
////    var body: some View {
////        NavigationView {
////            Form {
////                Section(header: Text("Personal Information")) {
////                    TextField("Name", text: $name)
////                    TextField("Email", text: $email)
////                    TextField("Phone", text: $phone)
////                }
////
////                Section {
////                    Button(action: {
////                        // Save profile changes
////                    }) {
////                        Text("Save Changes")
////                            .font(.headline)
////                            .foregroundColor(.blue)
////                    }
////                }
////            }
////            .navigationTitle("Edit Profile")
////            .navigationBarTitleDisplayMode(.inline)
////        }
////    }
////}
//
//// Shared Components (Reuse from Manager View)
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
//    EmployeeDashboardView()
//}
