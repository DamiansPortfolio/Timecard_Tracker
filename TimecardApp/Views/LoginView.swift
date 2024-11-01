import SwiftUI

struct LoginView: View {
    @StateObject private var viewModel = LoginViewModel()
    
    var body: some View {
        ZStack {
            // Teal Background
            Color.teal
                .ignoresSafeArea()
            
            VStack {
                // User Icon
                Image(systemName: "person.crop.circle.badge.clock")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 150, height: 150)
                    .foregroundColor(.white)
                    .padding(.bottom, 20)
                
                // App Title
                Text("MyTimecard+")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.bottom, 40)
                
                // Email TextField
                TextField("Email", text: $viewModel.email)
                    .padding()
                    .background(Color.white.opacity(0.2))
                    .cornerRadius(10)
                    .foregroundColor(.white)
                    .padding(.horizontal, 20)
                
                // Password TextField with toggle visibility
                HStack {
                    if viewModel.showPassword {
                        TextField("Password", text: $viewModel.password)
                            .foregroundColor(.white)
                    } else {
                        SecureField("Password", text: $viewModel.password)
                            .foregroundColor(.white)
                    }
                    Button(action: {
                        viewModel.showPassword.toggle()
                    }) {
                        Image(systemName: viewModel.showPassword ? "eye.slash" : "eye")
                            .foregroundColor(.white)
                    }
                }
                .padding()
                .background(Color.white.opacity(0.2))
                .cornerRadius(10)
                .padding(.horizontal, 20)
                .padding(.top, 10)
                
                // Login Button
                Button(action: {
                    viewModel.login()
                }) {
                    Text("Login")
                        .font(.headline)
                        .foregroundColor(viewModel.isLoginDisabled ? Color.gray : Color.teal)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.white)
                        .cornerRadius(10)
                        .padding(.horizontal, 20)
                        .padding(.top, 20)
                }
                .disabled(viewModel.isLoginDisabled)
                
                // Forgot Password link
                Button(action: {
                    // Handle forgot password action
                }) {
                    Text("Forgot Password?")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding(.top, 10)
                }
            }
            .padding()
        }
    }
}

#Preview {
        LoginView()
}
