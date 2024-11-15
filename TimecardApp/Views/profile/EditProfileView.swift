//
//  EditProfileView.swift
//  TimecardApp
//
//  Created by Damian Rozycki on 11/13/24.
//
import SwiftUI
import FirebaseFirestore

struct EditProfileView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var viewModel: ProfileViewModel
    @State private var editingSection: EditingSection
    
    @State private var firstName: String
    @State private var lastName: String
    @State private var phone: String
    @State private var title: String
    @State private var branch: String
    @State private var department: String
    @State private var location: String
    
    init(viewModel: ProfileViewModel, editingSection: EditingSection) {
        self.viewModel = viewModel
        self.editingSection = editingSection
        _firstName = State(initialValue: viewModel.firstName)
        _lastName = State(initialValue: viewModel.lastName)
        _phone = State(initialValue: viewModel.phone)
        _title = State(initialValue: viewModel.title)
        _branch = State(initialValue: viewModel.branch)
        _department = State(initialValue: viewModel.department)
        _location = State(initialValue: viewModel.location)
    }
    
    var body: some View {
        NavigationView {
            Form {
                if editingSection == .information {
                    
                    Section(header: Text("Personal Information")) {
                        TextField("First Name", text: $firstName)
                        TextField("Last Name", text: $lastName)
                        TextField("Phone", text: $phone)
                            .keyboardType(.phonePad)
                    }
                }
                
                if editingSection == .workDetails {
                    
                    Section(header: Text("Work Details")) {
                        TextField("Title", text: $title)
                        TextField("Branch", text: $branch)
                        TextField("Department", text: $department)
                        TextField("Location", text: $location)
                    }}
            }
            .navigationTitle("Edit Profile")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .bold()
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        viewModel.updateProfile(
                            firstName: firstName,
                            lastName: lastName,
                            phone: phone,
                            title: title,
                            branch: branch,
                            department: department,
                            location: location
                        )
                        dismiss()
                    }
                    .bold()

                }
            }
            .overlay {
                if viewModel.isLoading {
                    ProgressView()
                        .scaleEffect(1.5)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(Color.black.opacity(0.1))
                }
            }
        }
    }
}
