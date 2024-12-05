import SwiftUI

struct WeeklySummaryView: View {
    @StateObject private var viewModel = WeeklyViewModel()
    @State private var isRefreshing = false
    @State private var showSubmitAlert = false

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                // Week Navigation
                HStack {
                    Image(systemName: "chevron.left.circle.fill")
                        .foregroundColor(.teal)
                        .onTapGesture {
                            viewModel.previousWeek()
                        }

                    Spacer()

                    VStack {
                        Text(viewModel.currentWeekRange)
                            .font(.title2)
                            .bold()
                            .foregroundColor(.teal)

                        Text("Total Hours: \(viewModel.totalHours, specifier: "%.1f")")
                            .font(.headline)
                    }

                    Spacer()

                    Image(systemName: "chevron.right.circle.fill")
                        .foregroundColor(.teal)
                        .onTapGesture {
                            viewModel.nextWeek()
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
                        LazyVStack(spacing: 10) {
                            ForEach(viewModel.currentWeekTimecards) { timecard in
                                TimecardByDayView(dailyTimecard: timecard)
                            }
                        }
                    }
                }

                // Submit Button
                Button(action: {
                    showSubmitAlert = true
                }) {
                    Text("Submit All Timecards")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.teal)
                        .cornerRadius(10)
                }
                .padding(.top, 20)
            }
            .navigationTitle("Weekly Summary")
            .padding()
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
            .alert("Submit All Timecards", isPresented: $showSubmitAlert) {
                Button("Cancel", role: .cancel) { }
                Button("Submit") {
                    viewModel.submitAllTimecards()
                }
            } message: {
                Text("Are you sure you want to submit all timecards for this week? This action cannot be undone.")
            }
        }
    }
}
