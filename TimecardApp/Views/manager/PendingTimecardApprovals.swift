import SwiftUI

struct PendingTimecardApprovals: View {
    @StateObject var viewModel: ManagerViewModel
    let managerId: String
    
    var body: some View {
        NavigationView {
            List {
                ForEach(groupedTimecardsByEmployee(), id: \.key) {employee, timecards in
                    Section(header: Text("\(employee.firstName) \(employee.lastName)").font(.headline)) {
                        ForEach(timecards) { timecard in
                            VStack(alignment: .leading) {
                                Text(timecard.date.formatted(.dateTime.weekday(.wide).month(.wide).day().year()))
                                    .font(.headline)
                                    .foregroundColor(.teal)
                                VStack(alignment: .leading) {
                                    Text("Employee: \(timecard.firstName) \(timecard.lastName)")
                                    Text("Code: \(timecard.jobCode)")
                                    Text("\(formatTime(timecard.startTime)) - \(formatTime(timecard.endTime))")
                                    Text("Break (hours): \(timecard.breakDuration, specifier: "%.1f")")
                                    Text("Total hours: \(timecard.totalHours, specifier: "%.1f")")
                                        .bold()
                                }
                                .font(.subheadline)
                            }
                            .swipeActions(edge: .leading) {
                                Button("Reject") {
                                    viewModel.rejectTimecard(timecard)
                                }
                                .tint(.red)
                            }
                            .swipeActions(edge: .trailing) {
                                Button("Approve") {
                                    viewModel.approveTimecard(timecard)
                                }
                                .tint(.green)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Pending Approvals")
            .onAppear {
                viewModel.fetchManagerData(managerId: managerId)
            }
        }
    }
    
        // Groups timecards by employee
    private func groupedTimecardsByEmployee() -> [(key: Employee, value: [Timecard])] {
        let grouped = Dictionary(grouping: viewModel.pendingTimecards) { timecard in
            Employee(firstName: timecard.firstName, lastName: timecard.lastName)
        }
        return grouped
            .map { (key: $0.key, value: $0.value) }
            .sorted { $0.key.lastName < $1.key.lastName } // Sort by employee name
    }
    
        // Helper method to format time
    private func formatTime(_ time: Date) -> String {
        return time.formatted(.dateTime.hour(.twoDigits(amPM: .abbreviated)).minute())
    }
}

struct Employee: Hashable {
    let firstName: String
    let lastName: String
}

