//
//  LeaveRequestRow.swift
//  TimecardApp
//
//  Created by Anastasia Runion on 11/22/24.
//


import SwiftUI

struct LeaveRequestRow: View {
    let leaveRequest: LeaveRequest
    var approveAction: (() -> Void)? = nil
    var denyAction: (() -> Void)? = nil
    var isActionable: Bool = true // Toggle for whether the actions are available

    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text("Employee: \(leaveRequest.userId)") // Replace with a full name if available
                .font(.headline)
            Text("Dates: \(leaveRequest.startDate, style: .date) - \(leaveRequest.endDate, style: .date)")
                .font(.subheadline)
                .foregroundColor(.secondary)
            Text("Reason: \(leaveRequest.reason)")
                .font(.subheadline)
                .foregroundColor(.secondary)
            Text("Status: \(leaveRequest.status.rawValue.capitalized)")
                .font(.subheadline)
                .foregroundColor(statusColor(for: leaveRequest.status))
        }
        .swipeActions(edge: .trailing, allowsFullSwipe: false) {
            if isActionable {
                Button("Approve", action: { approveAction?() })
                    .tint(.green)
                Button("Deny", action: { denyAction?() })
                    .tint(.red)
            }
        }
    }

    private func statusColor(for status: LeaveStatus) -> Color {
        switch status {
        case .pending: return .yellow
        case .approved: return .green
        case .denied: return .red
        }
    }
}
