
import SwiftUI

struct WeeklySummaryView: View {
    @StateObject private var viewModel = WeeklyViewModel()
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
                        .padding()
                } else {
                    ScrollView {
                        LazyVStack(spacing: 12) {
                            ForEach(viewModel.currentWeekTimecards) { timecard in
                                TimecardDayView(timecard: timecard)
                            }
                        }
                    }
                }
                
            }
            .navigationTitle("Weekly Summary")
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
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.teal)
                            .rotationEffect(.degrees(isRefreshing ? 360 : 0))
                        
                    }
                }
            }
        }
    }
}
