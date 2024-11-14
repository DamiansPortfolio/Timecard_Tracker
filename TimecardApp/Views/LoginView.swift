import SwiftUI
import FirebaseAuth

struct LoginView: View {
    @StateObject private var viewModel = LoginViewModel()
    @FocusState private var focusedField: Field?
    
    enum Field {
        case email, password
    }
    
    var body: some View {
        VStack {
            // Background
            Color.teal
                .ignoresSafeArea()
            
            // Content
            VStack(spacing: 25) {
                // Logo
                Image(systemName: "person.crop.circle.badge.clock")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .foregroundColor(.white)
                
                Text("MyTimecard+")
                    .font(.system(size: 32, weight: .bold))
                    .foregroundColor(.white)
                
                // Login Form
                VStack(spacing: 15) {
                    // Email
                    VStack(alignment: .leading) {
                        TextField("", text: $viewModel.email)
                            .placeholder(when: viewModel.email.isEmpty) {
                                Text("Email").foregroundColor(.white.opacity(0.7))
                            }
                            .textInputAutocapitalization(.never)
                            .keyboardType(.emailAddress)
                            .focused($focusedField, equals: .email)
                            .submitLabel(.next)
                    }
                    .modifier(CustomFieldModifier())
                    
                    // Password
                    VStack(alignment: .leading) {
                        HStack {
                            if viewModel.showPassword {
                                TextField("", text: $viewModel.password)
                                    .placeholder(when: viewModel.password.isEmpty) {
                                        Text("Password").foregroundColor(.white.opacity(0.7))
                                    }
                            } else {
                                SecureField("", text: $viewModel.password)
                                    .placeholder(when: viewModel.password.isEmpty) {
                                        Text("Password").foregroundColor(.white.opacity(0.7))
                                    }
                            }
                            
                            Button {
                                viewModel.showPassword.toggle()
                            } label: {
                                Image(systemName: viewModel.showPassword ? "eye.slash" : "eye")
                                    .foregroundColor(.white)
                            }
                        }
                        .focused($focusedField, equals: .password)
                        .submitLabel(.done)
                    }
                    .modifier(CustomFieldModifier())
                }
                
                // Error Message
                if !viewModel.errorMessage.isEmpty {
                    Text(viewModel.errorMessage)
                        .foregroundColor(.red)
                        .font(.caption)
                        .multilineTextAlignment(.center)
                }
                
                // Login Button
                Button {
                    viewModel.login()
                } label: {
                    ZStack {
                        Text("Login")
                            .font(.headline)
                            .foregroundColor(.teal)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(10)
                        
                        if viewModel.isLoading {
                            ProgressView()
                                .tint(.teal)
                        }
                    }
                }
                .disabled(viewModel.isLoginDisabled)
                
                Button("Forgot Password?") {
                    // Handle forgot password
                }
                .foregroundColor(.white)
            }
            .padding(.horizontal, 30)
        }
        .background(Color.teal)
        .fullScreenCover(isPresented: $viewModel.isAuthenticated) {
            ProfileView()
        }
        .onSubmit {
            switch focusedField {
            case .email:
                focusedField = .password
            case .password:
                viewModel.login()
            case .none:
                break
            }
        }
    }
}

// Custom Modifiers
struct CustomFieldModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .foregroundColor(.white)
            .padding()
            .background(Color.white.opacity(0.2))
            .cornerRadius(10)
    }
}

// Placeholder Extension
extension View {
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content) -> some View {
        
        ZStack(alignment: alignment) {
            placeholder().opacity(shouldShow ? 1 : 0)
            self
        }
    }
}

#Preview {
    LoginView()
}
