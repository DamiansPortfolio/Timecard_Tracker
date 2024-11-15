//
//  TimecardDayView.swift
//  TimecardApp
//
//  Created by Damian Rozycki on 11/14/24.
//


// TimecardDayView.swift
import SwiftUI

struct TimecardDayView: View {
    let timecard: DayTimecard
    
    var body: some View {
        VStack {
            HStack {
                VStack(alignment: .leading) {
                    Text(timecard.dayName)
                        .font(.headline)
                    Text(timecard.dateString)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                
                Spacer()
                
                HStack(spacing: 12) {
                    if let hours = timecard.hours {
                        Text("\(hours, specifier: "%.1f") hrs")
                            .font(.subheadline)
                    }
                    
                    if let status = timecard.status {
                        StatusBadge(status: status)
                    }
                }
            }
            .padding()
            .background(Color.gray.opacity(0.1))
            .cornerRadius(10)
        }
    }
}
