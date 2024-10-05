//
//  TimecardListView.swift
//  TimecardApp
//
//  Created by Damian Rozycki on 10/4/24.
//

import SwiftUI

struct TimecardListView: View {
    @StateObject private var viewModel = TimecardListViewModel()
    
    var body: some View {
        NavigationView {
            List(viewModel.timecards) { timecard in
                NavigationLink(destination: TimecardDetailView(timecard: timecard)) {
                    TimecardRowView(timecard: timecard)
                }
            }
            .navigationTitle("Timecards")
            .toolbar {
                Button(action: {
                    // Add new timecard action
                }) {
                    Image(systemName: "plus")
                }
            }
        }
    }
}

struct TimecardRowView: View {
    let timecard: Timecard
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(timecard.date, style: .date)
                .font(.headline)
            Text("Hours: \(timecard.totalHours, specifier: "%.2f")")
                .font(.subheadline)
        }
    }
}

struct TimecardListView_Previews: PreviewProvider {
    static var previews: some View {
        TimecardListView()
    }
}
