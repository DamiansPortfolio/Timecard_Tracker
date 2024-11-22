//
//  LeaveRequestsView.swift
//  TimecardApp
//
//  Created by Anastasia Runion on 11/22/24.
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

