import SwiftUI

struct ProfileView: View {
    @StateObject private var viewModel = ProfileViewModel()
    @State private var isEditingProfile = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    
                    Image(systemName: "person.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                        .foregroundColor(.teal)
                    
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
                        ProfileInfoRow(label: "Username:", value: viewModel.username)
                        ProfileInfoRow(label: "Email:", value: viewModel.email)
                        ProfileInfoRow(label: "Phone:", value: viewModel.phone)
                        ProfileInfoRow(label: "Emergency Contact:", value: viewModel.emergencyContact)
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(15)
                    .shadow(radius: 5)

                    VStack(alignment: .leading, spacing: 10) {
                        HStack {
                            Text("Summary")
                                .font(.title)
                                .bold()
                                .foregroundColor(.teal)
                            Spacer()
                        }
                        ProfileInfoRow(label: "Title:", value: viewModel.latestPosition)
                        ProfileInfoRow(label: "Branch:", value: viewModel.branch)
                        ProfileInfoRow(label: "Department:", value: viewModel.department)
                        ProfileInfoRow(label: "Hours Worked This Month:", value: "\(viewModel.monthlyHours)")
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(15)
                    .shadow(radius: 5)
                    
                    // Documents Section with NavigationLink
                    VStack(alignment: .leading, spacing: 10) {
                        NavigationLink(destination: DocumentsView()) {
                            HStack {
                                Text("Documents")
                                    .font(.title)
                                    .bold()
                                    .foregroundColor(.teal)
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .foregroundColor(.teal)
                            }
                        }
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
                        
                        Toggle(isOn: $viewModel.notificationsEnabled) {
                            Text("Enable Notifications")
                        }
                        .toggleStyle(SwitchToggleStyle(tint: .teal))
                        
                        Button("Change Password") {
                            viewModel.changePassword()
                        }
                        .foregroundColor(.blue)
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(15)
                    .shadow(radius: 5)
                    
                    // Feedback or Support Section
                    VStack {
                        Button("Contact Support") {
                            viewModel.contactSupport()
                        }
                        .foregroundColor(.blue)
                    }
                    .padding(.top, 10)
                    
                    // Log Out Button
                    Button(action: {
                        viewModel.logOut()
                    }) {
                        Text("Log Out")
                            .foregroundColor(.white)
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.red)
                }
                .padding()
            }
            .background(Color.teal.opacity(0.2))
            .navigationTitle("Profile")
            .sheet(isPresented: $isEditingProfile) {
                EditProfileView(viewModel: viewModel)
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

struct EditProfileView: View {
    @ObservedObject var viewModel: ProfileViewModel
    
    var body: some View {
        Text("Edit Profile View") // Customize further as needed
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
