//
//  SettingsViewModel.swift
//  TimecardApp
//
//  Created by Anastasia Runion on 12/8/24.
//

//
//import SwiftUI
//import FirebaseFirestore
//
//class SettingsViewModel: ObservableObject {
//    // MARK: - Published Properties
//    @Published var isManager: Bool = false
//    @Published var isAdmin: Bool = false
//    @Published var systemLogEnabled: Bool = false
//    @Published var isLoading: Bool = false
//    @Published var errorMessage: String?
//
//    // MARK: - Firestore Instance
//    private let db = Firestore.firestore()
//
//    // MARK: - Fetch Roles and Settings
//    func fetchSettings(userId: String) {
//        isLoading = true
//        errorMessage = nil
//
//        // Fetch user roles
//        db.collection("users").document(userId).getDocument { [weak self] snapshot, error in
//            guard let self = self else { return }
//
//            if let error = error {
//                self.handleError("Error fetching user roles: \(error.localizedDescription)")
//                return
//            }
//
//            guard let data = snapshot?.data() else {
//                self.handleError("User not found.")
//                return
//            }
//
//            self.isManager = data["isManager"] as? Bool ?? false
//            self.isAdmin = data["isAdmin"] as? Bool ?? false
//
//            // Fetch system log toggle state
//            self.fetchSystemLogToggleState(userId: userId)
//        }
//    }
//
//    private func fetchSystemLogToggleState(userId: String) {
//        db.collection("settings").document(userId).getDocument { [weak self] snapshot, error in
//            guard let self = self else { return }
//
//            if let error = error {
//                self.handleError("Error fetching system log toggle state: \(error.localizedDescription)")
//                return
//            }
//
//            self.systemLogEnabled = snapshot?.data()?["systemLogEnabled"] as? Bool ?? false
//            self.isLoading = false
//        }
//    }
//
//    // MARK: - Save System Log Toggle
//    func saveSystemLogToggle(userId: String, isEnabled: Bool) {
//        db.collection("settings").document(userId).setData(["systemLogEnabled": isEnabled], merge: true) { [weak self] error in
//            if let error = error {
//                self?.handleError("Error saving system log toggle state: \(error.localizedDescription)")
//                return
//            }
//            print("System log toggle state saved: \(isEnabled)")
//        }
//    }
//
//    // MARK: - Handle Errors
//    private func handleError(_ message: String) {
//        DispatchQueue.main.async {
//            self.errorMessage = message
//            self.isLoading = false
//        }
//    }
//}
