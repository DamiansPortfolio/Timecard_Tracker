//
//  AddLeaveRequests.swift
//  TimecardApp
//
//  Created by Anastasia Runion on 11/22/24.
//

//import SwiftUI
//
//struct AddLeaveRequest: View {
//    @ObservedObject var viewModel: LeaveRequestViewModel
//    @State private var leaveType = ""
//    @State private var startDate = Date()
//    @State private var endDate = Date()
//    @State private var reason = ""
//
//    var body: some View {
//        Form {
//            Section(header: Text("Leave Request Details")) {
//                TextField("Leave Type", text: $leaveType)
//                DatePicker("Start Date", selection: $startDate, displayedComponents: .date)
//                DatePicker("End Date", selection: $endDate, displayedComponents: .date)
//                TextField("Reason", text: $reason)
//                    .textFieldStyle(RoundedBorderTextFieldStyle())
//            }
//
//            Button("Submit") {
//                viewModel.submitLeaveRequest(
//                    leaveType: leaveType,
//                    startDate: startDate,
//                    endDate: endDate,
//                    reason: reason
//                )
//            }
//            .disabled(viewModel.isLoading)
//        }
//        .navigationTitle("Request Leave")
//        .alert(item: Binding(
//            get: { viewModel.errorMessage.map { ErrorAlert(message: $0) } },
//            set: { _ in viewModel.errorMessage = nil }
//        )) { alert in
//            Alert(title: Text("Error"), message: Text(alert.message), dismissButton: .default(Text("OK")))
//        }
//        .alert(item: Binding(
//            get: { viewModel.successMessage.map { SuccessAlert(message: $0) } },
//            set: { _ in viewModel.successMessage = nil }
//        )) { alert in
//            Alert(title: Text("Success"), message: Text(alert.message), dismissButton: .default(Text("OK")))
//        }
//        .overlay {
//            if viewModel.isLoading {
//                ProgressView("Submitting...")
//                    .frame(maxWidth: .infinity, maxHeight: .infinity)
//                    .background(Color.black.opacity(0.5))
//            }
//        }
//    }
//}
//
//struct ErrorAlert: Identifiable {
//    let id = UUID()
//    let message: String
//}
//
//struct SuccessAlert: Identifiable {
//    let id = UUID()
//    let message: String
//}








//
//import SwiftUI
//
//struct AddLeaveRequestView: View {
//    @ObservedObject var viewModel: LeaveRequestViewModel
//    
//    @State private var leaveType: String = "Paid Time Off" // Default leave type
//    @State private var startDate: Date = Date()
//    @State private var endDate: Date = Date()
//    @State private var reason: String = ""
//
//    let leaveTypes = ["Paid Time Off", "Time Off (Unpaid)", "Sick Leave", "Other"] // Add more types as needed
//
//    var body: some View {
//        NavigationView {
//            VStack {
//                // Calendar for Date Selection
//                VStack(alignment: .leading) {
//                    Text("Select Dates")
//                        .font(.headline)
//                        .padding(.bottom, 5)
//                    
//                    // Custom calendar-style date pickers
//                    DatePicker("Start Date", selection: $startDate, displayedComponents: .date)
//                        .datePickerStyle(GraphicalDatePickerStyle())
//                        .padding()
//                    
//                    DatePicker("End Date", selection: $endDate, displayedComponents: .date)
//                        .datePickerStyle(GraphicalDatePickerStyle())
//                        .padding()
//                }
//                .background(Color(.systemGray6))
//                .cornerRadius(10)
//                .padding()
//
//                // Leave Type Picker
//                VStack(alignment: .leading) {
//                    Text("Leave Type")
//                        .font(.headline)
//                        .padding(.bottom, 5)
//                    
//                    Picker("Select Leave Type", selection: $leaveType) {
//                        ForEach(leaveTypes, id: \.self) { type in
//                            Text(type).tag(type)
//                        }
//                    }
//                    .pickerStyle(MenuPickerStyle())
//                    .padding()
//                    .background(Color(.systemGray6))
//                    .cornerRadius(10)
//                    .padding()
//                }
//
//                // Reason for Leave
//                VStack(alignment: .leading) {
//                    Text("Reason")
//                        .font(.headline)
//                        .padding(.bottom, 5)
//                    
//                    TextField("Reason (Optional)", text: $reason)
//                        .textFieldStyle(RoundedBorderTextFieldStyle())
//                        .padding()
//                }
//                .padding()
//
//                // Submit Button
//                Button(action: {
//                    viewModel.submitLeaveRequest(
//                        leaveType: leaveType,
//                        startDate: startDate,
//                        endDate: endDate,
//                        reason: reason
//                    )
//                }) {
//                    Text("Submit Leave Request")
//                        .bold()
//                        .frame(maxWidth: .infinity, minHeight: 44)
//                        .background(viewModel.isLoading ? Color.gray : Color.blue)
//                        .foregroundColor(.white)
//                        .cornerRadius(10)
//                        .padding()
//                }
//                .disabled(viewModel.isLoading)
//            }
//            .navigationTitle("Request Leave")
//            .background(Color(.systemGroupedBackground).edgesIgnoringSafeArea(.all))
//            .overlay {
//                if viewModel.isLoading {
//                    ProgressView("Submitting...")
//                        .scaleEffect(1.5)
//                        .frame(maxWidth: .infinity, maxHeight: .infinity)
//                        .background(Color.black.opacity(0.1))
//                }
//            }
//            .alert(item: $viewModel.errorMessage) { error in
//                Alert(
//                    title: Text("Error"),
//                    message: Text(error),
//                    dismissButton: .default(Text("OK"))
//                )
//            }
//        }
//    }
//}



