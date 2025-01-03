    //
    //  CalendarViewModel.swift
    //  TimecardApp
    //
    //  Created by Damian Rozycki on 11/14/24.
    //
//
import FirebaseFirestore
import SwiftUI

class WeeklyViewModel: ObservableObject {
    @Published var timecards: [Timecard] = []
    @Published var currentWeekIndex: Int = 0
    @Published var currentWeekTimecards: [TimecardByDay] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    private let calendar = Calendar.current
    private var currentDate = Date()
    private let db = Firestore.firestore()
    private var listener: ListenerRegistration?
    
    var totalWeeks: Int {
        let startOfYear = calendar.date(from: calendar.dateComponents([.year], from: Date())) ?? Date()
        let endOfFutureRange = calendar.date(byAdding: .month, value: 3, to: Date()) ?? Date()
        let weeks = calendar.dateComponents([.weekOfYear], from: startOfYear, to: endOfFutureRange)
        return weeks.weekOfYear ?? 0
    }

    
    var currentMonthYear: String {
        currentDate.formatted(.dateTime.month().year())
    }
    
    var currentWeekRange: String {
        guard let weekStart = calendar.date(
            from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: currentDate)
        ) else { return "" }
        
        // Adjust to Monday if needed
        let monday = calendar.component(.weekday, from: weekStart) == 1 ?
            calendar.date(byAdding: .day, value: 1, to: weekStart) :
            weekStart
        
        guard let mondayDate = monday else { return "" }
        let friday = calendar.date(byAdding: .day, value: 4, to: mondayDate) ?? mondayDate
        
        return "\(mondayDate.formatted(.dateTime.month().day())) - \(friday.formatted(.dateTime.month().day()))"
    }
    
    var totalHours: Double {
        currentWeekTimecards.compactMap { $0.hours }.reduce(0, +)
    }

            // Initialization and cleanup
    init() {
        setupTimecardListener()
        updateCurrentWeek()
    }
    
    deinit {
        listener?.remove()
    }
    
    func nextWeek() {
        // Calculate end of future range
        let endOfFutureRange = calendar.date(byAdding: .month, value: 3, to: Date()) ?? Date()
        
        if currentDate < endOfFutureRange {
            currentDate = calendar.date(byAdding: .weekOfYear, value: 1, to: currentDate) ?? currentDate
            updateCurrentWeek()
            setupTimecardListener() // Refresh data for new week
        }
    }
    
    func previousWeek() {
        // Calculate start of the current year
        let startOfYear = calendar.date(from: calendar.dateComponents([.year], from: Date())) ?? Date()
        
        if currentDate > startOfYear {
            currentDate = calendar.date(byAdding: .weekOfYear, value: -1, to: currentDate) ?? currentDate
            updateCurrentWeek()
            setupTimecardListener() // Refresh data for new week
        }
    }
    
    func refreshData() {
        setupTimecardListener()
    }
    
    private func updateCurrentWeek() {
        guard let weekStart = calendar.date(
            from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: currentDate)
        ) else { return }
        
        // Find Monday
        let monday = calendar.component(.weekday, from: weekStart) == 1 ?
            calendar.date(byAdding: .day, value: 1, to: weekStart) :
            weekStart
        
        guard let mondayDate = monday else { return }
        
        // Generate weekdays from Monday to Friday
        currentWeekTimecards = (0..<5).map { dayOffset in
            let date = calendar.date(byAdding: .day, value: dayOffset, to: mondayDate) ?? mondayDate
            let timecard = timecards.first { calendar.isDate($0.date, inSameDayAs: date) }
            
            return TimecardByDay(
                id: UUID().uuidString,
                date: date,
                hours: timecard?.totalHours,
                status: timecard?.status
            )
        }
    }
    
    private func setupTimecardListener() {
        guard let userId = UserDefaults.standard.string(forKey: "userId") else {
            errorMessage = "No user ID found"
            return
        }
        
        isLoading = true
        
            // Remove existing listener
        listener?.remove()
        
        let startOfYear = calendar.date(from: calendar.dateComponents([.year], from: Date())) ?? Date()
        let endOfFutureRange = calendar.date(byAdding: .month, value: 3, to: Date()) ?? Date()

        
            // Create new listener
        listener = db.collection("timecards")
            .whereField("userId", isEqualTo: userId)
            .whereField("date", isGreaterThanOrEqualTo: startOfYear)
            .whereField("date", isLessThanOrEqualTo: endOfFutureRange)
            .order(by: "date", descending: false)
            .addSnapshotListener { [weak self] querySnapshot, error in
                guard let self = self else { return }
                
                DispatchQueue.main.async {
                    if let error = error {
                        self.errorMessage = error.localizedDescription
                        self.isLoading = false
                        return
                    }
                    
                        // Update timecards
                    self.timecards = querySnapshot?.documents.compactMap { Timecard(document: $0) } ?? []
                    self.updateCurrentWeek()
                    self.isLoading = false
                    
                    print("Calendar updated: \(self.timecards.count) timecards loaded")
                }
            }
    }
    
    func submitAllTimecards() {
        isLoading = true
        errorMessage = nil

        let group = DispatchGroup()

        let currentWeekStart = calendar.date(
            from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: currentDate)
        )

        for timecard in timecards.filter({
            guard let timecardDate = calendar.date(from: calendar.dateComponents([.year, .month, .day], from: $0.date)) else {
                return false
            }
            return calendar.isDate(timecardDate, equalTo: currentWeekStart ?? Date(), toGranularity: .weekOfYear) && $0.status == .draft
        }) {
            group.enter()

            let docRef = db.collection("timecards").document(timecard.id)
            var updatedData = timecard.firestoreData
            updatedData["status"] = TimecardStatus.submitted.rawValue

            docRef.updateData(updatedData) { error in
                if let error = error {
                    self.errorMessage = "Error submitting timecard: \(error.localizedDescription)"
                }
                group.leave()
            }
        }

        group.notify(queue: .main) {
            self.isLoading = false
            self.refreshData()
        }
    }

}
