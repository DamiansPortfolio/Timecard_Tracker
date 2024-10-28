import SwiftUI

struct JobCodeListView: View {
    @StateObject private var viewModel = JobCodeListViewModel()
    @State private var searchText: String = "" // State variable for search text
    
    var body: some View {
        NavigationView {
            VStack {
                
                HStack {
                    TextField("Search", text: $searchText)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .cornerRadius(15)
                        .padding(.trailing, 10)
                        .onChange(of: searchText, initial: true) { oldValue, newValue in
                            viewModel.filterByText(newValue)
                        }
                    
                    Button(action: {
                        // Clear the filter text
                        viewModel.filterByText(nil)
                        searchText = ""
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(searchText.isEmpty ? .gray : .teal) // Change color based on state
                            .font(.system(size: 24)) // Increase size of the X mark
                    }
                    .disabled(searchText.isEmpty)
                }
                .padding(40)
                
                List {
                    if viewModel.filteredJobCodes.isEmpty {
                        Text("No matching code found in the list!")
                            .foregroundColor(.gray)
                    } else {
                        ForEach(viewModel.filteredJobCodes) { jobCode in
                            Button(action: {
                                viewModel.selectedJobCode = jobCode // Set the selected job code
                            }) {
                                Text(jobCode.name)
                            }
                        }
                    }
                }
                .listStyle(.inset)
                .cornerRadius(15)
                .padding([.trailing, .leading, .bottom], 40)
                .sheet(item: $viewModel.selectedJobCode) { jobCode in
                    JobCodeDetailView(jobCode: jobCode)
                        .presentationDetents([.medium]) // Make the sheet take up half the screen
                }
            }
            .navigationTitle("Job Codes")
            .background(Color.teal.opacity(0.3))
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Menu {
                        Button("Sort Alphabetically") {
                            viewModel.sortAlphabetically()
                        }
                    } label: {
                        Image(systemName: "arrow.up.arrow.down")
                            .foregroundColor(.teal)
                            .bold()
                    }
                }
            }
        }
    }
}

struct JobCodeListView_Previews: PreviewProvider {
    static var previews: some View {
        JobCodeListView()
    }
}
