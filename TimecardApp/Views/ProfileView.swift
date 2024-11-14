import SwiftUI

struct ProfileView: View {
    @StateObject private var viewModel = ProfileViewModel()
    @State private var isEditingProfile = false
    @State private var showChangePasswordSheet = false
    @AppStorage("userId") private var userId: String?
    
    var body: some View {
        Group {
            if userId != nil {
                NavigationView {
                    ScrollView {
                        VStack(spacing: 20) {
                            Image(systemName: "person.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 100, height: 100)
                                .foregroundColor(.teal)
                            
                            if viewModel.isLoading {
                                ProgressView()
                                    .tint(.teal)
                            } else {
                                    // Information Section
                                VStack(alignment: .leading, spacing: 10) {
                                    HStack {
                                        Text("Information")
                                            .font(.title)
                                            .bold()
                                            .foregroundColor(.teal)
                                        Spacer()
                                        Button("Edit") {
                                            isEditingProfile.toggle()
                                        }
                                        .buttonStyle(.bordered)
                                        .tint(.teal)
                                        .bold()
                                    }
                                    ProfileInfoRow(label: "Name:", value: "\(viewModel.firstName) \(viewModel.lastName)")
                                    ProfileInfoRow(label: "Email:", value: viewModel.email)
                                    ProfileInfoRow(label: "Phone:", value: viewModel.phone)
                                }
                                .padding()
                                .background(Color.white)
                                .cornerRadius(15)
                                .shadow(radius: 5)
                                
                                    // Work Details Section
                                VStack(alignment: .leading, spacing: 10) {
                                    HStack {
                                        Text("Work Details")
                                            .font(.title)
                                            .bold()
                                            .foregroundColor(.teal)
                                        Spacer()
                                    }
                                    ProfileInfoRow(label: "Title:", value: viewModel.title)
                                    ProfileInfoRow(label: "Branch:", value: viewModel.branch)
                                    ProfileInfoRow(label: "Department:", value: viewModel.department)
                                    ProfileInfoRow(label: "Location:", value: viewModel.location)
                                }
                                .padding()
                                .background(Color.white)
                                .cornerRadius(15)
                                .shadow(radius: 5)
                                
                                    // Settings Section
                                VStack(alignment: .leading, spacing: 10) {
                                    Text("Settings")
                                        .font(.title)
                                        .bold()
                                        .foregroundColor(.teal)
                                    
                                    Button("Change Password") {
                                        showChangePasswordSheet = true
                                    }
                                    .foregroundColor(.blue)
                                }
                                .padding()
                                .background(Color.white)
                                .cornerRadius(15)
                                .shadow(radius: 5)
                                
                                    // Support Section
                                VStack {
                                    Button("Contact Support") {
                                            // viewModel.contactSupport()
                                    }
                                    .foregroundColor(.blue)
                                }
                                .padding(.top, 10)
                            }
                            
                            if let error = viewModel.errorMessage {
                                Text(error)
                                    .foregroundColor(.red)
                                    .padding()
                            }
                            
                                // Log Out Button
                            Button(action: {
                                viewModel.logOut()
                                userId = nil
                            }) {
                                Text("Log Out")
                                    .foregroundColor(.white)
                            }
                            .buttonStyle(.borderedProminent)
                            .tint(.red)
                            .padding(.top, 20)
                        }
                        .padding()
                    }
                    .background(Color.teal.opacity(0.2))
                    .navigationTitle("Profile")
                    .sheet(isPresented: $isEditingProfile) {
                        EditProfileView(viewModel: viewModel)
                    }
                    .sheet(isPresented: $showChangePasswordSheet) {
                        ChangePasswordView(viewModel: viewModel)
                    }
                }
            } else {
                LoginView()
            }
        }
    }
}

struct ProfileInfoRow: View {
    var label: String
    var value: String
    
    var body: some View {
        HStack {
            Text(label)
                .fontWeight(.bold)
                .foregroundColor(.teal)
            Text(value)
        }
    }
}
