//
//  LeaveRequestsView.swift
//  TimecardApp
//
//  Created by Anastasia Runion on 11/22/24.
//
//
import SwiftUI

struct LeaveRequestsView: View {
    @StateObject var viewModel: ManagerViewModel

    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Pending Leave Requests")) {
                    if viewModel.pendingLeaveRequests.isEmpty {
                        Text("No pending leave requests.")
                            .foregroundColor(.gray)
                    } else {
                        ForEach(viewModel.pendingLeaveRequests) { leaveRequest in
                            LeaveRequestRow(
                                leaveRequest: leaveRequest,
                                approveAction: { viewModel.approveLeaveRequest(leaveRequest) },
                                denyAction: { viewModel.denyLeaveRequest(leaveRequest) }
                            )
                        }
                    }
                }
                
                Section(header: Text("Processed Leave Requests")) {
                    if viewModel.pendingLeaveRequests.isEmpty {
                        Text("No processed leave requests yet.")
                            .foregroundColor(.gray)
                    } else {
                        ForEach(viewModel.pendingLeaveRequests) { leaveRequest in
                            LeaveRequestRow(
                                leaveRequest: leaveRequest,
                                isActionable: false // Processed requests cannot be approved/denied
                            )
                        }
                    }
                }
            }
            .navigationTitle("Leave Requests")
            .onAppear {
                viewModel.fetchManagerData(managerId: "managerId") // Replace with actual manager ID
            }
        }
    }
}

//ignore for now
//import SwiftUI
//
//struct LeaveRequestsView: View {
//    @StateObject var viewModel: ManagerViewModel
//
//    var body: some View {
//        NavigationView {
//            List {
//                // Pending Leave Requests Section
//                Section(header: Text("Pending Leave Requests")) {
//                    if viewModel.pendingLeaveRequests.isEmpty {
//                        Text("No pending leave requests.")
//                            .foregroundColor(.gray)
//                    } else {
//                        ForEach(viewModel.pendingLeaveRequests) { leaveRequest in
//                            LeaveRequestRow(
//                                leaveRequest: leaveRequest,
//                                approveAction: { viewModel.approveLeaveRequest(leaveRequest) },
//                                denyAction: { viewModel.denyLeaveRequest(leaveRequest) }
//                            )
//                        }
//                    }
//                }
//                
//                // Processed Leave Requests Section
//                Section(header: Text("Processed Leave Requests")) {
//                    let processedRequests = viewModel.processedLeaveRequests
//                    if processedRequests.isEmpty {
//                        Text("No processed leave requests yet.")
//                            .foregroundColor(.gray)
//                    } else {
//                        ForEach(processedRequests) { leaveRequest in
//                            LeaveRequestRow(
//                                leaveRequest: leaveRequest,
//                                isActionable: false // Processed requests are not actionable
//                            )
//                        }
//                    }
//                }
//            }
//            .navigationTitle("Leave Requests")
//            .onAppear {
//                if let managerId = UserDefaults.standard.string(forKey: "userId") {
//                    viewModel.fetchManagerData(managerId: managerId)
//                }
//            }
//        }
//    }
//}
//
//struct LeaveRequestRow: View {
//    let leaveRequest: LeaveRequest
//    let approveAction: (() -> Void)?
//    let denyAction: (() -> Void)?
//    var isActionable: Bool = true
//
//    var body: some View {
//        VStack(alignment: .leading, spacing: 5) {
//            // Request Details
//            Text("\(leaveRequest.fname) \(leaveRequest.lname)")
//                .font(.headline)
//            Text("Type: \(leaveRequest.leaveType)")
//                .font(.subheadline)
//                .foregroundColor(.gray)
//            Text("Reason: \(leaveRequest.reason)")
//                .font(.subheadline)
//                .foregroundColor(.gray)
//            Text("Dates: \(leaveRequest.startDate.formatted(date: .abbreviated, time: .omitted)) - \(leaveRequest.endDate.formatted(date: .abbreviated, time: .omitted))")
//                .font(.subheadline)
//                .foregroundColor(.gray)
//
//            // Approve/Deny Buttons
//            if isActionable {
//                HStack {
//                    Button(action: { approveAction?() }) {
//                        Text("Approve")
//                            .font(.subheadline)
//                            .fontWeight(.bold)
//                            .foregroundColor(.green)
//                    }
//                    Spacer()
//                    Button(action: { denyAction?() }) {
//                        Text("Deny")
//                            .font(.subheadline)
//                            .fontWeight(.bold)
//                            .foregroundColor(.red)
//                    }
//                }
//                .padding(.top, 5)
//            } else {
//                Text("Status: \(leaveRequest.status.rawValue.capitalized)")
//                    .font(.footnote)
//                    .foregroundColor(leaveRequest.status == .approved ? .green : .red)
//            }
//        }
//        .padding(.vertical, 10)
//    }
//}
