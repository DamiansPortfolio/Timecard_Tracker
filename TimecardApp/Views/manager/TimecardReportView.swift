//
//  TimecardReportView.swift
//  TimecardApp
//
//  Created by Anh Phan on 12/9/24.
//


import SwiftUI

struct TimecardReportView: View {
    @StateObject private var reportViewModel = TimecardReportViewModel()
    @ObservedObject var managerViewModel: ManagerViewModel
    @Environment(\.dismiss) private var dismiss
    
    @State private var startDate = Date()
    @State private var endDate = Date()
    @State private var showingShareSheet = false
    @State private var showingPreview = false
    @State private var generatedPDFData: Data?
    @State private var selectedEmployees: Set<String> = []
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Date Range")) {
                    DatePicker("From",
                               selection: $startDate,
                               displayedComponents: [.date])
                    
                    DatePicker("To",
                               selection: $endDate,
                               displayedComponents: [.date])
                }
                
                Section(header: Text("Select Employees")) {
                    ForEach(managerViewModel.managedEmployees) { employee in
                        HStack {
                            VStack(alignment: .leading) {
                                Text("\(employee.fname) \(employee.lname)")
                                    .font(.headline)
                                Text(employee.title)
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                            Spacer()
                            Image(
                                systemName: selectedEmployees
                                    .contains(
                                        employee.username
                                    ) ? "checkmark.circle.fill" : "circle"
                            )
                            .foregroundColor(
                                selectedEmployees
                                    .contains(employee.username) ? .teal : .gray
                            )
                        }
                        .onTapGesture {
                            if selectedEmployees.contains(employee.username) {
                                selectedEmployees.remove(employee.username)
                            } else {
                                selectedEmployees.insert(employee.username)
                            }
                        }
                    }
                    Button(action: selectAllEmployees) {
                        Text(
                            selectedEmployees.count == managerViewModel.managedEmployees.count ? "Deselect All" : "Select All"
                        )
                        .frame(maxWidth: .infinity)
                    }
                }
                
                Button("Generate") {
                    generateReport()
                }
                .bold()
                .frame(maxWidth: .infinity)
                .disabled(
                    reportViewModel.isGenerating || selectedEmployees.isEmpty
                )
                
                if reportViewModel.isGenerating {
                    Section {
                        HStack {
                            Spacer()
                            ProgressView("Generating Report...")
                            Spacer()
                        }
                    }
                }
                
                if let error = reportViewModel.errorMessage {
                    Section {
                        Text(error)
                            .foregroundColor(.red)
                    }
                }
            }
            .navigationTitle("Timecards Report")
            .sheet(isPresented: $showingPreview) {
                if let pdfData = generatedPDFData {
                    PDFPreviewSheet(
                        pdfData: pdfData,
                        showingPreview: $showingPreview,
                        showingShareSheet: $showingShareSheet
                    )
                }
            }
            .sheet(isPresented: $showingShareSheet) {
                if let pdfData = generatedPDFData {
                    ShareSheet(activityItems: [pdfData])
                }
            }
        }
    }
    
    private func selectAllEmployees() {
        if selectedEmployees.count == managerViewModel.managedEmployees.count {
            selectedEmployees.removeAll()
        } else {
            selectedEmployees = Set(
                managerViewModel.managedEmployees.map { $0.username
                })
        }
    }
    
    private func generateReport() {
        Task {
            do {
                let selectedEmployeesList = managerViewModel.managedEmployees.filter {
                    selectedEmployees.contains($0.username)
                }
                
                generatedPDFData = try await reportViewModel.generateReport(
                    for: selectedEmployeesList,
                    startDate: startDate,
                    endDate: endDate
                )
                
                await MainActor.run {
                    showingPreview = true
                }
            } catch {
                await MainActor.run {
                    reportViewModel.errorMessage = error.localizedDescription
                }
            }
        }
    }
}

struct ShareSheet: UIViewControllerRepresentable {
    let activityItems: [Any]
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        let controller = UIActivityViewController(
            activityItems: activityItems,
            applicationActivities: nil
        )
        return controller
    }
    
    func updateUIViewController(
        _ uiViewController: UIActivityViewController,
        context: Context
    ) {
    }
}
