
import SwiftUI

struct TimecardListView: View {
    @StateObject private var viewModel = TimecardListViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Timecards")
                    .font(.largeTitle)
                    .bold()
                List {
                    ForEach(viewModel.filteredTimecards) { timecard in
                        NavigationLink(destination: TimecardDetailView(timecard: timecard)) {
                            TimecardRowView(timecard: timecard)
                        }
                    }
                    .onDelete(perform: deleteTimecard)
                }
                .listStyle(.inset)
                .cornerRadius(15)
                .padding([.trailing, .leading, .bottom], 40)

                
            }
            .background(Color.teal.opacity(0.2))
            .toolbar {
                
                ToolbarItem(placement: .navigationBarLeading) {
                    Menu {
                        Button("Sort by Date") {
                            viewModel.sortByDate()
                        }
                    } label: {
                        Image(systemName:"arrow.up.arrow.down")
                            .foregroundColor(.teal)
                            .bold()
                    }
                }
                
                ToolbarItem(placement: .navigationBarLeading) {
                    Menu {
                        Button("All") {
                            viewModel.filterByStatus(nil)
                        }
                        Button("Draft") {
                            viewModel.filterByStatus(.draft)
                        }
                        Button("Submitted") {
                            viewModel.filterByStatus(.submitted)
                        }
                        Button("Approved") {
                            viewModel.filterByStatus(.approved)
                        }
                        Button("Rejected") {
                            viewModel.filterByStatus(.rejected)
                        }
                    } label: {
                        Image(systemName: "line.3.horizontal.decrease")
                            .bold()
                            .foregroundColor(.teal)
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        viewModel.addNewTimecard(date: Date(), totalHours: 8.0, status: .draft)
                    }) {
                        Text("Add")
                            .bold()                            .foregroundColor(.white)
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.teal)
                }
            }
        }
    }
    
    private func deleteTimecard(at offsets: IndexSet) {
        offsets.forEach { index in
            let timecard = viewModel.filteredTimecards[index]
            viewModel.deleteTimecard(timecard)
        }
    }
}

struct TimecardRowView: View {
    let timecard: Timecard

    var body: some View {
        VStack(alignment: .leading) {
            Text(timecard.date, style: .date)
                .font(.headline)
            Text("Hours: \(timecard.totalHours, specifier: "%.2f")")
                .font(.subheadline)
            HStack {
                Text("Status:") // Label for status
                    .font(.subheadline)
                    .foregroundColor(.black) // Standard black color
                Text(timecard.status.rawValue.capitalized) // Status value
                    .font(.subheadline)
                    .foregroundColor(statusColor(for: timecard.status))
            }
        }
    }

    private func statusColor(for status: TimecardStatus) -> Color {
        switch status {
        case .draft: return .gray
        case .submitted: return .blue
        case .approved: return .green
        case .rejected: return .red
        }
    }
}


struct TimecardListView_Previews: PreviewProvider {
    static var previews: some View {
        TimecardListView()
    }
}
