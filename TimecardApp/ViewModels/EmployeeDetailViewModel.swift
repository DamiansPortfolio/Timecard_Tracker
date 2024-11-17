import Foundation
import FirebaseFirestore

class EmployeeDetailViewModel: ObservableObject {
    let employee: Profile
    @Published var timecards: [Timecard] = []
    private let db = Firestore.firestore()
    
    init(employee: Profile) {
        self.employee = employee
        fetchTimecards() // Automatically fetch timecards when the ViewModel is initialized
    }
    
    func fetchTimecards() {
        db.collection("timecards") // Adjust collection name to your Firestore setup
            .whereField("employeeId", isEqualTo: employee.username) // Adjust field to your schema
            .getDocuments { [weak self] querySnapshot, error in
                guard let self = self else { return }
                
                if let error = error {
                    print("Error fetching timecards: \(error)")
                    return
                }
                
                guard let documents = querySnapshot?.documents else {
                    print("No timecards found for this employee.")
                    self.timecards = []
                    return
                }
                
                // Map Firestore documents to Timecard objects
                self.timecards = documents.compactMap { doc -> Timecard? in
                    do {
                        return try doc.data(as: Timecard.self) // Use Codable for easy parsing
                    } catch {
                        print("Error decoding timecard: \(error)")
                        return nil
                    }
                }
            }
    }
    
    /// Update the status of a timecard in Firestore.
    func updateTimecardStatus(_ timecard: Timecard, to status: TimecardStatus) {
        let timecardId = timecard.id
        
        db.collection("timecards")
            .document(timecardId)
            .updateData(["status": status.rawValue]) { [weak self] error in
                if let error = error {
                    print("Error updating timecard status: \(error)")
                    return
                }
                
                print("Timecard status updated successfully.")
                self?.fetchTimecards() // Refresh timecards after updating
            }
    }
}
