class ManagerDashboardViewModel: ObservableObject {
    @Published var employees: [Profile] = []
    
    func fetchManagedEmployees() {
        // Fetch employees managed by the current manager.
        // Replace this with actual database/API logic.
        self.employees = Database.shared.fetchEmployeesManagedByCurrentManager()
    }
}
