//
//  AddTimecardViewCIO.swift
//  TimecardApp
//
//  Created by Anastasia Runion on 11/22/24.
//

import SwiftUI
import FirebaseFirestore

struct AddTimecardViewCIO: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel: TimecardListViewModel
    @State private var showError = false
    @State private var showSuccess = false
    @State private var showJobCodePicker = false
    
    @State private var selectedJobCode: JobCode = .development
    @State private var date = Date()
    @State private var clockInTime: Date? = UserDefaults.standard.object(forKey: "clockInTime") as? Date
    @State private var breakStartTime: Date? = UserDefaults.standard.object(forKey: "breakStartTime") as? Date
    @State private var clockOutTime: Date? = nil
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
                
                Section(header: Text("Date")) {
                    DatePicker("Select Date", selection: $date, displayedComponents: .date)
                        .datePickerStyle(GraphicalDatePickerStyle())
                }
                
                Section(header: Text("Clock In / Out")) {
                    if let clockInTime = clockInTime {
                        Text("Clocked In: \(formattedTime(clockInTime))")
                    } else {
                        Button("Clock In") {
                            let now = Date()
                            clockInTime = now
                            UserDefaults.standard.set(now, forKey: "clockInTime")
                        }
                        .disabled(clockInTime != nil)
                    }
                    
                    if let breakStartTime = breakStartTime {
                        Text("On Break: \(formattedTime(breakStartTime))")
                    } else if clockInTime != nil && clockOutTime == nil {
                        Button("Start Break") {
                            let now = Date()
                            breakStartTime = now
                            UserDefaults.standard.set(now, forKey: "breakStartTime")
                        }
                        .disabled(clockInTime == nil || clockOutTime != nil)
                    }
                    
                    if let clockOutTime = clockOutTime {
                        Text("Clocked Out: \(formattedTime(clockOutTime))")
                    } else if clockInTime != nil {
                        Button("Clock Out") {
                            calculateBreakDuration()
                            let now = Date()
                            clockOutTime = now
                            UserDefaults.standard.removeObject(forKey: "clockInTime")
                            UserDefaults.standard.removeObject(forKey: "breakStartTime")
                            submitTimecard()
                        }
                        .disabled(clockInTime == nil || clockOutTime != nil)
                    }
                }
                
                Section(header: Text("Total Hours")) {
                    Text(String(format: "%.2f hours", calculateTotalHours()))
                }
                
                if clockOutTime != nil {
                    Button("Submit") {
                        submitTimecard()
                    }
                    .font(.headline)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .disabled(viewModel.isLoading || !isValidInput())
                }
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
            .onAppear {
                loadPersistedData()
            }
        }
    }
    
    private func loadPersistedData() {
        if let savedClockInTime = UserDefaults.standard.object(forKey: "clockInTime") as? Date {
            clockInTime = savedClockInTime
        }
        if let savedBreakStartTime = UserDefaults.standard.object(forKey: "breakStartTime") as? Date {
            breakStartTime = savedBreakStartTime
        }
    }
    
    private func isValidInput() -> Bool {
        clockInTime != nil && clockOutTime != nil
    }
    
    private func calculateTotalHours() -> Double {
        guard let clockInTime = clockInTime, let clockOutTime = clockOutTime else { return 0 }
        let totalTime = clockOutTime.timeIntervalSince(clockInTime) / 3600 // Total time in hours
        return max(0, totalTime - breakDuration)
    }
    
    private func calculateBreakDuration() {
        if let breakStartTime = breakStartTime, let clockOutTime = clockOutTime {
            let breakEndTime = clockOutTime
            breakDuration = breakEndTime.timeIntervalSince(breakStartTime) / 3600 // Break in hours
        }
    }
    
    private func formattedTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        formatter.dateStyle = .none
        return formatter.string(from: date)
    }
    
    private func submitTimecard() {
        guard let clockInTime = clockInTime, let clockOutTime = clockOutTime else { return }
        
        viewModel.addTimecard(
            jobCode: selectedJobCode.rawValue,
            date: date,
            startTime: clockInTime,
            endTime: clockOutTime,
            breakDuration: breakDuration
        )
        
        showSuccess = true
    }
}
