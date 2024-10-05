//
//  Timecard.swift
//  TimecardApp
//
//  Created by Damian Rozycki on 10/4/24.
//

import Foundation

struct Timecard: Identifiable {
    let id: UUID
    let date: Date
    let totalHours: Double
    let status: TimecardStatus
}

enum TimecardStatus: String {
    case draft
    case submitted
    case approved
    case rejected
}
