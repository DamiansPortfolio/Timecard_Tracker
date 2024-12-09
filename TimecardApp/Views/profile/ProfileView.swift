import SwiftUI

struct ProfileView: View {
    @StateObject private var viewModel = ProfileViewModel()
    @State private var isEditingProfile = false
    @State private var editingSection: EditingSection = .none
    @State private var showChangePasswordSheet = false
    @State private var showNotificationSettings = false  // Add this line
    @AppStorage("userId") private var userId: String?
    @AppStorage("isManager") private var isManager: Bool = false
    
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
                                            .font(.title2)
                                            .bold()
                                            .foregroundColor(.teal)
                                        Spacer()
                                        Button("Edit") {
                                            editingSection = .information
                                            isEditingProfile.toggle()
                                        }
                                        .buttonStyle(.bordered)
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
                                            .font(.title2)
                                            .bold()
                                            .foregroundColor(.teal)
                                        Spacer()
                                        Button("Edit") {
                                            editingSection = .workDetails
                                            isEditingProfile.toggle()
                                        }
                                        .buttonStyle(.bordered)
                                        .bold()
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
                                    HStack {
                                        Text("Settings")
                                            .font(.title2)
                                            .bold()
                                            .foregroundColor(.teal)
                                        Spacer()
                                    }
                                    
                                    Button(action: {
                                        showNotificationSettings = true
                                    }) {
                                        HStack {
                                            Text("Notifications")
                                            Spacer()
                                            Image(systemName: "chevron.right")
                                                .foregroundColor(.gray)
                                        }
                                    }
                                    .foregroundColor(.black)
                                    
                                    Button(action: {
                                        showChangePasswordSheet = true
                                    }) {
                                        HStack {
                                            Text("Change Password")
                                            Spacer()
                                            Image(systemName: "chevron.right")
                                                .foregroundColor(.gray)
                                        }
                                    }
                                    .foregroundColor(.black)
                                }
                                .padding()
                                .background(Color.white)
                                .cornerRadius(15)
                                .shadow(radius: 5)
                            }
                            
                            if let error = viewModel.errorMessage {
                                Text(error)
                                    .foregroundColor(.red)
                                    .padding()
                            }
                            
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
                    .navigationTitle("Profile")
                    .sheet(isPresented: $isEditingProfile) {
                        EditProfileView(viewModel: viewModel, editingSection: editingSection)
                            .presentationDetents([.medium, .large])
                    }
                    .sheet(isPresented: $showChangePasswordSheet) {
                        ChangePasswordView(viewModel: viewModel)
                    }
                    .sheet(isPresented: $showNotificationSettings) {
                        NotificationSettingsView()
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
