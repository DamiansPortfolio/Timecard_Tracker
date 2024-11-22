//
//  PendingLeaveRequestsView.swift
//  TimecardApp
//
//  Created by Anastasia Runion on 11/22/24.
//

//import SwiftUI
//
//struct PendingLeaveRequestsView: View {
//    @ObservedObject var viewModel: ManagerViewModel
//
//    var body: some View {
//        List(viewModel.pendingLeaveRequests) { request in
//            VStack(alignment: .leading) {
//                Text(request.leaveType)
//                    .font(.headline)
//                Text("From: \(request.startDate, formatter: dateFormatter)")
//                Text("To: \(request.endDate, formatter: dateFormatter)")
//                Text("Reason: \(request.reason)")
//            }
//        }
//        .navigationTitle("Leave Requests")
//    }
//
//    private var dateFormatter: DateFormatter {
//        let formatter = DateFormatter()
//        formatter.dateStyle = .medium
//        return formatter
//    }
//}
