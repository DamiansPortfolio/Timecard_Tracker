import Foundation

class ProfileViewModel: ObservableObject {
    // Basic info and contact
    @Published var username: String = "Damian Rozycki"
    @Published var email: String = "damian@example.com"
    @Published var phone: String = "(123) 456-7890"
    @Published var emergencyContact: String = "(987) 654-3210"
    
    // Work details
    @Published var latestPosition: String = "Software Engineer"
    @Published var branch: String = "San Francisco"
    @Published var department: String = "Engineering"
    @Published var monthlyHours: Int = 160
    
    // Settings
    @Published var notificationsEnabled: Bool = true
    
    func changePassword() {
        // Code for password change flow
    }
    
    func contactSupport() {
        // Code to open support email or chat
    }
    
    func logOut() {
        // Code to handle logout action
    }
}
