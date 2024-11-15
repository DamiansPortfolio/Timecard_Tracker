    //
    //  ChangePasswordView.swift
    //  TimecardApp
    //
    //  Created by Damian Rozycki on 11/14/24.
    //
import SwiftUI

struct ChangePasswordView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel: ProfileViewModel
    
    @State private var currentPassword = ""
    @State private var newPassword = ""
    @State private var confirmPassword = ""
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Current Password")) {
                    SecureField("Enter current password", text: $currentPassword)
                }
                
                Section(header: Text("New Password")) {
                    SecureField("Enter new password", text: $newPassword)
                    SecureField("Confirm new password", text: $confirmPassword)
                }
                
                Button("Update Password") {
                    if newPassword == confirmPassword {
                        viewModel.updatePassword(currentPassword: currentPassword, newPassword: newPassword)
                    }
                }
                .bold()
                .disabled(currentPassword.isEmpty || newPassword.isEmpty || confirmPassword.isEmpty || newPassword != confirmPassword)
                .frame(maxWidth: .infinity, alignment: .center)
            }
            .navigationTitle("Change Password")
            .toolbar {
                Button("Cancel") { dismiss() }
                    .bold()
            }
            .alert("Error", isPresented: $viewModel.showPasswordError) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(viewModel.passwordErrorMessage ?? "An error occurred")
            }
            .alert("Success", isPresented: $viewModel.showPasswordSuccess) {
                Button("OK") { dismiss() }
            } message: {
                Text("Password updated successfully")
            }
            .overlay {
                if viewModel.isLoading {
                    ProgressView()
                        .scaleEffect(1.5)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(Color.black.opacity(0.2))
                }
            }
        }
    }
}
