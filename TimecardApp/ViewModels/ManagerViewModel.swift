//import SwiftUI
//import FirebaseFirestore
//
//class ManagerViewModel: ObservableObject {
//    @Published var managedEmployees: [Profile] = []
//    @Published var isLoading: Bool = false
//    @Published var errorMessage: String?
//    @Published var weeklyHours: Double = 0.0
//    
//    private let db = Firestore.firestore()
//    
//    func fetchManagerData(managerId: String) {
//        isLoading = true
//        
//            // Fetch managed employees array from managers collection
//        db.collection("managers")
//            .whereField("manager_id", isEqualTo: managerId)
//            .getDocuments { [weak self] managerSnapshot, error in
//                guard let self = self else { return }
//                
//                if let error = error {
//                    self.handleError("Error fetching managed employees: \(error.localizedDescription)")
//                    return
//                }
//                
//                guard let managerDoc = managerSnapshot?.documents.first,
//                      let employeeIds = managerDoc.data()["managed_employees"] as? [String] else {
//                    self.handleError("No managed employees found")
//                    return
//                }
//                
//                    // Fetch weekly hours for all employees
//                self.fetchWeeklyHours(for: employeeIds)
//                
//                    // Fetch all managed employees' profiles
//                self.fetchManagedEmployeesProfiles(employeeIds: employeeIds)
//            }
//    }
//    
//    private func fetchManagedEmployeesProfiles(employeeIds: [String]) {
//        let group = DispatchGroup()
//        var fetchedEmployees: [Profile] = []
//        
//        for employeeId in employeeIds {
//            group.enter()
//            
//            db.collection("users").document(employeeId).getDocument { snapshot, error in
//                defer { group.leave() }
//                
//                if let data = snapshot?.data() {
//                    let profile = Profile(
//                        username: data["username"] as? String ?? "",
//                        password: data["password"] as? String ?? "",
//                        fname: data["fname"] as? String ?? "",
//                        lname: data["lname"] as? String ?? "",
//                        mname: data["mname"] as? String,
//                        email: data["email"] as? String ?? "",
//                        phone: data["phone"] as? String ?? "",
//                        title: data["title"] as? String ?? "",
//                        branch: data["branch"] as? String ?? "",
//                        department: data["department"] as? String ?? "",
//                        location: data["location"] as? String ?? "",
//                        isManager: false
//                    )
//                    fetchedEmployees.append(profile)
//                }
//            }
//        }
//        
//        group.notify(queue: .main) { [weak self] in
//            self?.managedEmployees = fetchedEmployees
//            self?.isLoading = false
//        }
//    }
//    
//    private func fetchWeeklyHours(for employeeIds: [String]) {
//        let calendar = Calendar.current
//        guard let startOfWeek = calendar.dateInterval(of: .weekOfYear, for: Date())?.start,
//              let endOfWeek = calendar.date(byAdding: .day, value: 7, to: startOfWeek) else {
//            print("Failed to get week interval")
//            return
//        }
//        
//        print("Fetching hours for week: \(startOfWeek) to \(endOfWeek)")
//        print("Employee IDs to check: \(employeeIds)")
//        
//        let group = DispatchGroup()
//        var totalHours: Double = 0.0
//        
//        for employeeId in employeeIds {
//            group.enter()
//            
//                // Query using userId (which is the same as employeeId)
//            db.collection("timecards")
//                .whereField("userId", isEqualTo: employeeId)
//                .getDocuments { snapshot, error in
//                    defer { group.leave() }
//                    
//                    if let error = error {
//                        print("Error fetching timecards for employee \(employeeId): \(error)")
//                        return
//                    }
//                    
//                    if let documents = snapshot?.documents {
//                        print("Found \(documents.count) total timecards for employee \(employeeId)")
//                        
//                        let employeeTimecards = documents.compactMap { Timecard(document: $0) }
//                            // Filter timecards for current week and calculate total hours
//                        let weeklyTimecards = employeeTimecards.filter { timecard in
//                            let isInRange = (timecard.date >= startOfWeek && timecard.date < endOfWeek)
//                            print("Timecard date: \(timecard.date), In range: \(isInRange)")
//                            return isInRange
//                        }
//                        
//                        let employeeHours = weeklyTimecards.reduce(0.0) { sum, timecard in
//                            print("Adding hours for timecard: \(timecard.totalHours)")
//                            return sum + timecard.totalHours
//                        }
//                        
//                        print("Employee \(employeeId) total hours this week: \(employeeHours)")
//                        totalHours += employeeHours
//                    } else {
//                        print("No documents found for employee \(employeeId)")
//                    }
//                }
//        }
//        
//        group.notify(queue: .main) { [weak self] in
//            print("Final total hours for all employees: \(totalHours)")
//            self?.weeklyHours = totalHours
//        }
//    }
//    
//    private func handleError(_ message: String) {
//        DispatchQueue.main.async {
//            self.errorMessage = message
//            self.isLoading = false
//        }
//    }
//}


