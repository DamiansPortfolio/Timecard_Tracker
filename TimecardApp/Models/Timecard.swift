import Foundation
import FirebaseFirestore

enum TimecardStatus: String {
    case draft
    case submitted
    case approved
    case rejected
}

struct Timecard: Identifiable {
    let id: String
    let userId: String
    let employeeId: String
    let firstName: String
    let lastName: String
    let date: Date
    let totalHours: Double
    let status: TimecardStatus
    let jobCode: String
    let startTime: Date
    let endTime: Date
    let breakDuration: Double
    
    // Initialize from Firestore
    init?(document: QueryDocumentSnapshot) {
        let data = document.data()
        
        guard let userId = data["userId"] as? String,
              let employeeId = data["employeeId"] as? String,
              let firstName = data["firstName"] as? String,
              let lastName = data["lastName"] as? String,
              let timestamp = data["date"] as? Timestamp,
              let totalHours = data["totalHours"] as? Double,
              let statusRaw = data["status"] as? String,
              let status = TimecardStatus(rawValue: statusRaw),
              let jobCode = data["jobCode"] as? String,
              let startTimestamp = data["startTime"] as? Timestamp,
              let endTimestamp = data["endTime"] as? Timestamp,
              let breakDuration = data["breakDuration"] as? Double
        else {
            return nil
        }
        
        self.id = document.documentID
        self.userId = userId
        self.employeeId = employeeId
        self.firstName = firstName
        self.lastName = lastName
        self.date = timestamp.dateValue()
        self.totalHours = totalHours
        self.status = status
        self.jobCode = jobCode
        self.startTime = startTimestamp.dateValue()
        self.endTime = endTimestamp.dateValue()
        self.breakDuration = breakDuration
    }
    
    // Initialize for new timecard
    init(id: String = UUID().uuidString,
         userId: String,
         employeeId: String,
         firstName: String,
         lastName: String,
         date: Date,
         totalHours: Double,
         status: TimecardStatus,
         jobCode: String,
         startTime: Date,
         endTime: Date,
         breakDuration: Double) {
        self.id = id
        self.userId = userId
        self.employeeId = employeeId
        self.firstName = firstName
        self.lastName = lastName
        self.date = date
        self.totalHours = totalHours
        self.status = status
        self.jobCode = jobCode
        self.startTime = startTime
        self.endTime = endTime
        self.breakDuration = breakDuration
    }
    
    var firestoreData: [String: Any] {
        [
            "userId": userId,
            "employeeId": employeeId,
            "firstName": firstName,
            "lastName": lastName,
            "date": Timestamp(date: date),
            "totalHours": totalHours,
            "status": status.rawValue,
            "jobCode": jobCode,
            "startTime": Timestamp(date: startTime),
            "endTime": Timestamp(date: endTime),
            "breakDuration": breakDuration
        ]
    }
}
