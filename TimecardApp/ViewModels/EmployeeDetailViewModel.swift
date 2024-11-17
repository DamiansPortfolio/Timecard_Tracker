class EmployeeDetailViewModel: ObservableObject {
    let employee: Profile
    @Published var timecards: [Timecard] = []
    
    init(employee: Profile) {
        self.employee = employee
    }
    
    func fetchTimecards() {
        // Fetch timecards for the employee.
        self.timecards = Database.shared.fetchTimecards(for: employee)
    }
    
    func updateTimecardStatus(_ timecard: Timecard, to status: TimecardStatus) {
        // Update the timecard status.
        Database.shared.updateTimecardStatus(timecard, to: status)
        // Refresh the list after updating.
        fetchTimecards()
    }
}
