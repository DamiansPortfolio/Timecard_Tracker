//
//  PendingApprovalsView.swift
//  TimecardApp
//
//  Created by Anastasia Runion on 11/22/24.
//

import SwiftUI
//
//struct PendingApprovalsView: View {
//    @StateObject var viewModel = ManagerViewModel()
//    let managerId: String
//
//    var body: some View {
//        NavigationView {
//            List {
//                Section(header: Text("Pending Timecards")) {
//                    ForEach(viewModel.pendingTimecards) { timecard in
//                        VStack(alignment: .leading) {
//                            Text("Employee: \(timecard.firstName) \(timecard.lastName)")
//                            Text("Date: \(timecard.date, style: .date)")
//                            Text("Hours: \(timecard.totalHours, specifier: "%.2f")")
//                        }
//                        .swipeActions {
//                            Button("Approve") {
//                                viewModel.approveTimecard(timecard)
//                            }
//                            .tint(.green)
//
//                            Button("Reject") {
//                                viewModel.denyTimecard(timecard)
//                            }
//                            .tint(.red)
//                        }
//                    }
//                }
//                
//                Section(header: Text("Pending Leave Requests")) {
//                    ForEach(viewModel.pendingLeaveRequests) { leaveRequest in
//                        VStack(alignment: .leading) {
//                            Text("Employee: \(leaveRequest.userId)") // Replace with full name if available
//                            Text("Dates: \(leaveRequest.startDate, style: .date) - \(leaveRequest.endDate, style: .date)")
//                            Text("Reason: \(leaveRequest.reason)")
//                        }
//                        .swipeActions {
//                            Button("Approve") {
//                                viewModel.approveLeaveRequest(leaveRequest)
//                            }
//                            .tint(.green)
//
//                            Button("Reject") {
//                                viewModel.denyLeaveRequest(leaveRequest)
//                            }
//                            .tint(.red)
//                        }
//                    }
//                }
//            }
//            .navigationTitle("Pending Approvals")
//            .onAppear {
//                viewModel.fetchManagerData(managerId: managerId)
//            }
//        }
//    }
//}

import SwiftUI

struct PendingTimecardApprovals: View {
    @StateObject var viewModel: ManagerViewModel
    let managerId: String // Pass the manager's ID

    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Pending Timecards")) {
                    ForEach(viewModel.pendingTimecards) { timecard in
                        VStack(alignment: .leading) {
                            Text("Employee: \(timecard.firstName) \(timecard.lastName)")
                            Text("Date: \(timecard.date, style: .date)")
                            Text("Hours: \(timecard.totalHours, specifier: "%.2f")")
                        }
                        .swipeActions {
                            Button("Approve") {
                                viewModel.approveTimecard(timecard)
                            }
                            .tint(.green)

                            Button("Reject") {
                                viewModel.denyTimecard(timecard)
                            }
                            .tint(.red)
                        }
                    }
                }
                
                Section(header: Text("Pending Leave Requests")) {
                    ForEach(viewModel.pendingLeaveRequests) { leaveRequest in
                        VStack(alignment: .leading) {
                            Text("Employee: \(leaveRequest.userId)") // Replace with full name if available
                            Text("Dates: \(leaveRequest.startDate, style: .date) - \(leaveRequest.endDate, style: .date)")
                            Text("Reason: \(leaveRequest.reason)")
                        }
                        .swipeActions {
                            Button("Approve") {
                                viewModel.approveLeaveRequest(leaveRequest)
                            }
                            .tint(.green)

                            Button("Reject") {
                                viewModel.denyLeaveRequest(leaveRequest)
                            }
                            .tint(.red)
                        }
                    }
                }
            }
            .navigationTitle("Pending Approvals")
            .onAppear {
                viewModel.fetchManagerData(managerId: managerId)
            }
        }
    }
}
