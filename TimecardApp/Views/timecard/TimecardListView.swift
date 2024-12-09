//
//import SwiftUI
//
//struct TimecardListView: View {
//    @StateObject private var viewModel = TimecardListViewModel()
//    @State private var showAddTimecardSheet = false // State variable for the sheet
//    
//    
//    var body: some View {
//        NavigationView {
//            VStack {
//                List {
//                    ForEach(viewModel.filteredTimecards) { timecard in
//                        NavigationLink(destination: TimecardDetailView(timecard: timecard)) {
//                            TimecardRowView(timecard: timecard)
//                        }
//                    }
//                    .onDelete(perform: deleteTimecard)
//                }
//            }
//            .navigationTitle("Timecards")
//            .toolbar {
//                ToolbarItem(placement: .navigationBarLeading) {
//                    Menu {
//                        Button("Most Recent") {
//                            viewModel.sortByDateAscending()
//                        }
//                        Button("Oldest") {
//                            viewModel.sortByDateDescending()
//                        }
//                    } label: {
//                        Image(systemName:"arrow.up.arrow.down")
//                            .bold()
//                    }
//                }
//                
//                ToolbarItem(placement: .navigationBarLeading) {
//                    Menu {
//                        Button("All") {
//                            viewModel.filterByStatus(nil)
//                        }
//                        Button("Draft") {
//                            viewModel.filterByStatus(.draft)
//                        }
//                        Button("Submitted") {
//                            viewModel.filterByStatus(.submitted)
//                        }
//                        Button("Approved") {
//                            viewModel.filterByStatus(.approved)
//                        }
//                        Button("Rejected") {
//                            viewModel.filterByStatus(.rejected)
//                        }
//                    } label: {
//                        Image(systemName: "line.3.horizontal.decrease")
//                            .bold()
//                    }
//                }
//                
//                ToolbarItem(placement: .navigationBarTrailing) {
//                    Button("Add") {
//                        showAddTimecardSheet.toggle() // Present the sheet
//                    }
//                    .buttonStyle(.borderedProminent)
//                    .bold()
//                }
//            }
//        }
//        .sheet(isPresented: $showAddTimecardSheet) {
//            if viewModel.selectedMode == .ClockInOut {
//                AddTimecardViewCIO(viewModel: viewModel)
//            } else {
//                AddTimecardView(viewModel: viewModel)
//            }
//        }
//    }
//    
//    private func deleteTimecard(at offsets: IndexSet) {
//        offsets.forEach { index in
//            let timecard = viewModel.filteredTimecards[index]
//            viewModel.deleteTimecard(timecard)
//        }
//    }
//}
//
//struct TimecardRowView: View {
//    let timecard: Timecard
//    
//    var body: some View {
//        VStack(alignment: .leading) {
//            Text(timecard.date.formatted(.dateTime.weekday(.wide).month(.wide).day().year()))
//                .font(.headline)
//            Text("Hours: \(timecard.totalHours, specifier: "%.2f")")
//                .font(.subheadline)
//            HStack {
//                Text("Status:")
//                    .font(.subheadline)
//                    .foregroundColor(.black)
//                Text(timecard.status.rawValue.capitalized) 
//                    .font(.subheadline)
//                    .foregroundColor(statusColor(for: timecard.status))
//            }
//        }
//    }
//    
//    private func statusColor(for status: TimecardStatus) -> Color {
//        switch status {
//        case .draft: return .gray
//        case .submitted: return .blue
//        case .approved: return .green
//        case .rejected: return .red
//        }
//    }
//}