//import SwiftUI
//import FirebaseFirestore
//
//class ManagerViewModel: ObservableObject {
//    @Published var managedEmployees: [Profile] = [] // List of employees managed by the manager
//    @Published var isLoading: Bool = false // Loading state for UI
//    @Published var errorMessage: String? // Error messages for UI display
//    @Published var weeklyHours: Double = 0.0 // Total weekly hours for all employees
//
//    // New properties for pending approvals
//    @Published var pendingTimecards: [Timecard] = []
//    @Published var pendingLeaveRequests: [LeaveRequest] = []
//
//    private let db = Firestore.firestore()
//    
//    // MARK: - Fetch Manager Data
//    func fetchManagerData(managerId: String) {
//        isLoading = true
//        
//        db.collection("managers")
//            .whereField("manager_id", isEqualTo: managerId)
//            .getDocuments { [weak self] managerSnapshot, error in
//                guard let self = self else { return }
//                
//                if let error = error {
//                    self.handleError("Error fetching managed employees: \(error.localizedDescription)")
//                    return
//                }
//                
//                guard let managerDoc = managerSnapshot?.documents.first,
//                      let employeeIds = managerDoc.data()["managed_employees"] as? [String] else {
//                    self.handleError("No managed employees found")
//                    return
//                }
//                
//                self.fetchWeeklyHours(for: employeeIds) // Fetch weekly hours
//                self.fetchManagedEmployeesProfiles(employeeIds: employeeIds)
//                self.fetchPendingApprovals(employeeIds: employeeIds) // Fetch pending approvals
//            }
//    }
//    
//    // MARK: - Fetch Weekly Hours
//    func fetchWeeklyHours(for employeeIds: [String]) {
//        let calendar = Calendar.current
//        guard let startOfWeek = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: Date())) else {
//            handleError("Unable to determine start of the week.")
//            return
//        }
//        
//        db.collection("timecards")
//            .whereField("userId", in: employeeIds)
//            .whereField("date", isGreaterThanOrEqualTo: startOfWeek)
//            .getDocuments { [weak self] snapshot, error in
//                guard let self = self else { return }
//                
//                if let error = error {
//                    self.handleError("Error fetching weekly hours: \(error.localizedDescription)")
//                    return
//                }
//                
//                let totalHours = snapshot?.documents.compactMap { document in
//                    let data = document.data()
//                    return data["totalHours"] as? Double
//                }.reduce(0, +) ?? 0.0
//                
//                DispatchQueue.main.async {
//                    self.weeklyHours = totalHours
//                }
//            }
//    }
//    
//    // MARK: - Fetch Managed Employee Profiles
//    private func fetchManagedEmployeesProfiles(employeeIds: [String]) {
//        let group = DispatchGroup()
//        var fetchedEmployees: [Profile] = []
//        
//        for employeeId in employeeIds {
//            group.enter()
//            
//            db.collection("users").document(employeeId).getDocument { snapshot, error in
//                defer { group.leave() }
//                
//                if let data = snapshot?.data() {
//                    let profile = Profile(
//                        username: data["username"] as? String ?? "",
//                        password: data["password"] as? String ?? "",
//                        fname: data["fname"] as? String ?? "",
//                        lname: data["lname"] as? String ?? "",
//                        mname: data["mname"] as? String,
//                        email: data["email"] as? String ?? "",
//                        phone: data["phone"] as? String ?? "",
//                        title: data["title"] as? String ?? "",
//                        branch: data["branch"] as? String ?? "",
//                        department: data["department"] as? String ?? "",
//                        location: data["location"] as? String ?? "",
//                        isManager: false
//                    )
//                    fetchedEmployees.append(profile)
//                }
//            }
//        }
//        
//        group.notify(queue: .main) { [weak self] in
//            self?.managedEmployees = fetchedEmployees
//            self?.isLoading = false
//        }
//    }
//    
//    // MARK: - Fetch Pending Approvals
//    private func fetchPendingApprovals(employeeIds: [String]) {
//        // Fetch pending timecards
//        db.collection("timecards")
//            .whereField("userId", in: employeeIds)
//            .whereField("status", isEqualTo: TimecardStatus.submitted.rawValue)
//            .getDocuments { [weak self] snapshot, error in
//                guard let self = self else { return }
//                
//                if let error = error {
//                    self.handleError("Error fetching pending timecards: \(error.localizedDescription)")
//                    return
//                }
//                
//                self.pendingTimecards = snapshot?.documents.compactMap { Timecard(document: $0) } ?? []
//            }
//        
//        // Fetch pending leave requests
//        db.collection("leaveRequests")
//            .whereField("userId", in: employeeIds)
//            .whereField("status", isEqualTo: LeaveStatus.pending.rawValue)
//            .getDocuments { [weak self] snapshot, error in
//                guard let self = self else { return }
//                
//                if let error = error {
//                    self.handleError("Error fetching pending leave requests: \(error.localizedDescription)")
//                    return
//                }
//                
//                self.pendingLeaveRequests = snapshot?.documents.compactMap { LeaveRequest(document: $0) } ?? []
//            }
//    }
//    
//    // MARK: - Approve/Deny Timecards
//    func approveTimecard(_ timecard: Timecard) {
//        updateTimecardStatus(timecard, newStatus: .approved)
//    }
//    
//    func denyTimecard(_ timecard: Timecard) {
//        updateTimecardStatus(timecard, newStatus: .rejected)
//    }
//    
//    private func updateTimecardStatus(_ timecard: Timecard, newStatus: TimecardStatus) {
//        db.collection("timecards").document(timecard.id).updateData(["status": newStatus.rawValue]) { [weak self] error in
//            if let error = error {
//                self?.handleError("Error updating timecard: \(error.localizedDescription)")
//                return
//            }
//            self?.pendingTimecards.removeAll { $0.id == timecard.id }
//        }
//    }
//    
//    // MARK: - Approve/Deny Leave Requests
//    func approveLeaveRequest(_ leaveRequest: LeaveRequest) {
//        updateLeaveRequestStatus(leaveRequest, newStatus: .approved)
//    }
//    
//    func denyLeaveRequest(_ leaveRequest: LeaveRequest) {
//        updateLeaveRequestStatus(leaveRequest, newStatus: .denied)
//    }
//    
//    private func updateLeaveRequestStatus(_ leaveRequest: LeaveRequest, newStatus: LeaveStatus) {
//        db.collection("leaveRequests").document(leaveRequest.id).updateData(["status": newStatus.rawValue]) { [weak self] error in
//            if let error = error {
//                self?.handleError("Error updating leave request: \(error.localizedDescription)")
//                return
//            }
//            self?.pendingLeaveRequests.removeAll { $0.id == leaveRequest.id }
//        }
//    }
//    
//    // MARK: - Handle Errors
//    private func handleError(_ message: String) {
//        DispatchQueue.main.async {
//            self.errorMessage = message
//            self.isLoading = false
//        }
//    }
//}
//

