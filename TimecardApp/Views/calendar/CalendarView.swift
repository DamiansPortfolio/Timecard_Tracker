//
//  CalendarView.swift
//  TimecardApp
//
//  Created by Damian Rozycki on 11/14/24.
//

import SwiftUI

struct CalendarView: View {
    @StateObject private var viewModel = CalendarViewModel()
    @State private var isRefreshing = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                // Month Header
                HStack {
                    Text(viewModel.currentMonthYear)
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.teal)
                    
                    Spacer()
                    
                    Text("Total Hours: \(viewModel.totalHours, specifier: "%.1f")")
                        .foregroundColor(.gray)
                }
                
                // Week Navigation
                HStack {
                    Button(action: { viewModel.previousWeek() }) {
                        Image(systemName: "chevron.left.circle.fill")
                            .font(.title2)
                    }
                    
                    Spacer()
                    
                    Text(viewModel.currentWeekRange)
                        .font(.headline)
                    
                    Spacer()
                    
                    Button(action: { viewModel.nextWeek() }) {
                        Image(systemName: "chevron.right.circle.fill")
                            .font(.title2)
                    }
                }
                
                // Week View
                if viewModel.isLoading {
                    ProgressView()
                        .scaleEffect(1.5)
                } else if viewModel.currentWeekTimecards.isEmpty {
                    Text("No timecards for this week")
                        .foregroundColor(.gray)
                } else {
                    ScrollView {
                        LazyVStack(spacing: 10) {
                            ForEach(viewModel.currentWeekTimecards) { timecard in
                                TimecardDayView(timecard: timecard)
                            }
                        }
                    }
                }
                
                
            }
            .navigationTitle("Calendar")
            .padding(.horizontal)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        isRefreshing = true
                        viewModel.refreshData()
                        // Add a slight delay before stopping the animation
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            isRefreshing = false
                        }
                    }) {
                        Image(systemName: "arrow.clockwise")
                            .bold()
                            .rotationEffect(.degrees(isRefreshing ? 360 : 0))
                    }
                }
            }
        }
    }
}
