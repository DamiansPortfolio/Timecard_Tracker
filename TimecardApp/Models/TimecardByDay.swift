//
//  DayTimecard.swift
//  TimecardApp
//
//  Created by Damian Rozycki on 11/14/24.
//
//
import Foundation

struct TimecardByDay: Identifiable {
    let id: String
    let date: Date
    let hours: Double?
    let status: TimecardStatus?
    
    var day: String {
        date.formatted(.dateTime.weekday(.wide))
    }
    
    var dateString: String {
        date.formatted(.dateTime.month().day().year())
    }
}