//import SwiftUI
//import FirebaseFirestore
//
//class ManagerViewModel: ObservableObject {
//    @Published var managedEmployees: [Profile] = [] // List of employees managed by the manager
//    @Published var isLoading: Bool = false // Loading state for UI
//    @Published var errorMessage: String? // Error messages for UI display
//    @Published var weeklyHours: Double = 0.0 // Total weekly hours for all employees
//
//    // New properties for pending approvals
//    @Published var pendingTimecards: [Timecard] = []
//    @Published var pendingLeaveRequests: [LeaveRequest] = []
//
//    private let db = Firestore.firestore()
//    
//    // MARK: - Fetch Manager Data
//    func fetchManagerData(managerId: String) {
//        isLoading = true
//        
//        db.collection("managers")
//            .whereField("manager_id", isEqualTo: managerId)
//            .getDocuments { [weak self] managerSnapshot, error in
//                guard let self = self else { return }
//                
//                if let error = error {
//                    self.handleError("Error fetching managed employees: \(error.localizedDescription)")
//                    return
//                }
//                
//                guard let managerDoc = managerSnapshot?.documents.first,
//                      let employeeIds = managerDoc.data()["managed_employees"] as? [String] else {
//                    self.handleError("No managed employees found.")
//                    return
//                }
//                
//                self.fetchWeeklyHours(for: employeeIds) // Fetch weekly hours
//                self.fetchManagedEmployeesProfiles(employeeIds: employeeIds)
//                self.fetchPendingApprovals(employeeIds: employeeIds) // Fetch pending approvals
//            }
//    }
//    
//    // MARK: - Fetch Weekly Hours
//    func fetchWeeklyHours(for employeeIds: [String]) {
//        let calendar = Calendar.current
//        guard let startOfWeek = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: Date())) else {
//            handleError("Unable to determine start of the week.")
//            return
//        }
//        
//        db.collection("timecards")
//            .whereField("userId", in: employeeIds)
//            .whereField("date", isGreaterThanOrEqualTo: startOfWeek)
//            .getDocuments { [weak self] snapshot, error in
//                guard let self = self else { return }
//                
//                if let error = error {
//                    self.handleError("Error fetching weekly hours: \(error.localizedDescription)")
//                    return
//                }
//                
//                let totalHours = snapshot?.documents.compactMap { document in
//                    let data = document.data()
//                    return data["totalHours"] as? Double
//                }.reduce(0, +) ?? 0.0
//                
//                DispatchQueue.main.async {
//                    self.weeklyHours = totalHours
//                }
//            }
//    }
//    
//    // MARK: - Fetch Managed Employee Profiles
//    private func fetchManagedEmployeesProfiles(employeeIds: [String]) {
//        let group = DispatchGroup()
//        var fetchedEmployees: [Profile] = []
//        
//        for employeeId in employeeIds {
//            group.enter()
//            
//            db.collection("users").document(employeeId).getDocument { snapshot, error in
//                defer { group.leave() }
//                
//                if let data = snapshot?.data() {
//                    let profile = Profile(
//                        username: data["username"] as? String ?? "",
//                        password: data["password"] as? String ?? "",
//                        fname: data["fname"] as? String ?? "",
//                        lname: data["lname"] as? String ?? "",
//                        mname: data["mname"] as? String,
//                        email: data["email"] as? String ?? "",
//                        phone: data["phone"] as? String ?? "",
//                        title: data["title"] as? String ?? "",
//                        branch: data["branch"] as? String ?? "",
//                        department: data["department"] as? String ?? "",
//                        location: data["location"] as? String ?? "",
//                        isManager: false
//                    )
//                    fetchedEmployees.append(profile)
//                }
//            }
//        }
//        
//        group.notify(queue: .main) { [weak self] in
//            self?.managedEmployees = fetchedEmployees
//            self?.isLoading = false
//        }
//    }
//    
//    // MARK: - Fetch Pending Approvals
//    private func fetchPendingApprovals(employeeIds: [String]) {
//        isLoading = true
//
//        // Fetch pending timecards
//        db.collection("timecards")
//            .whereField("userId", in: employeeIds)
//            .whereField("status", isEqualTo: TimecardStatus.submitted.rawValue)
//            .getDocuments { [weak self] snapshot, error in
//                guard let self = self else { return }
//
//                if let error = error {
//                    self.handleError("Error fetching pending timecards: \(error.localizedDescription)")
//                    return
//                }
//
//                self.pendingTimecards = snapshot?.documents.compactMap { document in
//                    Timecard(document: document) // Decode the document using the initializer
//                } ?? []
//            }
//
//        // Fetch pending leave requests
//        db.collection("leaveRequests")
//            .whereField("userId", in: employeeIds)
//            .whereField("status", isEqualTo: LeaveStatus.pending.rawValue)
//            .getDocuments { [weak self] snapshot, error in
//                guard let self = self else { return }
//
//                if let error = error {
//                    self.handleError("Error fetching pending leave requests: \(error.localizedDescription)")
//                    return
//                }
//
//                self.pendingLeaveRequests = snapshot?.documents.compactMap { document in
//                    let data = document.data()
//
//                    guard let userId = data["userId"] as? String,
//                          let startDate = (data["startDate"] as? Timestamp)?.dateValue(),
//                          let endDate = (data["endDate"] as? Timestamp)?.dateValue(),
//                          let reason = data["reason"] as? String,
//                          let statusRaw = data["status"] as? String,
//                          let status = LeaveStatus(rawValue: statusRaw) else {
//                        return nil
//                    }
//
//                    return LeaveRequest(
//                        id: document.documentID,
//                        userId: userId,
//                        startDate: startDate,
//                        endDate: endDate,
//                        reason: reason,
//                        status: status
//                    )
//                } ?? []
//
//                self.isLoading = false
//            }
//    }
//
//
//    // MARK: - Approve/Deny Timecards
//    func approveTimecard(_ timecard: Timecard) {
//        updateTimecardStatus(timecard, newStatus: .approved)
//    }
//    
//    func denyTimecard(_ timecard: Timecard) {
//        updateTimecardStatus(timecard, newStatus: .rejected)
//    }
//    
//    private func updateTimecardStatus(_ timecard: Timecard, newStatus: TimecardStatus) {
//        db.collection("timecards").document(timecard.id).updateData(["status": newStatus.rawValue]) { [weak self] error in
//            if let error = error {
//                self?.handleError("Error updating timecard: \(error.localizedDescription)")
//                return
//            }
//            self?.pendingTimecards.removeAll { $0.id == timecard.id }
//        }
//    }
//    
//    // MARK: - Approve/Deny Leave Requests
//    func approveLeaveRequest(_ leaveRequest: LeaveRequest) {
//        updateLeaveRequestStatus(leaveRequest, newStatus: .approved)
//    }
//    
//    func denyLeaveRequest(_ leaveRequest: LeaveRequest) {
//        updateLeaveRequestStatus(leaveRequest, newStatus: .denied)
//    }
//    
//    private func updateLeaveRequestStatus(_ leaveRequest: LeaveRequest, newStatus: LeaveStatus) {
//        db.collection("leaveRequests").document(leaveRequest.id).updateData(["status": newStatus.rawValue]) { [weak self] error in
//            if let error = error {
//                self?.handleError("Error updating leave request: \(error.localizedDescription)")
//                return
//            }
//            self?.pendingLeaveRequests.removeAll { $0.id == leaveRequest.id }
//        }
//    }
//    
//    // MARK: - Handle Errors
//    private func handleError(_ message: String) {
//        DispatchQueue.main.async {
//            self.errorMessage = message
//            self.isLoading = false
//        }
//    }
//}
//
import SwiftUI
import FirebaseFirestore

