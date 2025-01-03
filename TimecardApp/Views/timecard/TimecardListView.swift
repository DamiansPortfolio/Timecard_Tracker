
import SwiftUI

struct TimecardListView: View {
    @StateObject private var viewModel = TimecardListViewModel()
    @State private var showAddTimecardSheet = false // State variable for the sheet
    
    
    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach(viewModel.filteredTimecards) { timecard in
                        NavigationLink(destination: TimecardDetailView(timecard: timecard)) {
                            TimecardRowView(timecard: timecard)
                        }
                    }
                    .onDelete(perform: deleteTimecard)
                }
            }
            .navigationTitle("Timecards")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Menu {
                        Button("Most Recent") {
                            viewModel.sortByDateAscending()
                        }
                        Button("Oldest") {
                            viewModel.sortByDateDescending()
                        }
                    } label: {
                        Image(systemName:"arrow.up.arrow.down")
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
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Add") {
                        showAddTimecardSheet.toggle() // Present the sheet
                    }
                    .buttonStyle(.borderedProminent)
                    .bold()
                }
            }
        }
        .sheet(isPresented: $showAddTimecardSheet) {
            AddTimecardView(viewModel: viewModel)
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
            Text(timecard.date.formatted(.dateTime.weekday(.wide).month(.wide).day().year()))
                .font(.headline)
            Text("Hours: \(timecard.totalHours, specifier: "%.2f")")
                .font(.subheadline)
            HStack {
                Text("Status:")
                    .font(.subheadline)
                    .foregroundColor(.black)
                Text(timecard.status.rawValue.capitalized) 
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
