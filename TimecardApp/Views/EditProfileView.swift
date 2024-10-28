//
//  EditProfileView.swift
//  TimecardApp
//
//  Created by Anh Phan on 10/26/24.
//


import SwiftUI

struct EditProfileView: View {
    @ObservedObject var viewModel: ProfileViewModel

    var body: some View {
        VStack {
            Text("Edit Profile")
                .font(.largeTitle)
                .bold()

            // Add fields for editing profile data here
            // For example, TextFields to edit username, email, etc.

            Spacer()
        }
        .padding()
    }
}
