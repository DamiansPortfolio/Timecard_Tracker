//
//  ClockingSheet.swift
//  TimecardApp
//
//  Created by Anastasia Runion on 11/17/24.
//

import SwiftUI

struct ClockingSheet: View {
    @Binding var isClockedIn: Bool
    @Binding var clockInTime: Date?
    @Binding var clockOutTime: Date?
    @Binding var breakStartTime: Date?
    @Binding var totalWorkedTime: TimeInterval
    @Binding var totalBreakTime: TimeInterval
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Clock Management")
                .font(.largeTitle)
                .padding(.top)
            
            // Display Current Time
            Text("Current Time: \(Date(), formatter: timeFormatter)")
                .font(.headline)
            
            Divider()
            
            // Clock In/Out Button
            if isClockedIn {
                Button(action: clockOut) {
                    Text("Clock Out")
                        .font(.title)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.red)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            } else {
                Button(action: clockIn) {
                    Text("Clock In")
                        .font(.title)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
            
            // Break Button
            Button(action: toggleBreak) {
                Text(breakStartTime == nil ? "Start Break" : "End Break")
                    .font(.title2)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(breakStartTime == nil ? Color.yellow : Color.orange)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .disabled(!isClockedIn)
            
            // Time Tracking Summary
            VStack(alignment: .leading, spacing: 10) {
                Text("Time Summary:")
                    .font(.headline)
                
                if let clockInTime = clockInTime {
                    Text("Clocked In At: \(clockInTime, formatter: timeFormatter)")
                }
                
                if let clockOutTime = clockOutTime {
                    Text("Clocked Out At: \(clockOutTime, formatter: timeFormatter)")
                }
                
                Text("Total Worked Time: \(formatTimeInterval(totalWorkedTime))")
                Text("Total Break Time: \(formatTimeInterval(totalBreakTime))")
            }
            .padding()
            .background(Color.white.opacity(0.9))
            .cornerRadius(10)
            .shadow(radius: 5)
            
            Spacer()
        }
        .padding()
    }
    
    // Clock In Logic
    private func clockIn() {
        clockInTime = Date()
        isClockedIn = true
        clockOutTime = nil
        breakStartTime = nil
        totalWorkedTime = 0
        totalBreakTime = 0
    }
    
    // Clock Out Logic
    private func clockOut() {
        guard let clockInTime = clockInTime else { return }
        clockOutTime = Date()
        isClockedIn = false
        if let breakStartTime = breakStartTime {
            totalBreakTime += Date().timeIntervalSince(breakStartTime)
        }
        totalWorkedTime += clockOutTime!.timeIntervalSince(clockInTime) - totalBreakTime
        breakStartTime = nil
    }
    
    // Break Logic
    private func toggleBreak() {
        if let breakStartTime = breakStartTime {
            totalBreakTime += Date().timeIntervalSince(breakStartTime)
            self.breakStartTime = nil
        } else {
            breakStartTime = Date()
        }
    }
    
    private func formatTimeInterval(_ interval: TimeInterval) -> String {
        let hours = Int(interval) / 3600
        let minutes = (Int(interval) % 3600) / 60
        return "\(hours)h \(minutes)m"
    }
}

// Date Formatter
private let timeFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.timeStyle = .short
    return formatter
}()

// Preview

