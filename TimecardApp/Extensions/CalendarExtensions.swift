    //
    //  CalendarExtensions.swift
    //  TimecardApp
    //
    //  Created by Damian Rozycki on 11/14/24.
    //

import Foundation


    // Helper extension for Calendar
extension Calendar {
    func startOfMonth(for date: Date) -> Date {
        let components = dateComponents([.year, .month], from: date)
        return self.date(from: components) ?? date
    }
    
    func endOfMonth(for date: Date) -> Date {
        guard let startOfMonth = self.date(from: dateComponents([.year, .month], from: date)),
              let range = self.range(of: .day, in: .month, for: startOfMonth),
              let endOfMonth = self.date(byAdding: DateComponents(day: range.count - 1), to: startOfMonth) else {
            return date
        }
        return endOfMonth
    }
}