//
//
//import SwiftUI
//
//struct AddLeaveRequests: View {
//    @ObservedObject var viewModel: LeaveRequestViewModel
//
//    @State private var leaveType: String = "Paid Time Off" // Default leave type
//    @State private var startDate: Date = Date()
//    @State private var endDate: Date = Date()
//    @State private var reason: String = ""
//
//    private let leaveTypes = ["Paid Time Off", "Unpaid Time Off", "Sick Leave", "Family Leave"]
//
//    var body: some View {
//        NavigationView {
//            Form {
//                Section(header: Text("Leave Request Details")) {
//                    Picker("Leave Type", selection: $leaveType) {
//                        ForEach(leaveTypes, id: \.self) { type in
//                            Text(type)
//                        }
//                    }
//                    .pickerStyle(MenuPickerStyle())
//
//                    DatePicker("Start Date", selection: $startDate, displayedComponents: .date)
//                        .datePickerStyle(GraphicalDatePickerStyle())
//
//                    DatePicker("End Date", selection: $endDate, displayedComponents: .date)
//                        .datePickerStyle(GraphicalDatePickerStyle())
//
//                    TextField("Reason", text: $reason)
//                        .textFieldStyle(RoundedBorderTextFieldStyle())
//                }
//
//                Button(action: {
//                    viewModel.submitLeaveRequest(
//                        leaveType: leaveType,
//                        startDate: startDate,
//                        endDate: endDate,
//                        reason: reason
//                    )
//                }) {
//                    Text("Submit")
//                        .fontWeight(.bold)
//                        .frame(maxWidth: .infinity)
//                        .padding()
//                        .background(viewModel.isLoading ? Color.gray : Color.blue)
//                        .foregroundColor(.white)
//                        .cornerRadius(8)
//                }
//                .disabled(viewModel.isLoading || reason.isEmpty || startDate > endDate)
//            }
//            .navigationTitle("Request Leave")
//            .alert(item: $viewModel.errorMessage) { alertItem in
//                Alert(
//                    title: Text("Error"),
//                    message: Text(alertItem.message),
//                    dismissButton: .default(Text("OK"))
//                )
//            }
//            .alert(item: $viewModel.successMessage) { alertItem in
//                Alert(
//                    title: Text("Success"),
//                    message: Text(alertItem.message),
//                    dismissButton: .default(Text("OK"))
//                )
//            }
//        }
//    }
//}


