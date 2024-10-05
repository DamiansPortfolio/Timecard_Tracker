//
//  TimecardDetailView.swift
//  TimecardApp
//
//  Created by Damian Rozycki on 10/4/24.
//

import SwiftUI

struct TimecardDetailView: View {
    let timecard: Timecard
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Date: \(timecard.date, style: .date)")
                .font(.title)
            Text("Total Hours: \(timecard.totalHours, specifier: "%.2f")")
                .font(.headline)
            Text("Status: \(timecard.status.rawValue.capitalized)")
                .font(.subheadline)
            
            Spacer()
        }
        .padding()
        .navigationTitle("Timecard Details")
        .toolbar {
            Button("Edit") {
                // Add edit action here
            }
        }
    }
}

struct TimecardDetailView_Previews: PreviewProvider {
    static var previews: some View {
        TimecardDetailView(timecard: Timecard(id: UUID(), date: Date(), totalHours: 8.0, status: .draft))
    }
}
