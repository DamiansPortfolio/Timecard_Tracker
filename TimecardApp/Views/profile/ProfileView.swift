import SwiftUI

struct ProfileView: View {
    @StateObject private var viewModel = ProfileViewModel()
    @State private var isEditingProfile = false
    @State private var editingSection: EditingSection = .none
    @State private var showChangePasswordSheet = false
    @AppStorage("userId") private var userId: String?
    @AppStorage("isManager") private var isManager: Bool = false // Added isManager status
    
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
                                    Button("Change Password") {
                                        showChangePasswordSheet = true
                                    }
                                    .foregroundColor(.black)
//                                    NavigationLink(destination: SystemsLogView(viewModel: viewModel)) {
//                                        HStack {
//                                            Image(systemName: "doc.text.magnifyingglass")
//                                            Text("System Logs")
//                                        }
//                                        .foregroundColor(.black)
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

//import SwiftUI
//
//struct ProfileView: View {
//    @StateObject private var viewModel = ProfileViewModel()
//    @State private var isEditingProfile = false
//    @State private var editingSection: EditingSection = .none
//    @State private var showChangePasswordSheet = false
//    @AppStorage("userId") private var userId: String?
//    @AppStorage("isManager") private var isManager: Bool = false // Added isManager status
//
//    var body: some View {
//        Group {
//            if userId != nil {
//                NavigationView {
//                    ScrollView {
//                        VStack(spacing: 20) {
//                            ProfileHeader()
//                            if viewModel.isLoading {
//                                ProgressView()
//                                    .tint(.teal)
//                            } else {
//                                InformationSection(
//                                    viewModel: viewModel,
//                                    editingSection: $editingSection,
//                                    isEditingProfile: $isEditingProfile
//                                )
//                                WorkDetailsSection(
//                                    viewModel: viewModel,
//                                    editingSection: $editingSection,
//                                    isEditingProfile: $isEditingProfile
//                                )
//                                SettingsSection(
//                                    viewModel: viewModel,
//                                    showChangePasswordSheet: $showChangePasswordSheet
//                                )
//                                if let error = viewModel.errorMessage {
//                                    Text(error)
//                                        .foregroundColor(.red)
//                                        .padding()
//                                }
//                                LogoutButton(action: {
//                                    viewModel.logOut()
//                                    userId = nil
//                                })
//                            }
//                        }
//                        .padding()
//                        .navigationTitle("Profile")
//                        .sheet(isPresented: $isEditingProfile) {
//                            EditProfileView(viewModel: viewModel, editingSection: editingSection)
//                                .presentationDetents([.medium, .large])
//                        }
//                        .sheet(isPresented: $showChangePasswordSheet) {
//                            ChangePasswordView(viewModel: viewModel)
//                        }
//                    }
//                }
//            } else {
//                LoginView()
//            }
//        }
//    }
//}
//
//// MARK: - Subviews
//
//struct ProfileHeader: View {
//    var body: some View {
//        Image(systemName: "person.fill")
//            .resizable()
//            .scaledToFit()
//            .frame(width: 100, height: 100)
//            .foregroundColor(.teal)
//    }
//}
//
//struct InformationSection: View {
//    let viewModel: ProfileViewModel
//    @Binding var editingSection: EditingSection
//    @Binding var isEditingProfile: Bool
//
//    var body: some View {
//        VStack(alignment: .leading, spacing: 10) {
//            SectionHeader(title: "Information") {
//                editingSection = .information
//                isEditingProfile.toggle()
//            }
//            ProfileInfoRow(label: "Name:", value: "\(viewModel.firstName) \(viewModel.lastName)")
//            ProfileInfoRow(label: "Email:", value: viewModel.email)
//            ProfileInfoRow(label: "Phone:", value: viewModel.phone)
//        }
//        .sectionStyle()
//    }
//}
//
//struct WorkDetailsSection: View {
//    let viewModel: ProfileViewModel
//    @Binding var editingSection: EditingSection
//    @Binding var isEditingProfile: Bool
//
//    var body: some View {
//        VStack(alignment: .leading, spacing: 10) {
//            SectionHeader(title: "Work Details") {
//                editingSection = .workDetails
//                isEditingProfile.toggle()
//            }
//            ProfileInfoRow(label: "Title:", value: viewModel.title)
//            ProfileInfoRow(label: "Branch:", value: viewModel.branch)
//            ProfileInfoRow(label: "Department:", value: viewModel.department)
//            ProfileInfoRow(label: "Location:", value: viewModel.location)
//        }
//        .sectionStyle()
//    }
//}
//
//struct SettingsSection: View {
//    let viewModel: ProfileViewModel
//    @Binding var showChangePasswordSheet: Bool
//    
//    var body: some View {
//        VStack(alignment: .leading, spacing: 10) {
//            SectionHeader(title: "Settings")
//            Button("Change Password") {
//                showChangePasswordSheet = true
//            }
//            .foregroundColor(.black)
//            NavigationLink(destination: SystemsLogView(viewModel: TimecardListViewModel())) {
//                HStack {
//                    Image(systemName: "doc.text.magnifyingglass")
//                    Text("System Logs")
//                }
//                .foregroundColor(.black)
//            }
//            
//        }
//        .sectionStyle()
//    }
//}
//
//struct LogoutButton: View {
//    let action: () -> Void
//
//    var body: some View {
//        Button(action: action) {
//            Text("Log Out")
//                .foregroundColor(.white)
//        }
//        .buttonStyle(.borderedProminent)
//        .tint(.red)
//        .padding(.top, 20)
//    }
//}
//
//// MARK: - Reusable Components
//
//struct SectionHeader: View {
//    let title: String
//    var editAction: (() -> Void)? = nil
//
//    var body: some View {
//        HStack {
//            Text(title)
//                .font(.title2)
//                .bold()
//                .foregroundColor(.teal)
//            Spacer()
//            if let editAction = editAction {
//                Button("Edit", action: editAction)
//                    .buttonStyle(.bordered)
//                    .bold()
//            }
//        }
//    }
//}
//
//struct ProfileInfoRow: View {
//    var label: String
//    var value: String
//
//    var body: some View {
//        HStack {
//            Text(label)
//                .fontWeight(.bold)
//                .foregroundColor(.teal)
//            Text(value)
//        }
//    }
//}
//
//// MARK: - View Modifiers
//
//extension View {
//    func sectionStyle() -> some View {
//        self
//            .padding()
//            .background(Color.white)
//            .cornerRadius(15)
//            .shadow(radius: 5)
//    }
//}
