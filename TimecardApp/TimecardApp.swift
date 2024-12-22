    // TimecardApp.swift
    import SwiftUI
    import Firebase

    @main
    struct TimecardApp: App {
        // Register app delegate
        @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
        
        var body: some Scene {
            WindowGroup {
                ContentView()
                    .tint(.teal)
            }
        }
    }
