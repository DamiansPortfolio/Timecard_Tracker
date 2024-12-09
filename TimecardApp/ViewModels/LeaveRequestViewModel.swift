//
//  LeaveRequestViewModel.swift
//  TimecardApp
//
//  Created by Anastasia Runion on 12/8/24.
//


//
//  LeaveRequestViewModel.swift
//  TimecardApp
//
//  Created by Anastasia Runion on 11/22/24.
//

import Foundation
import FirebaseFirestore

class LeaveRequestViewModel: ObservableObject {
    @Published var isLoading = false
    @Published var errorMessage: AlertItem? // Updated to AlertItem
    @Published var successMessage: AlertItem? // Updated to AlertItem
    
    private let db = Firestore.firestore()
    
    func submitLeaveRequest(leaveType: String, startDate: Date, endDate: Date, reason: String) {
        isLoading = true
        errorMessage = nil
        successMessage = nil
        
        let newLeaveRequest = [
            "userId": UserDefaults.standard.string(forKey: "userId") ?? "",
            "leaveType": leaveType,
            "startDate": Timestamp(date: startDate),
            "endDate": Timestamp(date: endDate),
            "reason": reason,
            "status": "pending" // Default status
        ] as [String: Any]
        
        db.collection("leaveRequests").addDocument(data: newLeaveRequest) { [weak self] error in
            DispatchQueue.main.async {
                self?.isLoading = false
                if let error = error {
                    self?.errorMessage = AlertItem(
                        title: "Error",
                        message: "Failed to submit leave request: \(error.localizedDescription)"
                    )
                } else {
                    self?.successMessage = AlertItem(
                        title: "Success",
                        message: "Leave request submitted successfully!"
                    )
                }
            }
        }
    }
}


//
//class LeaveRequestViewModel: ObservableObject {
//    @Published var isLoading = false
//    @Published var errorMessage: String?
//    @Published var successMessage: String? // For success notification
//
//    private let db = Firestore.firestore()
//
//    func submitLeaveRequest(leaveType: String, startDate: Date, endDate: Date, reason: String) {
//        // Validation
//        guard !leaveType.isEmpty else {
//            errorMessage = "Leave type cannot be empty."
//            return
//        }
//
//        guard startDate <= endDate else {
//            errorMessage = "Start date cannot be later than end date."
//            return
//        }
//
//        guard !reason.isEmpty else {
//            errorMessage = "Reason cannot be empty."
//            return
//        }
//
//        // Prepare leave request data
//        isLoading = true
//        errorMessage = nil
//        successMessage = nil
//
//        let newLeaveRequest: [String: Any] = [
//            "userId": UserDefaults.standard.string(forKey: "userId") ?? "",
//            "leaveType": leaveType,
//            "startDate": Timestamp(date: startDate),
//            "endDate": Timestamp(date: endDate),
//            "reason": reason,
//            "status": "pending" // Default status
//        ]
//
//        // Submit to Firestore
//        db.collection("leaveRequests").addDocument(data: newLeaveRequest) { [weak self] error in
//            DispatchQueue.main.async {
//                if let error = error {
//                    self?.errorMessage = "Error submitting leave request: \(error.localizedDescription)"
//                } else {
//                    self?.successMessage = "Leave request submitted successfully!"
//                }
//                self?.isLoading = false
//            }
//        }
//    }
//}

//
//class LeaveRequestViewModel: ObservableObject {
//    @Published var isLoading = false
//    @Published var errorMessage: AlertItem?
//    @Published var successMessage: AlertItem?
//
//    private let db = Firestore.firestore()
//
//    func submitLeaveRequest(leaveType: String, startDate: Date, endDate: Date, reason: String) {
//        isLoading = true
//        errorMessage = nil
//        successMessage = nil
//
//        
//        let newLeaveRequest = [
//            "userId": UserDefaults.standard.string(forKey: "userId") ?? "",
//            "leaveType": leaveType,
//            "startDate": Timestamp(date: startDate),
//            "endDate": Timestamp(date: endDate),
//            "reason": reason,
//            "status": "pending" // Default status
//        ] as [String: Any]
//
//        db.collection("leaveRequests").addDocument(data: newLeaveRequest) { [weak self] error in
//            DispatchQueue.main.async {
//                if let error = error {
//                    self?.errorMessage = AlertItem(
//                        title: "Error",
//                        message: "Error submitting leave request: \(error.localizedDescription)"
//                    )
//                } else {
//                    self?.successMessage = AlertItem(
//                        title: "Success",
//                        message: "Your leave request has been submitted successfully."
//                    )
//                }
//                self?.isLoading = false
//            }
//        }
//    }
//}

//
//import Foundation
//import FirebaseFirestore
//
//class LeaveRequestViewModel: ObservableObject {
//    @Published var isLoading = false
//    @Published var errorMessage: String?
//    @Published var successMessage: String?
//
//    private let db = Firestore.firestore()
//
//    func submitLeaveRequest(leaveType: String, startDate: Date, endDate: Date, reason: String) {
//        guard let userId = UserDefaults.standard.string(forKey: "userId") else {
//            self.errorMessage = "User ID not found. Please log in again."
//            return
//        }
//
//        isLoading = true
//        errorMessage = nil
//        successMessage = nil
//
//        // Prepare data to save to Firestore
//        let newLeaveRequest: [String: Any] = [
//            "userId": userId,
//            "leaveType": leaveType,
//            "startDate": Timestamp(date: startDate),
//            "endDate": Timestamp(date: endDate),
//            "reason": reason,
//            "status": "pending", // Default status for a new leave request
//            "createdAt": FieldValue.serverTimestamp() // Optional timestamp
//        ]
//
//        // Save the leave request to Firestore
//        db.collection("leaveRequests").addDocument(data: newLeaveRequest) { [weak self] error in
//            DispatchQueue.main.async {
//                self?.isLoading = false
//                if let error = error {
//                    self?.errorMessage = "Failed to submit leave request: \(error.localizedDescription)"
//                } else {
//                    self?.successMessage = "Leave request successfully submitted!"
//                }
//            }
//        }
//    }
//}
