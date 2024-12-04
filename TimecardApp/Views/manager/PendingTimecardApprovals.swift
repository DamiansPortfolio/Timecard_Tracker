import SwiftUI

struct PendingTimecardApprovals: View {
    @StateObject var viewModel: ManagerViewModel
    let managerId: String

    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Pending Timecards")) {
                    ForEach(viewModel.pendingTimecards) { timecard in
                        VStack(alignment: .leading) {
                            Text("Employee: \(timecard.firstName) \(timecard.lastName)")
                            Text("Date: \(timecard.date, style: .date)")
                            Text("Hours: \(timecard.totalHours, specifier: "%.2f")")
                        }
                        .swipeActions {
                            Button("Approve") {
                                viewModel.approveTimecard(timecard)
                            }
                            .tint(.green)

                            Button("Reject") {
                                viewModel.rejectTimecard(timecard)
                            }
                            .tint(.red)
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
}
