import SwiftUI

struct ProfileView: View {
    @StateObject private var viewModel = ProfileViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                
                Image(systemName: "person.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .foregroundColor(.teal)
                    .padding(.bottom, 20)
                
                VStack(alignment: .leading) {
                    HStack {
                        Image(systemName: "person.fill")
                            .foregroundColor(.teal)
                        Text("Username:")
                            .bold()
                            .foregroundColor(.teal)
                        Text("\(viewModel.username)")
                    }
                    
                    HStack {
                        Image(systemName: "envelope.fill")
                            .foregroundColor(.teal)
                        Text("Email:")
                            .bold()
                            .foregroundColor(.teal)
                        Text("\(viewModel.email)")
                    }

                    HStack {
                        Image(systemName: "macwindow")
                            .foregroundColor(.teal)
                        Text("Title:")
                            .bold()
                            .foregroundColor(.teal)
                        Text(viewModel.title)
                    }
                    
                    HStack {
                        Image(systemName: "building.columns.fill")
                            .foregroundColor(.teal)
                        Text("Branch:")
                            .bold()
                            .foregroundColor(.teal)
                        Text(viewModel.branch)
                    }
                    
                    HStack {
                        Image(systemName: "number.circle.fill")
                            .foregroundColor(.teal)
                        Text("Department:")
                            .bold()
                            .foregroundColor(.teal)
                        Text(viewModel.department)
                    }
                }
                .padding()
                .background(Color.white)
                .cornerRadius(15)

                Button(action: {
                    // Log out action
                }) {
                    Text("Log Out")
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .buttonStyle(.borderedProminent)
                .tint(.red)
                .padding(.top) // Optional: Add some space above the button
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity) // Make the VStack fill the available space
            .background(Color.teal.opacity(0.3)) // Set the background color to teal
            .navigationTitle("Profile")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: EditProfileView(viewModel: viewModel)) {
                        Text("Edit")
                            .bold()
                            .foregroundColor(.white)
                            .padding(.horizontal, 13)
                            .padding(.vertical, 8)
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(.teal)
                            )
                    }
                }
            }
        }
    }
}

// Preview
struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
