import Foundation

class TimecardListViewModel: ObservableObject {
    @Published var timecards: [Timecard] = []
    @Published var filteredTimecards: [Timecard] = []
    @Published var currentFilter: TimecardStatus? = nil

    init() {
        fetchTimecards()
    }
    
    func fetchTimecards() {
        // TODO: Replace with actual API call
        timecards = [
            Timecard(id: UUID(), date: Date(), totalHours: 8.0, status: .draft),
            Timecard(id: UUID(), date: Date().addingTimeInterval(-86400), totalHours: 7.5, status: .submitted),
            Timecard(id: UUID(), date: Date().addingTimeInterval(-172800), totalHours: 6.0, status: .approved),
            Timecard(id: UUID(), date: Date().addingTimeInterval(-259200), totalHours: 5.0, status: .rejected)
        ]
        filteredTimecards = timecards
    }
    
    // MARK: - Sorting

    func sortByDate() {
        filteredTimecards.sort { $0.date > $1.date }
    }

    // MARK: - Filtering

    func filterByStatus(_ status: TimecardStatus?) {
        currentFilter = status
        if let status = status {
            filteredTimecards = timecards.filter { $0.status == status }
        } else {
            filteredTimecards = timecards
        }
    }

    // MARK: - Editing

    func editTimecard(_ timecard: Timecard) {
        // TODO: Implement edit functionality
        print("Editing timecard: \(timecard.id)")
    }

    // MARK: - Deleting

    func deleteTimecard(_ timecard: Timecard) {
        timecards.removeAll { $0.id == timecard.id }
        filterByStatus(currentFilter) // Reapply filter after deletion
    }
    
    // MARK: - Adding New Timecard

    func addNewTimecard(date: Date, totalHours: Double, status: TimecardStatus) {
        let newTimecard = Timecard(id: UUID(), date: date, totalHours: totalHours, status: status)
        timecards.append(newTimecard)
        filterByStatus(currentFilter) // Reapply filter to include the new timecard
    }
}
