import SwiftUI
import FirebaseFirestore

class ManagerViewModel: ObservableObject {
    @Published var managedEmployees: [Profile] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var weeklyHours: Double = 0.0
    
    private let db = Firestore.firestore()
    
    func fetchManagerData(managerId: String) {
        isLoading = true
        
            // Fetch managed employees array from managers collection
        db.collection("managers")
            .whereField("manager_id", isEqualTo: managerId)
            .getDocuments { [weak self] managerSnapshot, error in
                guard let self = self else { return }
                
                if let error = error {
                    self.handleError("Error fetching managed employees: \(error.localizedDescription)")
                    return
                }
                
                guard let managerDoc = managerSnapshot?.documents.first,
                      let employeeIds = managerDoc.data()["managed_employees"] as? [String] else {
                    self.handleError("No managed employees found")
                    return
                }
                
                    // Fetch weekly hours for all employees
                self.fetchWeeklyHours(for: employeeIds)
                
                    // Fetch all managed employees' profiles
                self.fetchManagedEmployeesProfiles(employeeIds: employeeIds)
            }
    }
    
    private func fetchManagedEmployeesProfiles(employeeIds: [String]) {
        let group = DispatchGroup()
        var fetchedEmployees: [Profile] = []
        
        for employeeId in employeeIds {
            group.enter()
            
            db.collection("users").document(employeeId).getDocument { snapshot, error in
                defer { group.leave() }
                
                if let data = snapshot?.data() {
                    let profile = Profile(
                        username: data["username"] as? String ?? "",
                        password: data["password"] as? String ?? "",
                        fname: data["fname"] as? String ?? "",
                        lname: data["lname"] as? String ?? "",
                        mname: data["mname"] as? String,
                        email: data["email"] as? String ?? "",
                        phone: data["phone"] as? String ?? "",
                        title: data["title"] as? String ?? "",
                        branch: data["branch"] as? String ?? "",
                        department: data["department"] as? String ?? "",
                        location: data["location"] as? String ?? "",
                        isManager: false
                    )
                    fetchedEmployees.append(profile)
                }
            }
        }
        
        group.notify(queue: .main) { [weak self] in
            self?.managedEmployees = fetchedEmployees
            self?.isLoading = false
        }
    }
    
    private func fetchWeeklyHours(for employeeIds: [String]) {
        let calendar = Calendar.current
        guard let startOfWeek = calendar.dateInterval(of: .weekOfYear, for: Date())?.start,
              let endOfWeek = calendar.date(byAdding: .day, value: 7, to: startOfWeek) else {
            print("Failed to get week interval")
            return
        }
        
        print("Fetching hours for week: \(startOfWeek) to \(endOfWeek)")
        print("Employee IDs to check: \(employeeIds)")
        
        let group = DispatchGroup()
        var totalHours: Double = 0.0
        
        for employeeId in employeeIds {
            group.enter()
            
                // Query using userId (which is the same as employeeId)
            db.collection("timecards")
                .whereField("userId", isEqualTo: employeeId)
                .getDocuments { snapshot, error in
                    defer { group.leave() }
                    
                    if let error = error {
                        print("Error fetching timecards for employee \(employeeId): \(error)")
                        return
                    }
                    
                    if let documents = snapshot?.documents {
                        print("Found \(documents.count) total timecards for employee \(employeeId)")
                        
                        let employeeTimecards = documents.compactMap { Timecard(document: $0) }
                            // Filter timecards for current week and calculate total hours
                        let weeklyTimecards = employeeTimecards.filter { timecard in
                            let isInRange = (timecard.date >= startOfWeek && timecard.date < endOfWeek)
                            print("Timecard date: \(timecard.date), In range: \(isInRange)")
                            return isInRange
                        }
                        
                        let employeeHours = weeklyTimecards.reduce(0.0) { sum, timecard in
                            print("Adding hours for timecard: \(timecard.totalHours)")
                            return sum + timecard.totalHours
                        }
                        
                        print("Employee \(employeeId) total hours this week: \(employeeHours)")
                        totalHours += employeeHours
                    } else {
                        print("No documents found for employee \(employeeId)")
                    }
                }
        }
        
        group.notify(queue: .main) { [weak self] in
            print("Final total hours for all employees: \(totalHours)")
            self?.weeklyHours = totalHours
        }
    }
    
    private func handleError(_ message: String) {
        DispatchQueue.main.async {
            self.errorMessage = message
            self.isLoading = false
        }
    }
}
