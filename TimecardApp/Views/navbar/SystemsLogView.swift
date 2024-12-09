//
//  SystemsLogView.swift
//  TimecardApp
//
//  Created by Anastasia Runion on 11/22/24.
//

import SwiftUI
import FirebaseFirestore

struct SystemsLogView: View {
    @ObservedObject var viewModel: TimecardListViewModel
    @State private var isSystemLogEnabled: Bool = false // Local toggle state
    @State private var isLoading: Bool = true // Loading state for UI
    @State private var errorMessage: String?

    var body: some View {
        NavigationView {
            VStack {
                if isLoading {
                    ProgressView("Loading Settings...")
                } else {
                    // Toggle for enabling/disabling system logs
                    Toggle(isOn: $isSystemLogEnabled) {
                        Text("Enable System Logs")
                            .font(.headline)
                    }
                    .padding()
                    .onChange(of: isSystemLogEnabled) { newValue in
                        saveSystemLogState(newValue)
                    }

                    // Picker for Timecard Modes
                    Picker("Mode", selection: $viewModel.selectedMode) {
                        Text("Clock In/Out").tag(TimecardMode.ClockInOut)
                        Text("Select Hours").tag(TimecardMode.selectHours)
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding()

                    Spacer()
                    Text("Selected Mode: \(viewModel.selectedMode.rawValue)")
                        .font(.headline)
                }
            }
            .navigationTitle("Systems Log")
            .onAppear {
                fetchSystemLogState()
            }
        }
    }

    // Fetch the current state of the system log from Firestore
    private func fetchSystemLogState() {
        let db = Firestore.firestore()
        let documentId = "systemLogs" // Replace with your specific document ID

        db.collection("adminSettings").document(documentId).getDocument { snapshot, error in
            if let error = error {
                print("Error fetching system log state: \(error.localizedDescription)")
                self.errorMessage = "Failed to fetch system log state."
                self.isLoading = false
                return
            }

            guard let data = snapshot?.data() else {
                print("No data found for system log state.")
                self.isLoading = false
                return
            }

            self.isSystemLogEnabled = data["isSystemLogEnabled"] as? Bool ?? false
            self.isLoading = false
        }
    }

    // Save the system log state to Firestore
    private func saveSystemLogState(_ newValue: Bool) {
        let db = Firestore.firestore()
        let documentId = "systemLogs" // Replace with your specific document ID

        db.collection("adminSettings").document(documentId).setData(["isSystemLogEnabled": newValue]) { error in
            if let error = error {
                print("Error saving system log state: \(error.localizedDescription)")
                self.errorMessage = "Failed to save system log state."
            } else {
                print("System log state successfully updated to \(newValue).")
            }
        }
    }
}

enum TimecardMode: String, CaseIterable {
    case ClockInOut
    case selectHours
}



//import SwiftUI
//
//struct SystemsLogView: View { // Ensure it conforms to View
//    @ObservedObject var viewModel: TimecardListViewModel
////    @State private var selectedMode: TimecardMode = .ClockInOut
//
//    var body: some View {
//        NavigationView {
//            VStack {
//                Picker("Mode", selection: $viewModel.selectedMode) {
//                    Text("Clock In/Out").tag(TimecardMode.ClockInOut)
//                    Text("Select Hours").tag(TimecardMode.selectHours)
//                }
//                .pickerStyle(SegmentedPickerStyle())
//                .padding()
//                
//                Spacer()
//                Text("Selected Mode: \(viewModel.selectedMode.rawValue)")
//                    .font(.headline)
//            }
//            .navigationTitle("Systems Log")
//        }
//    }
//}
//
//enum TimecardMode: String, CaseIterable {
//    case ClockInOut
//    case selectHours
//}



//import SwiftUI
//import Combine
//
//struct SystemsLogView {
//    
//    @State private var selectedMode: TimecardMode = .ClockInOut
//    @ObservedObject var viewModel: TimecardListViewModel
//    
//    var body: some View {
//        NavigationView{
//            VStack{
//                Picker("Mode", selection: $selectedMode){
//                    Text("Clock In/Out").tag(TimecardMode.ClockInOut)
//                    Text("Select Hours").tag(TimecardMode.selectHours)
//                }
//                .pickerStyle(SegmentedPickerStyle())
//                .padding()
//                
//                if selectedMode == .ClockInOut{
//                    AddTimecardViewCIO(viewModel: viewModel)
//                } else {
//                    AddTimecardView(viewModel: viewModel)
//                }
//            }
//            .navigationTitle("Systems Log")
//        }
//    }
//}
//
//enum TimecardMode: String, CaseIterable {
//    case ClockInOut
//    case selectHours
//}