//import SwiftUI
//
//struct AddLeaveRequests: View {
//    @ObservedObject var viewModel: LeaveRequestViewModel
//
//    @State private var leaveType: LeaveType = .paidTimeOff // Default leave type
//    @State private var startDate: Date = Date()
//    @State private var endDate: Date = Date()
//    @State private var reason: String = ""
//
//    // Enum for leave types
//    enum LeaveType: String, CaseIterable, Identifiable {
//        case paidTimeOff = "Paid Time Off"
//        case unpaidTimeOff = "Unpaid Time Off"
//        
//        var id: String { self.rawValue }
//    }
//
//    var body: some View {
//        NavigationView {
//            Form {
//                Section(header: Text("Leave Request Details")) {
//                    // Dropdown for Leave Type
//                    Picker("Leave Type", selection: $leaveType) {
//                        ForEach(LeaveType.allCases) { type in
//                            Text(type.rawValue).tag(type)
//                        }
//                    }
//                    .pickerStyle(MenuPickerStyle())
//
////                    // Date Pickers
////                    DatePicker("Start Date", selection: $startDate, displayedComponents: .date)
////                        .datePickerStyle(GraphicalDatePickerStyle())
////
////                    DatePicker("End Date", selection: $endDate, displayedComponents: .date)
////                        .datePickerStyle(GraphicalDatePickerStyle())
//                    
//                    DatePicker("Start Date", selection: $startDate, displayedComponents: .date)
//                    DatePicker("End Date", selection: $endDate, displayedComponents: .date)
//
//                    // Reason TextField
//                    TextField("Reason", text: $reason)
//                        .textFieldStyle(RoundedBorderTextFieldStyle())
//                }
//
//                // Submit Button
//                Button(action: {
//                    viewModel.submitLeaveRequest(
//                        leaveType: leaveType.rawValue, // Use rawValue of the selected type
//                        startDate: startDate,
//                        endDate: endDate,
//                        reason: reason
//                    )
//                }) {
//                    Text("Submit")
//                        .fontWeight(.bold)
//                        .frame(maxWidth: .infinity)
//                        .padding()
//                        .background(viewModel.isLoading ? Color.gray : Color.blue)
//                        .foregroundColor(.white)
//                        .cornerRadius(8)
//                }
//                .disabled(viewModel.isLoading || reason.isEmpty || startDate > endDate)
//            }
//            .navigationTitle("Request Leave")
//            .alert(item: $viewModel.errorMessage) { alertItem in
//                Alert(
//                    title: Text("Error"),
//                    message: Text(alertItem.message),
//                    dismissButton: .default(Text("OK"))
//                )
//            }
//            .alert(item: $viewModel.successMessage) { alertItem in
//                Alert(
//                    title: Text("Success"),
//                    message: Text(alertItem.message),
//                    dismissButton: .default(Text("OK"))
//                )
//            }
//        }
//    }
//}


import SwiftUI

struct AddLeaveRequests: View {
    @ObservedObject var viewModel: LeaveRequestViewModel

    @State private var leaveType: LeaveType = .paidTimeOff // Default leave type
    @State private var startDate: Date = Date()
    @State private var endDate: Date = Date()
    @State private var reason: String = ""

    enum LeaveType: String, CaseIterable, Identifiable {
        case paidTimeOff = "Paid Time Off"
        case unpaidTimeOff = "Unpaid Time Off"
        
        var id: String { self.rawValue }
    }

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Leave Request Details")) {
                    Picker("Leave Type", selection: $leaveType) {
                        ForEach(LeaveType.allCases) { type in
                            Text(type.rawValue).tag(type)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    DatePicker("Start Date", selection: $startDate, displayedComponents: .date)
                    DatePicker("End Date", selection: $endDate, displayedComponents: .date)

//                    DatePicker("Start Date", selection: $startDate, displayedComponents: .date)
//                        .datePickerStyle(GraphicalDatePickerStyle())
//                        .disabled(false) // Enable for selection
//
//                    DatePicker("End Date", selection: $endDate, displayedComponents: .date)
//                        .datePickerStyle(GraphicalDatePickerStyle())
//                        .disabled(false) // Enable for selection

                    TextField("Reason", text: $reason)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }

                Button(action: {
                    print("Submit button pressed")
                    viewModel.submitLeaveRequest(
                        leaveType: leaveType.rawValue,
                        startDate: startDate,
                        endDate: endDate,
                        reason: reason
                    )
                }) {
                    Text("Submit")
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(viewModel.isLoading ? Color.gray : Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                
            }
            .navigationTitle("Request Leave")
            .alert(item: $viewModel.errorMessage) { alertItem in
                Alert(
                    title: Text(alertItem.title),
                    message: Text(alertItem.message),
                    dismissButton: .default(Text("OK"))
                )
            }
            .alert(item: $viewModel.successMessage) { alertItem in
                Alert(
                    title: Text(alertItem.title),
                    message: Text(alertItem.message),
                    dismissButton: .default(Text("OK"))
                )
            }
        }
    }
}

