    //
    //  NotificationSettingsViewModel.swift
    //  TimecardApp
    //
    //  Created by Damian Rozycki on 12/5/24.
    //


import SwiftUI
import FirebaseFirestore
import UserNotifications

class NotificationSettingsViewModel: ObservableObject {
    @Published var preferences = NotificationPreferences()
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var notificationsAuthorized = false
    @Published var showSettingsAlert = false
    
    private let db = Firestore.firestore()
    
    init() {
        checkNotificationAuthorization()
    }
    
    func checkNotificationAuthorization() {
        let center = UNUserNotificationCenter.current()
        center.getNotificationSettings { [weak self] settings in
            DispatchQueue.main.async {
                self?.notificationsAuthorized = settings.authorizationStatus == .authorized
            }
        }
    }
    
    func requestNotificationPermissions() {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound, .badge]) { [weak self] granted, error in
            DispatchQueue.main.async {
                if granted {
                    self?.notificationsAuthorized = true
                } else {
                    self?.notificationsAuthorized = false
                    self?.showSettingsAlert = true
                }
            }
        }
    }
    
    func sendTestNotification() {
        print("Starting notification test...")
        
        // Check current notification settings
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            print("Notification Settings:")
            print("- Authorization Status: \(settings.authorizationStatus.rawValue)")
            print("- Alert Setting: \(settings.alertSetting)")
            print("- Badge Setting: \(settings.badgeSetting)")
            print("- Sound Setting: \(settings.soundSetting)")
            
            // Only proceed if authorized
            guard settings.authorizationStatus == .authorized else {
                print("❌ Notifications not authorized!")
                return
            }
            
            print("✅ Notifications are authorized, sending test...")
            
            let content = UNMutableNotificationContent()
            content.title = "TimecardApp Test"
            content.body = "If you see this, notifications are working!"
            content.sound = .default
            
            // Trigger immediately (no delay)
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
            
            let request = UNNotificationRequest(
                identifier: UUID().uuidString,
                content: content,
                trigger: trigger
            )
            
            UNUserNotificationCenter.current().add(request) { error in
                if let error = error {
                    print("❌ Error scheduling notification: \(error)")
                } else {
                    print("✅ Test notification scheduled")
                    
                    // Show all pending notifications
                    UNUserNotificationCenter.current().getPendingNotificationRequests { requests in
                        print("📋 Pending notifications: \(requests.count)")
                        requests.forEach { request in
                            print("- Notification: \(request.identifier)")
                            if let trigger = request.trigger as? UNTimeIntervalNotificationTrigger {
                                print("  Next trigger date: \(trigger.nextTriggerDate() ?? Date())")
                            }
                        }
                    }
                }
            }
        }
    }
    
    func savePreferences() {
        guard notificationsAuthorized else {
            requestNotificationPermissions()
            return
        }
        
        guard let userId = UserDefaults.standard.string(forKey: "userId") else { return }
        
        isLoading = true
        
        let data: [String: Any] = [
            "statusUpdates": preferences.statusUpdates,
            "dailyReminders": preferences.dailyReminders,
            "overtimeAlerts": preferences.overtimeAlerts,
            "scheduleReminders": preferences.scheduleReminders,
            "workStartHour": preferences.workStartHour,
            "workStartMinute": preferences.workStartMinute,
            "workEndHour": preferences.workEndHour,
            "workEndMinute": preferences.workEndMinute,
            "breakHour": preferences.breakHour,
            "breakMinute": preferences.breakMinute,
            "reminderAdvanceTime": preferences.reminderAdvanceTime
        ]
        
        db.collection("users").document(userId).collection("preferences").document("notifications")
            .setData(data) { [weak self] error in
                DispatchQueue.main.async {
                    self?.isLoading = false
                    if let error = error {
                        self?.errorMessage = error.localizedDescription
                    } else {
                        NotificationScheduler.shared.scheduleNotifications(for: self?.preferences ?? NotificationPreferences())
                    }
                }
            }
    }
    
    func loadPreferences() {
        guard let userId = UserDefaults.standard.string(forKey: "userId") else { return }
        
        isLoading = true
        
        db.collection("users").document(userId).collection("preferences").document("notifications")
            .getDocument { [weak self] document, error in
                DispatchQueue.main.async {
                    self?.isLoading = false
                    
                    if let error = error {
                        self?.errorMessage = error.localizedDescription
                        return
                    }
                    
                    if let data = document?.data() {
                        self?.preferences.statusUpdates = data["statusUpdates"] as? Bool ?? true
                        self?.preferences.dailyReminders = data["dailyReminders"] as? Bool ?? false
                        self?.preferences.overtimeAlerts = data["overtimeAlerts"] as? Bool ?? true
                        self?.preferences.scheduleReminders = data["scheduleReminders"] as? Bool ?? false
                        self?.preferences.workStartHour = data["workStartHour"] as? Int ?? 9
                        self?.preferences.workStartMinute = data["workStartMinute"] as? Int ?? 0
                        self?.preferences.workEndHour = data["workEndHour"] as? Int ?? 17
                        self?.preferences.workEndMinute = data["workEndMinute"] as? Int ?? 0
                        self?.preferences.breakHour = data["breakHour"] as? Int ?? 12
                        self?.preferences.breakMinute = data["breakMinute"] as? Int ?? 0
                        self?.preferences.reminderAdvanceTime = data["reminderAdvanceTime"] as? Int ?? 15
                    }
                }
            }
    }
    
    func openAppSettings() {
        if let url = URL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(url)
        }
    }
}
