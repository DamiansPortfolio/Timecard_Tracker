import Foundation

class LoginViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    @Published var isAuthenticated = false
    @Published var showPassword = false

    var isLoginDisabled: Bool {
        email.isEmpty || password.isEmpty
    }

    func login() {
        // Perform authentication (this is just a placeholder)
        if email == "test@example.com" && password == "password123" {
            isAuthenticated = true
        } else {
            // Handle login failure, e.g., show an error message
            isAuthenticated = false
        }
    }
}
