//
//  ProfileView.swift
//  TimecardApp
//
//  Created by Damian Rozycki on 10/4/24.
//

import SwiftUI

struct ProfileView: View {
    @State private var username = "Damian Rozycki"
    @State private var email = "damian@example.com"
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("Username: \(username)")
                    .font(.headline)
                Text("Email: \(email)")
                    .font(.subheadline)
                Button(action: {
                    // Log out action
                }) {
                    Text("Log Out")
                        .foregroundColor(.red)
                }
            }
            .navigationTitle("Profile")
            .padding()
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
