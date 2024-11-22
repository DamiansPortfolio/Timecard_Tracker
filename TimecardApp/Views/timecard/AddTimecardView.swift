import SwiftUI
import FirebaseFirestore

struct AddTimecardView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel: TimecardListViewModel
    @State private var showError = false
    @State private var showSuccess = false
    @State private var showJobCodePicker = false
    
    @State private var selectedJobCode: JobCode = .development
    @State private var date = Date()
    @State private var startHour: Hour = .h9am
    @State private var endHour: Hour = .h5pm
    @State private var breakDuration: Double = 0.0
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Job Information")) {
                    Button(action: { showJobCodePicker = true }) {
                        HStack {
                            Text("Job Code")
                                .foregroundColor(.black)
                            Spacer()
                            Text(selectedJobCode.rawValue)
                        }
                    }
                }
                
                Section(header: Text("Date and Time")) {
                    DatePicker("Date", selection: $date, displayedComponents: .date)
                        .datePickerStyle(GraphicalDatePickerStyle())
                    
                    Picker("Start Time", selection: $startHour) {
                        ForEach(Hour.allCases) { hour in
                            Text(hour.display).tag(hour)
                        }
                    }
                    
                    Picker("End Time", selection: $endHour) {
                        ForEach(Hour.allCases) { hour in
                            Text(hour.display).tag(hour)
                        }
                    }
                    
                    HStack {
                        Text("Break Duration (hours)")
                        Spacer()
                        TextField("0.0", value: $breakDuration, formatter: NumberFormatter())
                            .keyboardType(.decimalPad)
                            .frame(width: 60)
                    }
                }
                
                Section(header: Text("Total Hours")) {
                    Text(String(format: "%.2f hours", calculateTotalHours()))
                }
                
                Button("Submit") {
                    submitTimecard()
                }
                .font(.headline)
                .frame(maxWidth: .infinity, alignment: .center)
                .disabled(viewModel.isLoading || !isValidInput())
            }
            .navigationTitle("Add Timecard")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Cancel") { dismiss() }
                        .bold()
                }
            }
            .sheet(isPresented: $showJobCodePicker) {
                JobCodePicker(selectedJobCode: $selectedJobCode)
            }
            .alert("Success", isPresented: $showSuccess) {
                Button("OK") { dismiss() }
            } message: {
                Text("Timecard has been successfully created")
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
    }
    
    private func isValidInput() -> Bool {
        calculateTotalHours() > 0
    }
    
    private func calculateTotalHours() -> Double {
        let startValue = startHour.rawValue
        let endValue = endHour.rawValue
        
        var hours: Double
        if endValue >= startValue {
            hours = Double(endValue - startValue)
        } else {
            hours = Double(24 - startValue + endValue)
        }
        
        return max(0, hours - breakDuration)
    }
    
    private func getDateWithHour(_ hour: Hour) -> Date {
        let calendar = Calendar.current
        var components = calendar.dateComponents([.year, .month, .day], from: date)
        components.hour = hour.rawValue
        components.minute = 0
        return calendar.date(from: components) ?? date
    }
    
    private func submitTimecard() {
        let startTime = getDateWithHour(startHour)
        let endTime = getDateWithHour(endHour)
        
        viewModel.addTimecard(
            jobCode: selectedJobCode.rawValue,
            date: date,
            startTime: startTime,
            endTime: endTime,
            breakDuration: breakDuration
        )
        
        // The view will automatically update due to the snapshot listener
        showSuccess = true
    }
}


