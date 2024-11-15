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
                .padding(.horizontal)
                
                    // Week Navigation
                HStack {
                    Button(action: { viewModel.previousWeek() }) {
                        Image(systemName: "chevron.left.circle.fill")
//                            .foregroundColor(.teal)
                            .font(.title2)
                    }
                    
                    Spacer()
                    
                    Text(viewModel.currentWeekRange)
                        .font(.headline)
                    
                    Spacer()
                    
                    Button(action: { viewModel.nextWeek() }) {
                        Image(systemName: "chevron.right.circle.fill")
//                            .foregroundColor(.teal)
                            .font(.title2)
                    }
                }
                .padding(.horizontal)
                
                    // Week View
                if viewModel.isLoading {
                    ProgressView()
                        .scaleEffect(1.5)
                } else if viewModel.currentWeekTimecards.isEmpty {
                    Text("No timecards for this week")
                        .foregroundColor(.gray)
                        .padding()
                } else {
                    ScrollView {
                        LazyVStack(spacing: 12) {
                            ForEach(viewModel.currentWeekTimecards) { timecard in
                                TimecardDayView(timecard: timecard)
                            }
                        }
                        .padding(.horizontal)
                    }
                }
                
                    // Week Indicator Dots
                HStack(spacing: 8) {
                    ForEach(0..<viewModel.totalWeeks, id: \.self) { index in
                        Circle()
                            .fill(index == viewModel.currentWeekIndex ? Color.teal : Color.gray.opacity(0.3))
                            .frame(width: 8, height: 8)
                    }
                }
                .padding(.bottom)
            }
            .navigationTitle("Calendar")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        withAnimation {
                            isRefreshing = true
                            viewModel.refreshData()
                                // Add a slight delay before stopping the animation
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                isRefreshing = false
                            }
                        }
                    }) {
                        Image(systemName: "arrow.clockwise")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.teal)
                            .rotationEffect(.degrees(isRefreshing ? 360 : 0))
                            .animation(isRefreshing ? Animation.linear(duration: 1).repeatForever(autoreverses: false) : .default, value: isRefreshing)
                    }
                }
            }
        }
    }
}
