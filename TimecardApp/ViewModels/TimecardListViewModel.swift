import Foundation
import FirebaseFirestore

class TimecardListViewModel: ObservableObject {
    @Published var timecards: [Timecard] = []
    @Published var filteredTimecards: [Timecard] = []
    @Published var currentFilter: TimecardStatus? = nil
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var employeeInfo: (firstName: String, lastName: String)?
    
    private let db = Firestore.firestore()
    
    init() {
        fetchEmployeeInfo()
    }
    
    private func fetchEmployeeInfo() {
        guard let userId = UserDefaults.standard.string(forKey: "userId") else {
            errorMessage = "No user ID found"
            return
        }
        
            // Fetch user profile from Firestore
        db.collection("users").document(userId).getDocument { [weak self] document, error in
            if let document = document, document.exists {
                let firstName = document["fname"] as? String ?? ""
                let lastName = document["lname"] as? String ?? ""
                
                DispatchQueue.main.async {
                    self?.employeeInfo = (firstName, lastName)
                    self?.fetchTimecards()
                }
            }
        }
    }
    
    func fetchTimecards() {
        guard let userId = UserDefaults.standard.string(forKey: "userId") else {
            errorMessage = "No user ID found"
            return
        }
        
        isLoading = true
        
        db.collection("timecards")
            .whereField("userId", isEqualTo: userId)
            .order(by: "date", descending: true)
            .addSnapshotListener { [weak self] querySnapshot, error in
                guard let self = self else { return }
                
                if let error = error {
                    self.errorMessage = error.localizedDescription
                    self.isLoading = false
                    return
                }
                
                self.timecards = querySnapshot?.documents.compactMap { Timecard(document: $0) } ?? []
                self.filterByStatus(self.currentFilter)
                self.isLoading = false
            }
    }
    
    func addTimecard(jobCode: String, date: Date, startTime: Date, endTime: Date, breakDuration: Double) {
        guard let userId = UserDefaults.standard.string(forKey: "userId"),
              let employeeInfo = employeeInfo else {
            errorMessage = "Missing user information"
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        let totalHours = calculateTotalHours(startTime: startTime, endTime: endTime, breakDuration: breakDuration)
        
            // Create timecard using the employee info from profile
        let newTimecard = Timecard(
            userId: userId,
            employeeId: userId,  // Using userId as employeeId for now
            firstName: employeeInfo.firstName,  // From profile
            lastName: employeeInfo.lastName,    // From profile
            date: date,
            totalHours: totalHours,
            status: .draft,
            jobCode: jobCode,
            startTime: startTime,
            endTime: endTime,
            breakDuration: breakDuration
        )
        
        let docRef = db.collection("timecards").document(newTimecard.id)
        docRef.setData(newTimecard.firestoreData) { [weak self] error in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                if let error = error {
                    self.errorMessage = "Error adding timecard: \(error.localizedDescription)"
                }
                self.isLoading = false
                
                    // Refresh timecards after adding
                self.fetchTimecards()
            }
        }
    }
    
    func deleteTimecard(_ timecard: Timecard) {
        isLoading = true
        
        db.collection("timecards").document(timecard.id).delete { [weak self] error in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                if let error = error {
                    self.errorMessage = "Error deleting timecard: \(error.localizedDescription)"
                }
                self.isLoading = false
            }
        }
    }
    
    func submitTimecard(_ timecard: Timecard) {
        isLoading = true
        errorMessage = nil
        
        let docRef = db.collection("timecards").document(timecard.id)
        
        var updatedData = timecard.firestoreData
        updatedData["status"] = TimecardStatus.submitted.rawValue
        
        docRef.updateData(updatedData) { [weak self] error in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                if let error = error {
                    self.errorMessage = "Error submitting timecard: \(error.localizedDescription)"
                }
                self.isLoading = false
                
            }
        }
    }
    
    func updateTimecard(_ timecard: Timecard, jobCode: String, date: Date, startTime: Date, endTime: Date, breakDuration: Double) {
        guard let employeeInfo = employeeInfo else {
            errorMessage = "Missing employee information"
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        let totalHours = calculateTotalHours(startTime: startTime, endTime: endTime, breakDuration: breakDuration)
        
        let updatedTimecard = Timecard(
            id: timecard.id,
            userId: timecard.userId,
            employeeId: timecard.employeeId,
            firstName: employeeInfo.firstName,
            lastName: employeeInfo.lastName,
            date: date,
            totalHours: totalHours,
            status: timecard.status,
            jobCode: jobCode,
            startTime: startTime,
            endTime: endTime,
            breakDuration: breakDuration
        )
        
        let docRef = db.collection("timecards").document(timecard.id)
        docRef.setData(updatedTimecard.firestoreData) { [weak self] error in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                if let error = error {
                    self.errorMessage = "Error updating timecard: \(error.localizedDescription)"
                }
                self.isLoading = false
            }
        }
    }
    
    func sortByDateDescending() {
        filteredTimecards.sort { $0.date < $1.date }
    }
    
    func sortByDateAscending() {
        filteredTimecards.sort { $0.date > $1.date }
    }
    
    func filterByStatus(_ status: TimecardStatus?) {
        currentFilter = status
        if let status = status {
            filteredTimecards = timecards.filter { $0.status == status }
        } else {
            filteredTimecards = timecards
        }
    }
    
    func calculateTotalHours(startTime: Date, endTime: Date, breakDuration: Double) -> Double {
        let workedHours = endTime.timeIntervalSince(startTime) / 3600
        return max(0, workedHours - breakDuration)
    }
}