//import SwiftUI
//
//struct TimecardListView: View {
//    @ObservedObject var viewModel: TimecardListViewModel
//    @State private var showAddTimecardSheet = false // State variable for the sheet
// 
//    
//    var body: some View {
//        NavigationView {
//            VStack {
//                List {
//                    ForEach(viewModel.filteredTimecards) { timecard in
//                        NavigationLink(destination: TimecardDetailView(timecard: timecard)) {
//                            TimecardRowView(timecard: timecard)
//                        }
//                    }
//                    .onDelete(perform: deleteTimecard)
//                }
//            }
//            .navigationTitle("Timecards")
//            .toolbar {
//                ToolbarItem(placement: .navigationBarLeading) {
//                    Menu {
//                        Button("Most Recent") {
//                            viewModel.sortByDateAscending()
//                        }
//                        Button("Oldest") {
//                            viewModel.sortByDateDescending()
//                        }
//                    } label: {
//                        Image(systemName:"arrow.up.arrow.down")
//                            .bold()
//                    }
//                }
//                
//                ToolbarItem(placement: .navigationBarLeading) {
//                    Menu {
//                        Button("All") {
//                            viewModel.filterByStatus(nil)
//                        }
//                        Button("Draft") {
//                            viewModel.filterByStatus(.draft)
//                        }
//                        Button("Submitted") {
//                            viewModel.filterByStatus(.submitted)
//                        }
//                        Button("Approved") {
//                            viewModel.filterByStatus(.approved)
//                        }
//                        Button("Rejected") {
//                            viewModel.filterByStatus(.rejected)
//                        }
//                    } label: {
//                        Image(systemName: "line.3.horizontal.decrease")
//                            .bold()
//                    }
//                }
//                
//                ToolbarItem(placement: .navigationBarTrailing) {
//                    Button("Add") {
//                        showAddTimecardSheet.toggle() // Present the sheet
//                    }
//                    .buttonStyle(.borderedProminent)
//                    .bold()
//                }
//            }
//        }
//        .sheet(isPresented: $showAddTimecardSheet) {
//            if viewModel.selectedMode == .ClockInOut {
//                AddTimecardViewCIO(viewModel: viewModel)
//            } else {
//                AddTimecardView(viewModel: viewModel)
//            }
//        }
//
////        .sheet(isPresented: $showAddTimecardSheet) {
////            if viewModel.selectedMode == .ClockInOut {
////                AddTimecardViewCIO(viewModel: viewModel)
////            } else {
////                AddTimecardView(viewModel: viewModel)
////            }
////        }
//    }
//    
//    private func deleteTimecard(at offsets: IndexSet) {
//        offsets.forEach { index in
//            let timecard = viewModel.filteredTimecards[index]
//            viewModel.deleteTimecard(timecard)
//        }
//    }
//}
//
//struct TimecardRowView: View {
//    let timecard: Timecard
//    
//    var body: some View {
//        VStack(alignment: .leading) {
//            Text(timecard.date, style: .date)
//                .font(.headline)
//            Text("Hours: \(timecard.totalHours, specifier: "%.2f")")
//                .font(.subheadline)
//            HStack {
//                Text("Status:")
//                    .font(.subheadline)
//                    .foregroundColor(.black)
//                Text(timecard.status.rawValue.capitalized)
//                    .font(.subheadline)
//                    .foregroundColor(statusColor(for: timecard.status))
//            }
//        }
//    }
//    
//    private func statusColor(for status: TimecardStatus) -> Color {
//        switch status {
//        case .draft: return .gray
//        case .submitted: return .blue
//        case .approved: return .green
//        case .rejected: return .red
//        }
//    }
//}




import SwiftUI
import FirebaseFirestore

struct TimecardListView: View {
    @ObservedObject var viewModel: TimecardListViewModel
    @State private var showAddTimecardSheet = false // State variable for the sheet
    @State private var selectedMode: String = "ClockInOut" // Default to ClockInOut
    @State private var isLoading: Bool = true // Loading state for fetching mode
    @State private var errorMessage: String?

    var body: some View {
        NavigationView {
            VStack {
                if isLoading {
                    ProgressView("Loading Timecards...")
                } else {
                    List {
                        ForEach(viewModel.filteredTimecards) { timecard in
                            NavigationLink(destination: TimecardDetailView(timecard: timecard)) {
                                TimecardRowView(timecard: timecard)
                            }
                        }
                        .onDelete(perform: deleteTimecard)
                    }
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
                        Image(systemName: "arrow.up.arrow.down")
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
            if selectedMode == "ClockInOut" {
                AddTimecardViewCIO(viewModel: viewModel)
            } else {
                AddTimecardView(viewModel: viewModel)
            }
        }
        .onAppear {
            fetchSelectedMode()
        }
    }

    private func deleteTimecard(at offsets: IndexSet) {
        offsets.forEach { index in
            let timecard = viewModel.filteredTimecards[index]
            viewModel.deleteTimecard(timecard)
        }
    }

    // Fetch the selected mode from Firestore
    private func fetchSelectedMode() {
        let db = Firestore.firestore()
        let documentId = "timecardSettings" // Replace with your Firestore document ID

        isLoading = true

        db.collection("adminSettings").document(documentId).getDocument { snapshot, error in
            if let error = error {
                print("Error fetching selected mode: \(error.localizedDescription)")
                self.errorMessage = "Failed to fetch selected mode."
                self.isLoading = false
                return
            }

            guard let data = snapshot?.data() else {
                print("No data found for selected mode.")
                self.errorMessage = "No data found."
                self.isLoading = false
                return
            }

            // Update the selectedMode based on Firestore data
            self.selectedMode = data["ClockInOutEnabled"] as? Bool == true ? "ClockInOut" : "SelectHours"
            self.isLoading = false
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
