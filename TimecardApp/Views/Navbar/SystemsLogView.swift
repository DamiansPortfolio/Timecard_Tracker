//
//  SystemsLogView.swift
//  TimecardApp
//
//  Created by Anastasia Runion on 11/22/24.
//


import SwiftUI

struct SystemsLogView: View { // Ensure it conforms to View
    @ObservedObject var viewModel: TimecardListViewModel
    //@State private var selectedMode: TimecardMode = .ClockInOut

    var body: some View {
        NavigationView {
            VStack {
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
            .navigationTitle("Systems Log")
        }
    }
}

enum TimecardMode: String, CaseIterable {
    case ClockInOut
    case selectHours
}

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
