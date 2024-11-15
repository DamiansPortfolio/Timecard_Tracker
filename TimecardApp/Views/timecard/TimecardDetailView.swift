import SwiftUI

struct TimecardDetailView: View {
    let timecard: Timecard
    @State private var showingSubmitAlert = false
    @ObservedObject private var viewModel: TimecardListViewModel
    
    init(timecard: Timecard, viewModel: TimecardListViewModel = TimecardListViewModel()) {
        self.timecard = timecard
        self.viewModel = viewModel
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                
                SectionHeader(title: "Employee Information")
                DetailRow(title: "Employee Name", value: "\(timecard.firstName) \(timecard.lastName)")
                DetailRow(title: "Job Code", value: timecard.jobCode)
                
                SectionHeader(title: "Time Information")
                DetailRow(title: "Date", value: formatDate(timecard.date))
                DetailRow(title: "Start Time", value: formatTime(timecard.startTime))
                DetailRow(title: "End Time", value: formatTime(timecard.endTime))
                DetailRow(title: "Break Duration", value: String(format: "%.2f hours", timecard.breakDuration))
                DetailRow(title: "Total Hours", value: String(format: "%.2f", timecard.totalHours))
                
                SectionHeader(title: "Status Information")
                HStack {
                    Text("Status:")
                        .bold()
                    Text(timecard.status.rawValue.capitalized)
                        .foregroundColor(statusColor(for: timecard.status))
                }
                
                if timecard.status == .draft {
                    HStack {
                        Spacer()
                        Button("Edit Timecard") {
                            // Add edit action here
                        }
                        .buttonStyle(.borderedProminent)
                        .bold()
                        Spacer()
                        Button("Submit Timecard") {
                            showingSubmitAlert = true
                        }
                        .buttonStyle(.borderedProminent)
                        .bold()
                        Spacer()
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading) // Ensure full-width content
            .padding() // Add padding inside the ScrollView
        }
        .navigationTitle("Timecard Details")
        .alert("Submit Timecard", isPresented: $showingSubmitAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Submit") {
                viewModel.submitTimecard(timecard)
            }
        } message: {
            Text("Are you sure you want to submit this timecard? This action cannot be undone.")
        }
        .overlay {
            if viewModel.isLoading {
                ProgressView()
                    .scaleEffect(1.5)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.black.opacity(0.1))
            }
        }
    }
    
    // Helper functions for date formatting
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter.string(from: date)
    }
    
    private func formatTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
    
    private func statusColor(for status: TimecardStatus) -> Color {
        switch status {
        case .draft: return .gray
        case .submitted: return .blue
        case .approved: return .green
        case .rejected: return .red
        }
    }
}

private struct SectionHeader: View {
    let title: String
    
    var body: some View {
        Text(title)
            .font(.title2)
            .foregroundColor(.teal)
            .bold()
    }
}

private struct DetailRow: View {
    let title: String
    let value: String
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.subheadline)
                .foregroundColor(.gray)
            Text(value)
                .font(.body)
        }
    }
}