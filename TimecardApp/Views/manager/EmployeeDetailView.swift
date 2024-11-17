struct EmployeeDetailView: View {
    let employee: Profile
    @StateObject private var viewModel = EmployeeDetailViewModel(employee: employee)
    
    var body: some View {
        VStack {
            // Employee Details
            VStack(alignment: .leading, spacing: 10) {
                Text("Name: \(employee.fname) \(employee.lname)")
                Text("Title: \(employee.title)")
                Text("Department: \(employee.department)")
                Text("Email: \(employee.email)")
                Text("Phone: \(employee.phone)")
            }
            .padding()
            
            Divider()
            
            // Timecards Section
            Text("Timecards")
                .font(.title2)
                .padding()
            
            if viewModel.timecards.isEmpty {
                Text("No timecards available")
                    .foregroundColor(.gray)
                    .padding()
            } else {
                List(viewModel.timecards) { timecard in
                    HStack {
                        VStack(alignment: .leading) {
                            Text("Date: \(timecard.date)")
                            Text("Hours: \(timecard.totalHours)")
                        }
                        Spacer()
                        if timecard.status == .submitted {
                            HStack {
                                Button("Approve") {
                                    viewModel.updateTimecardStatus(timecard, to: .approved)
                                }
                                .buttonStyle(.bordered)
                                Button("Reject") {
                                    viewModel.updateTimecardStatus(timecard, to: .rejected)
                                }
                                .buttonStyle(.bordered)
                            }
                        } else {
                            Text(timecard.status.rawValue.capitalized)
                                .foregroundColor(.gray)
                        }
                    }
                }
            }
        }
        .onAppear {
            viewModel.fetchTimecards()
        }
    }
}
