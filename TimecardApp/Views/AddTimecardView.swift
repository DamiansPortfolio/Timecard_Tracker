import SwiftUI

struct AddTimecardView: View {
    @Environment(\.dismiss) var dismiss
    
    // Fields for the timecard
    @State private var employeeName: String = ""
    @State private var jobCode: String = ""
    @State private var date = Date()
    @State private var startTime = Date()
    @State private var endTime = Date()
    @State private var breakDuration: Double = 0.0
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Employee Details")) {
                    TextField("Employee Name", text: $employeeName)
                    TextField("Job Code", text: $jobCode)
                }
                
                Section(header: Text("Date and Time")) {
                    DatePicker("Date", selection: $date, displayedComponents: .date)
                        .datePickerStyle(GraphicalDatePickerStyle())
                    
                    DatePicker("Start Time", selection: $startTime, displayedComponents: .hourAndMinute)
                    DatePicker("End Time", selection: $endTime, displayedComponents: .hourAndMinute)
                    
                    HStack {
                        Text("Break Duration (hours)")
                        Spacer()
                        TextField("0.0", value: $breakDuration, formatter: NumberFormatter())
                            .keyboardType(.decimalPad)
                            .frame(width: 60)
                    }
                }
                
                Section(header: Text("Total Hours")) {
                    Text("\(calculateTotalHours(), specifier: "%.2f") hours")
                }
                
                
                
                Button("Confirm") {
                    dismiss()
                }
                .font(.headline)
                .frame(maxWidth: .infinity, alignment: .center)
            }
            .navigationTitle("Add Timecard")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
    
    // Calculate total hours based on start, end time, and break duration
    func calculateTotalHours() -> Double {
        let workedHours = endTime.timeIntervalSince(startTime) / 3600 // Convert seconds to hours
        return max(0, workedHours - breakDuration) // Subtract break duration, ensuring non-negative
    }
}

#Preview {
    AddTimecardView()
}
