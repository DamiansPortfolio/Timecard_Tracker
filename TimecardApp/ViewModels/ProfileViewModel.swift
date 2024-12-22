    // ProfileViewModel.swift
import Foundation
import FirebaseFirestore

class ProfileViewModel: ObservableObject {
        // Existing properties
    @Published var firstName: String = ""
    @Published var lastName: String = ""
    @Published var middleName: String = ""
    @Published var title: String = ""
    @Published var username: String = ""
    @Published var email: String = ""
    @Published var phone: String = ""
    @Published var branch: String = ""
    @Published var department: String = ""
    @Published var location: String = ""
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var isLoggedOut: Bool = false
    
        // New password-related properties
    @Published var showPasswordError = false
    @Published var showPasswordSuccess = false
    @Published var passwordErrorMessage: String?
    
    private let db = Firestore.firestore()
    
    init() {
        fetchUser()
    }
    
    func logOut() {
            // Clear UserDefaults
        UserDefaults.standard.removeObject(forKey: "userEmail")
        UserDefaults.standard.removeObject(forKey: "userName")
        UserDefaults.standard.removeObject(forKey: "userId")
        UserDefaults.standard.removeObject(forKey: "isManager") // Add this line
        
            // Clear local user data
        clearUserData()
        
            // Set logged out state to true
        DispatchQueue.main.async {
            self.isLoggedOut = true
        }
    }
    
    private func clearUserData() {
        firstName = ""
        lastName = ""
        middleName = ""
        title = ""
        username = ""
        email = ""
        phone = ""
        branch = ""
        department = ""
        location = ""
    }
    
    func updatePassword(currentPassword: String, newPassword: String) {
        guard let userId = UserDefaults.standard.string(forKey: "userId") else {
            passwordErrorMessage = "No user ID found"
            showPasswordError = true
            return
        }
        
        isLoading = true
        
        db.collection("users").document(userId).getDocument { [weak self] document, error in
            guard let self = self,
                  let document = document,
                  let storedPassword = document.data()?["password"] as? String else {
                self?.passwordErrorMessage = "Error verifying current password"
                self?.showPasswordError = true
                self?.isLoading = false
                return
            }
            
            if storedPassword != currentPassword {
                self.passwordErrorMessage = "Current password is incorrect"
                self.showPasswordError = true
                self.isLoading = false
                return
            }
            
            self.db.collection("users").document(userId).updateData([
                "password": newPassword
            ]) { error in
                DispatchQueue.main.async {
                    self.isLoading = false
                    if let error = error {
                        self.passwordErrorMessage = error.localizedDescription
                        self.showPasswordError = true
                    } else {
                        self.showPasswordSuccess = true
                    }
                }
            }
        }
    }
    
    func updateProfile(
        firstName: String,
        lastName: String,
        phone: String,
        title: String,
        branch: String,
        department: String,
        location: String
    ) {
        guard let userId = UserDefaults.standard.string(forKey: "userId") else {
            self.errorMessage = "No user ID found"
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        let updatedData: [String: Any] = [
            "fname": firstName,
            "lname": lastName,
            "phone": phone,
            "title": title,
            "branch": branch,
            "department": department,
            "location": location
        ]
        
        Task {
            do {
                try await db.collection("users").document(userId).updateData(updatedData)
                
                await MainActor.run {
                        // Update local state
                    self.firstName = firstName
                    self.lastName = lastName
                    self.phone = phone
                    self.title = title
                    self.branch = branch
                    self.department = department
                    self.location = location
                    
                    self.isLoading = false
                }
            } catch {
                await MainActor.run {
                    self.errorMessage = "Error updating profile: \(error.localizedDescription)"
                    self.isLoading = false
                }
            }
        }
    }
    
    private func fetchUser() {
        guard let userId = UserDefaults.standard.string(forKey: "userId") else {
            self.errorMessage = "No user ID found"
            self.isLoggedOut = true
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        Task {
            do {
                let document = try await db.collection("users").document(userId).getDocument()
                
                if document.exists {
                    await MainActor.run {
                            // Existing mappings...
                        self.firstName = document["fname"] as? String ?? "Unknown"
                        self.lastName = document["lname"] as? String ?? "Unknown"
                        self.middleName = document["mname"] as? String ?? "Unknown"
                        self.username = document["username"] as? String ?? "Unknown"
                        self.email = document["email"] as? String ?? "Unknown"
                        self.branch = document["branch"] as? String ?? "Unknown"
                        self.department = document["department"] as? String ?? "Unknown"
                        self.phone = document["phone"] as? String ?? "Unknown"
                        self.title = document["title"] as? String ?? "Unknown"
                        self.location = document["location"] as? String ?? "Unknown"
                        
                            // Add this line to store isManager status
                        if let isManager = document["isManager"] as? Bool {
                            UserDefaults.standard.set(isManager, forKey: "isManager")
                        }
                        
                        self.isLoading = false
                    }
                } else {
                    await MainActor.run {
                        self.errorMessage = "User data not found."
                        self.isLoading = false
                    }
                }
            } catch {
                await MainActor.run {
                    self.errorMessage = "Error fetching user: \(error.localizedDescription)"
                    self.isLoading = false
                }
            }
        }
    }
}