class ManagerViewModel: ObservableObject {
    // MARK: - Published Properties
    @Published var managedEmployees: [Profile] = [] // List of employees managed by the manager
    @Published var isLoading: Bool = false // Loading state for UI
    @Published var errorMessage: String? // Error messages for UI display
    @Published var weeklyHours: Double = 0.0 // Total weekly hours for all employees
    @Published var pendingTimecards: [Timecard] = [] // Pending timecards for approval
    @Published var pendingLeaveRequests: [LeaveRequest] = [] // Pending leave requests for approval

    // MARK: - Firestore Instance
    private let db = Firestore.firestore()

    // MARK: - Fetch Manager Data
    func fetchManagerData(managerId: String) {
        isLoading = true

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
                    self.handleError("No managed employees found.")
                    return
                }

                // Fetch required data
                self.fetchWeeklyHours(for: employeeIds)
                self.fetchManagedEmployeesProfiles(employeeIds: employeeIds)
                self.fetchPendingApprovals(employeeIds: employeeIds)
            }
    }

    // MARK: - Fetch Weekly Hours
    func fetchWeeklyHours(for employeeIds: [String]) {
        let calendar = Calendar.current
        guard let startOfWeek = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: Date())) else {
            handleError("Unable to determine start of the week.")
            return
        }

        db.collection("timecards")
            .whereField("userId", in: employeeIds)
            .whereField("date", isGreaterThanOrEqualTo: startOfWeek)
            .getDocuments { [weak self] snapshot, error in
                guard let self = self else { return }

                if let error = error {
                    self.handleError("Error fetching weekly hours: \(error.localizedDescription)")
                    return
                }

                let totalHours = snapshot?.documents.compactMap { document in
                    let data = document.data()
                    return data["totalHours"] as? Double
                }.reduce(0, +) ?? 0.0

                DispatchQueue.main.async {
                    self.weeklyHours = totalHours
                }
            }
    }

    // MARK: - Fetch Managed Employee Profiles
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

    // MARK: - Fetch Pending Approvals
    private func fetchPendingApprovals(employeeIds: [String]) {
        isLoading = true

        // Fetch pending timecards
        db.collection("timecards")
            .whereField("userId", in: employeeIds)
            .whereField("status", isEqualTo: TimecardStatus.submitted.rawValue)
            .getDocuments { [weak self] snapshot, error in
                guard let self = self else { return }

                if let error = error {
                    self.handleError("Error fetching pending timecards: \(error.localizedDescription)")
                    return
                }

                self.pendingTimecards = snapshot?.documents.compactMap { document in
                    Timecard(document: document)
                } ?? []
            }

        // Fetch pending leave requests
        db.collection("leaveRequests")
            .whereField("userId", in: employeeIds)
            .whereField("status", isEqualTo: LeaveStatus.pending.rawValue)
            .getDocuments { [weak self] snapshot, error in
                guard let self = self else { return }

                if let error = error {
                    self.handleError("Error fetching pending leave requests: \(error.localizedDescription)")
                    return
                }

                self.pendingLeaveRequests = snapshot?.documents.compactMap { document in
                    LeaveRequest(document: document)
//
//                    )
                } ?? []

                self.isLoading = false
            }
    }

    // MARK: - Approve/Deny Timecards
    func approveTimecard(_ timecard: Timecard) {
        updateTimecardStatus(timecard, newStatus: .approved)
    }

    func denyTimecard(_ timecard: Timecard) {
        updateTimecardStatus(timecard, newStatus: .rejected)
    }

    private func updateTimecardStatus(_ timecard: Timecard, newStatus: TimecardStatus) {
        db.collection("timecards").document(timecard.id).updateData(["status": newStatus.rawValue]) { [weak self] error in
            if let error = error {
                self?.handleError("Error updating timecard: \(error.localizedDescription)")
                return
            }
            self?.pendingTimecards.removeAll { $0.id == timecard.id }
        }
    }

    // MARK: - Approve/Deny Leave Requests
    func approveLeaveRequest(_ leaveRequest: LeaveRequest) {
        updateLeaveRequestStatus(leaveRequest, newStatus: .approved)
    }

    func denyLeaveRequest(_ leaveRequest: LeaveRequest) {
        updateLeaveRequestStatus(leaveRequest, newStatus: .denied)
    }

    private func updateLeaveRequestStatus(_ leaveRequest: LeaveRequest, newStatus: LeaveStatus) {
        db.collection("leaveRequests").document(leaveRequest.id).updateData(["status": newStatus.rawValue]) { [weak self] error in
            if let error = error {
                self?.handleError("Error updating leave request: \(error.localizedDescription)")
                return
            }
            self?.pendingLeaveRequests.removeAll { $0.id == leaveRequest.id }
        }
    }

    // MARK: - Handle Errors
    private func handleError(_ message: String) {
        DispatchQueue.main.async {
            self.errorMessage = message
            self.isLoading = false
        }
    }
}
