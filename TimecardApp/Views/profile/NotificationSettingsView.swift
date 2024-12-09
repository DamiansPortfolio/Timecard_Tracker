import SwiftUI

struct NotificationSettingsView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel = NotificationSettingsViewModel()
    
    var body: some View {
        NavigationView {
            Form {
                if !viewModel.notificationsAuthorized {
                    Section {
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Notifications are currently disabled")
                                .font(.headline)
                                .foregroundColor(.red)
                            
                            Text("Please enable notifications to use this feature.")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                            
                            Button("Enable Notifications") {
                                viewModel.requestNotificationPermissions()
                            }
                            .buttonStyle(.bordered)
                            .tint(.teal)
                        }
                        .padding(.vertical, 5)
                    }
                }
                
                Section(header: Text("General Notifications")) {
                    Toggle("Status Updates", isOn: $viewModel.preferences.statusUpdates)
                        .tint(.teal)
                    Toggle("Daily Reminders", isOn: $viewModel.preferences.dailyReminders)
                        .tint(.teal)
                    Toggle("Overtime Alerts", isOn: $viewModel.preferences.overtimeAlerts)
                        .tint(.teal)
                }
                
                Section(header: Text("Schedule Reminders")) {
                    Toggle("Enable Schedule Reminders", isOn: $viewModel.preferences.scheduleReminders)
                        .tint(.teal)
                    
                    if viewModel.preferences.scheduleReminders {
                        DatePicker("Work Start Time", 
                                 selection: Binding(
                                    get: { viewModel.preferences.workStartTime },
                                    set: { viewModel.preferences.workStartTime = $0 }
                                 ),
                                 displayedComponents: .hourAndMinute)
                        
                        DatePicker("Work End Time", 
                                 selection: Binding(
                                    get: { viewModel.preferences.workEndTime },
                                    set: { viewModel.preferences.workEndTime = $0 }
                                 ),
                                 displayedComponents: .hourAndMinute)
                        
                        DatePicker("Break Time", 
                                 selection: Binding(
                                    get: { viewModel.preferences.breakTime },
                                    set: { viewModel.preferences.breakTime = $0 }
                                 ),
                                 displayedComponents: .hourAndMinute)
                        
                        Picker("Reminder Time", selection: $viewModel.preferences.reminderAdvanceTime) {
                            Text("5 minutes before").tag(5)
                            Text("10 minutes before").tag(10)
                            Text("15 minutes before").tag(15)
                            Text("30 minutes before").tag(30)
                        }
                    }
                }
            }
            .navigationTitle("Notification Settings")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .bold()
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        viewModel.savePreferences()
                        dismiss()
                    }
                    .bold()
                }
            }
            .overlay {
                if viewModel.isLoading {
                    ProgressView()
                        .scaleEffect(1.5)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(Color.black.opacity(0.1))
                }
            }
            .alert("Enable Notifications", isPresented: $viewModel.showSettingsAlert) {
                Button("Open Settings") {
                    viewModel.openAppSettings()
                }
                Button("Cancel", role: .cancel) {}
            } message: {
                Text("Please enable notifications in Settings to use this feature.")
            }
        }
        .onAppear {
            viewModel.loadPreferences()
        }
    }
}