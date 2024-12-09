//    import SwiftUI
//    import FirebaseFirestore
//
//    class LoginViewModel: ObservableObject {
//        @Published var email: String = ""
//        @Published var password: String = ""
//        @Published var showPassword: Bool = false
//        @Published var isLoading: Bool = false
//        @Published var errorMessage: String = ""
//        @Published var isAuthenticated: Bool = false
//        
//        private let db = Firestore.firestore()
//        
//        var isLoginDisabled: Bool {
//            email.isEmpty || password.isEmpty || isLoading
//        }
//        
//        func login() {
//            guard !email.isEmpty && !password.isEmpty else {
//                errorMessage = "Please enter both email and password"
//                return
//            }
//            
//            isLoading = true
//            errorMessage = ""
//            
//            // Query Firestore for user with matching email and password
//            db.collection("users")
//                .whereField("email", isEqualTo: email)
//                .whereField("password", isEqualTo: password) // Note: This is for simulation only
//                .getDocuments { [weak self] (querySnapshot, error) in
//                    guard let self = self else { return }
//                    
//                    DispatchQueue.main.async {
//                        self.isLoading = false
//                        
//                        if let error = error {
//                            self.errorMessage = "Login failed: \(error.localizedDescription)"
//                            return
//                        }
//                        
//                        guard let documents = querySnapshot?.documents, !documents.isEmpty else {
//                            self.errorMessage = "Invalid email or password"
//                            return
//                        }
//                        
//                        // Use the first matching document
//                        let userData = documents[0]
//                        let userId = userData.documentID
//                        
//                        // Store user data in UserDefaults
//                        UserDefaults.standard.set(userData["email"] as? String ?? "", forKey: "userEmail")
//                        UserDefaults.standard.set(userData["fname"] as? String ?? "", forKey: "userName")
//                        UserDefaults.standard.set(userId, forKey: "userId")
//                        UserDefaults.standard.set(userData["isManager"] as? Bool ?? false, forKey: "isManager")
//
//                        // Set authenticated to true to trigger navigation
//                        self.isAuthenticated = true
//                    }
//                }
//        }
//        
//        private func handleLoginError(_ error: Error) {
//            errorMessage = "Login failed: \(error.localizedDescription)"
//        }
//    }



import SwiftUI
import FirebaseFirestore

class LoginViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var showPassword: Bool = false
    @Published var isLoading: Bool = false
    @Published var errorMessage: String = ""
    @Published var isAuthenticated: Bool = false
    @Published var isManager: Bool = false
    @Published var isAdmin: Bool = false
    @Published var userId: String? // Store logged-in user's ID

    private let db = Firestore.firestore()
    
    var isLoginDisabled: Bool {
        email.isEmpty || password.isEmpty || isLoading
    }
    
    func login() {
        guard !email.isEmpty && !password.isEmpty else {
            errorMessage = "Please enter both email and password"
            return
        }
        
        isLoading = true
        errorMessage = ""
        
        // Query Firestore for user with matching email and password
        db.collection("users")
            .whereField("email", isEqualTo: email)
            .whereField("password", isEqualTo: password) // Note: This is for simulation only
            .getDocuments { [weak self] (querySnapshot, error) in
                guard let self = self else { return }
                
                DispatchQueue.main.async {
                    self.isLoading = false
                    
                    if let error = error {
                        self.errorMessage = "Login failed: \(error.localizedDescription)"
                        return
                    }
                    
                    guard let documents = querySnapshot?.documents, let userData = documents.first else {
                        self.errorMessage = "Invalid email or password"
                        return
                    }
                    
                    // Extract user data
                    self.userId = userData.documentID
                    self.isManager = userData["isManager"] as? Bool ?? false
                    self.isAdmin = userData["isAdmin"] as? Bool ?? false
                    
                    // Save user data in UserDefaults
                    UserDefaults.standard.set(self.email, forKey: "userEmail")
                    UserDefaults.standard.set(userData["fname"] as? String ?? "", forKey: "userName")
                    UserDefaults.standard.set(self.userId, forKey: "userId")
                    UserDefaults.standard.set(self.isManager, forKey: "isManager")
                    UserDefaults.standard.set(self.isAdmin, forKey: "isAdmin")

                    // Authenticate user
                    self.isAuthenticated = true
                }
            }
    }
}
