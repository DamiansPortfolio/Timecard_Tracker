import Foundation

struct NotificationPreferences {
    var statusUpdates: Bool = true
    var dailyReminders: Bool = false
    var overtimeAlerts: Bool = true
    var scheduleReminders: Bool = false
    
    // Custom schedule settings
    var workStartHour: Int = 9
    var workStartMinute: Int = 0
    var workEndHour: Int = 17
    var workEndMinute: Int = 0
    var breakHour: Int = 12
    var breakMinute: Int = 0
    var reminderAdvanceTime: Int = 15 // minutes before
    
    // Computed properties for Date objects
    var workStartTime: Date {
        get {
            Calendar.current.date(from: DateComponents(hour: workStartHour, minute: workStartMinute)) ?? Date()
        }
        set {
            let components = Calendar.current.dateComponents([.hour, .minute], from: newValue)
            workStartHour = components.hour ?? 9
            workStartMinute = components.minute ?? 0
        }
    }
    
    var workEndTime: Date {
        get {
            Calendar.current.date(from: DateComponents(hour: workEndHour, minute: workEndMinute)) ?? Date()
        }
        set {
            let components = Calendar.current.dateComponents([.hour, .minute], from: newValue)
            workEndHour = components.hour ?? 17
            workEndMinute = components.minute ?? 0
        }
    }
    
    var breakTime: Date {
        get {
            Calendar.current.date(from: DateComponents(hour: breakHour, minute: breakMinute)) ?? Date()
        }
        set {
            let components = Calendar.current.dateComponents([.hour, .minute], from: newValue)
            breakHour = components.hour ?? 12
            breakMinute = components.minute ?? 0
        }
    }
}