// NotificationScheduler.swift
import Foundation
import UserNotifications

class NotificationScheduler {
    static let shared = NotificationScheduler()
    private let notificationCenter = UNUserNotificationCenter.current()
    
    private init() {}
    
    func scheduleNotifications(for preferences: NotificationPreferences) {
        // First remove all existing notifications
        notificationCenter.removeAllPendingNotificationRequests()
        
        if preferences.scheduleReminders {
            scheduleWorkReminders(preferences)
        }
        
        if preferences.dailyReminders {
            scheduleDailyTimecardReminder()
        }
    }
    
    private func scheduleWorkReminders(_ preferences: NotificationPreferences) {
        // Schedule work start reminder
        scheduleWorkStartReminder(hour: preferences.workStartHour,
                                minute: preferences.workStartMinute,
                                advanceMinutes: preferences.reminderAdvanceTime)
        
        // Schedule work end reminder
        scheduleWorkEndReminder(hour: preferences.workEndHour,
                              minute: preferences.workEndMinute,
                              advanceMinutes: preferences.reminderAdvanceTime)
        
        // Schedule break reminder
        scheduleBreakReminder(hour: preferences.breakHour,
                            minute: preferences.breakMinute,
                            advanceMinutes: preferences.reminderAdvanceTime)
    }
    
    private func scheduleWorkStartReminder(hour: Int, minute: Int, advanceMinutes: Int) {
        var dateComponents = DateComponents()
        
        // Calculate reminder time by subtracting advance minutes
        let (adjustedHour, adjustedMinute) = adjustTimeForAdvanceNotification(hour: hour,
                                                                            minute: minute,
                                                                            advanceMinutes: advanceMinutes)
        
        dateComponents.hour = adjustedHour
        dateComponents.minute = adjustedMinute
        // Only trigger on weekdays (1 = Sunday, 2 = Monday, ..., 7 = Saturday)
        dateComponents.weekday = 2...6 // Monday through Friday
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        
        let content = UNMutableNotificationContent()
        content.title = "Work Start Reminder"
        content.body = "Your work starts in \(advanceMinutes) minutes"
        content.sound = .default
        content.categoryIdentifier = NotificationCategory.schedule.rawValue
        
        let request = UNNotificationRequest(identifier: "workStart",
                                          content: content,
                                          trigger: trigger)
        
        notificationCenter.add(request) { error in
            if let error = error {
                print("Error scheduling work start notification: \(error)")
            }
        }
    }
    
    private func scheduleWorkEndReminder(hour: Int, minute: Int, advanceMinutes: Int) {
        var dateComponents = DateComponents()
        
        let (adjustedHour, adjustedMinute) = adjustTimeForAdvanceNotification(hour: hour,
                                                                            minute: minute,
                                                                            advanceMinutes: advanceMinutes)
        
        dateComponents.hour = adjustedHour
        dateComponents.minute = adjustedMinute
        dateComponents.weekday = 2...6 // Monday through Friday
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        
        let content = UNMutableNotificationContent()
        content.title = "Work End Reminder"
        content.body = "Your work day ends in \(advanceMinutes) minutes"
        content.sound = .default
        content.categoryIdentifier = NotificationCategory.schedule.rawValue
        
        let request = UNNotificationRequest(identifier: "workEnd",
                                          content: content,
                                          trigger: trigger)
        
        notificationCenter.add(request) { error in
            if let error = error {
                print("Error scheduling work end notification: \(error)")
            }
        }
    }
    
    private func scheduleBreakReminder(hour: Int, minute: Int, advanceMinutes: Int) {
        var dateComponents = DateComponents()
        
        let (adjustedHour, adjustedMinute) = adjustTimeForAdvanceNotification(hour: hour,
                                                                            minute: minute,
                                                                            advanceMinutes: advanceMinutes)
        
        dateComponents.hour = adjustedHour
        dateComponents.minute = adjustedMinute
        dateComponents.weekday = 2...6 // Monday through Friday
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        
        let content = UNMutableNotificationContent()
        content.title = "Break Time Reminder"
        content.body = "Your break starts in \(advanceMinutes) minutes"
        content.sound = .default
        content.categoryIdentifier = NotificationCategory.schedule.rawValue
        
        let request = UNNotificationRequest(identifier: "break",
                                          content: content,
                                          trigger: trigger)
        
        notificationCenter.add(request) { error in
            if let error = error {
                print("Error scheduling break notification: \(error)")
            }
        }
    }
    
    private func scheduleDailyTimecardReminder() {
        var dateComponents = DateComponents()
        dateComponents.hour = 16  // 4 PM
        dateComponents.minute = 0
        dateComponents.weekday = 2...6 // Monday through Friday
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        
        let content = UNMutableNotificationContent()
        content.title = "Timecard Reminder"
        content.body = "Don't forget to submit your timecard for today!"
        content.sound = .default
        content.categoryIdentifier = NotificationCategory.timecard.rawValue
        
        let request = UNNotificationRequest(identifier: "dailyTimecard",
                                          content: content,
                                          trigger: trigger)
        
        notificationCenter.add(request) { error in
            if let error = error {
                print("Error scheduling daily timecard notification: \(error)")
            }
        }
    }
    
    func scheduleTimecardStatusNotification(status: TimecardStatus) {
        let content = UNMutableNotificationContent()
        content.categoryIdentifier = NotificationCategory.status.rawValue
        content.sound = .default
        
        switch status {
        case .approved:
            content.title = "Timecard Approved"
            content.body = "Your timecard has been approved!"
        case .rejected:
            content.title = "Timecard Rejected"
            content.body = "Your timecard needs revision. Please check and resubmit."
        default:
            return
        }
        
        // Trigger immediately
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        
        let request = UNNotificationRequest(identifier: UUID().uuidString,
                                          content: content,
                                          trigger: trigger)
        
        notificationCenter.add(request) { error in
            if let error = error {
                print("Error scheduling timecard status notification: \(error)")
            }
        }
    }
    
    // Helper function to calculate the correct notification time
    private func adjustTimeForAdvanceNotification(hour: Int, minute: Int, advanceMinutes: Int) -> (hour: Int, minute: Int) {
        let calendar = Calendar.current
        var dateComponents = DateComponents()
        dateComponents.hour = hour
        dateComponents.minute = minute
        
        guard let date = calendar.date(from: dateComponents) else {
            return (hour, minute)
        }
        
        guard let adjustedDate = calendar.date(byAdding: .minute, value: -advanceMinutes, to: date) else {
            return (hour, minute)
        }
        
        let adjustedComponents = calendar.dateComponents([.hour, .minute], from: adjustedDate)
        return (adjustedComponents.hour ?? hour, adjustedComponents.minute ?? minute)
    }
    
    // Function to check scheduled notifications (useful for debugging)
    func checkScheduledNotifications() {
        notificationCenter.getPendingNotificationRequests { requests in
            for request in requests {
                print("Scheduled notification: \(request.identifier)")
                if let trigger = request.trigger as? UNCalendarNotificationTrigger {
                    print("Next trigger date: \(trigger.nextTriggerDate() ?? Date())")
                }
            }
        }
    }
}