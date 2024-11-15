import SwiftUI
import FirebaseAuth

struct LoginView: View {
    @StateObject private var viewModel = LoginViewModel()
    @FocusState private var focusedField: Field?
    
    enum Field {
        case email, password
    }
    
    var body: some View {
        ZStack {
            // Background
            Color.teal
                .ignoresSafeArea()
            
            // Content
            VStack(spacing: 30) {
                // Logo
                Image(systemName: "person.crop.circle.badge.clock")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 150, height: 150)
                    .foregroundColor(.white)
                
                Text("MyTimecard+")
                    .font(.system(size: 35, weight: .bold))
                    .foregroundColor(.white)
                
                // Login Form
                VStack(spacing: 30) {
                    // Email
                    VStack(alignment: .leading) {
                        TextField("Email", text: $viewModel.email)
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
                                TextField("Password", text: $viewModel.password)
                                
                            } else {
                                SecureField("Password", text: $viewModel.password)
                                
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
            }
            .padding(.horizontal, 30)
        }
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


