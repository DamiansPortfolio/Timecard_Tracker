//
//  TimecardListViewModel.swift
//  TimecardApp
//
//  Created by Damian Rozycki on 10/4/24.
//
import Foundation

class TimecardListViewModel: ObservableObject {
    @Published var timecards: [Timecard] = []
    
    init() {
        fetchTimecards()
    }
    
    func fetchTimecards() {
        // TODO: Replace with actual API call
        timecards = [
            Timecard(id: UUID(), date: Date(), totalHours: 8.0, status: .draft),
            Timecard(id: UUID(), date: Date().addingTimeInterval(-86400), totalHours: 7.5, status: .submitted)
        ]
    }
}
