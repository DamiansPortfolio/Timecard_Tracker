import SwiftUI
import PDFKit
import FirebaseFirestore

class TimecardReportViewModel: ObservableObject {
    @Published var isGenerating: Bool = false
    @Published var errorMessage: String?
    
    private let db = Firestore.firestore()
    
    func generateReport(for employees: [Profile], startDate: Date, endDate: Date) async throws -> Data {
        isGenerating = true
        defer { isGenerating = false }
        
        // First, fetch all timecard data
        var employeeTimecards: [(Profile, [Timecard])] = []
        for employee in employees {
            let timecards = try await fetchTimecards(for: employee.username, startDate: startDate, endDate: endDate)
            employeeTimecards.append((employee, timecards))
        }
        
        // Create PDF document
        let pdfMetaData = [
            kCGPDFContextCreator: "Timecard Management System",
            kCGPDFContextAuthor: "Manager Report",
            kCGPDFContextTitle: "Employee Timecard Report"
        ]
        
        let format = UIGraphicsPDFRendererFormat()
        format.documentInfo = pdfMetaData as [String: Any]
        
        let pageRect = CGRect(x: 0, y: 0, width: 612, height: 792) // US Letter size
        let renderer = UIGraphicsPDFRenderer(bounds: pageRect, format: format)
        
        return renderer.pdfData { context in
            // Create date formatter
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium
            
            let timeFormatter = DateFormatter()
            timeFormatter.timeStyle = .short
            
            // Setup fonts and colors
            let titleFont = UIFont.boldSystemFont(ofSize: 20)
            let headerFont = UIFont.boldSystemFont(ofSize: 16)
            let subheaderFont = UIFont.boldSystemFont(ofSize: 14)
            let bodyFont = UIFont.systemFont(ofSize: 12)
            let smallFont = UIFont.systemFont(ofSize: 10)
            
            // Draw cover page
            context.beginPage()
            let title = "Timecard Summary Report"
            let dateRange = "\(dateFormatter.string(from: startDate)) - \(dateFormatter.string(from: endDate))"
            
            title.draw(at: CGPoint(x: 50, y: 50), withAttributes: [.font: titleFont])
            dateRange.draw(at: CGPoint(x: 50, y: 80), withAttributes: [.font: headerFont])
            
            // Draw report summary
            var summaryY: CGFloat = 120
            let totalEmployees = employeeTimecards.count
            let totalTimecards = employeeTimecards.reduce(0) { $0 + $1.1.count }
            let totalHours = employeeTimecards.reduce(0.0) { $0 + $1.1.reduce(0.0) { $0 + $1.totalHours } }
            
            "Report Summary:".draw(at: CGPoint(x: 50, y: summaryY), withAttributes: [.font: subheaderFont])
            summaryY += 25
            "Total Employees: \(totalEmployees)".draw(at: CGPoint(x: 70, y: summaryY), withAttributes: [.font: bodyFont])
            summaryY += 20
            "Total Timecards: \(totalTimecards)".draw(at: CGPoint(x: 70, y: summaryY), withAttributes: [.font: bodyFont])
            summaryY += 20
            "Total Hours: \(String(format: "%.1f", totalHours))".draw(at: CGPoint(x: 70, y: summaryY), withAttributes: [.font: bodyFont])
            
            // Draw detailed employee pages
            for (employee, timecards) in employeeTimecards {
                context.beginPage()
                var yPosition: CGFloat = 50
                
                // Employee header
                let employeeHeader = "\(employee.fname) \(employee.lname)"
                employeeHeader.draw(at: CGPoint(x: 50, y: yPosition), withAttributes: [.font: headerFont])
                yPosition += 25
                
                // Employee details
                "Title: \(employee.title)".draw(at: CGPoint(x: 50, y: yPosition), withAttributes: [.font: bodyFont])
                yPosition += 20
                "Department: \(employee.department)".draw(at: CGPoint(x: 50, y: yPosition), withAttributes: [.font: bodyFont])
                yPosition += 20
                "Email: \(employee.email)".draw(at: CGPoint(x: 50, y: yPosition), withAttributes: [.font: bodyFont])
                yPosition += 30
                
                // Timecard summary for employee
                let approvedCards = timecards.filter { $0.status == .approved }
                let rejectedCards = timecards.filter { $0.status == .rejected }
                let pendingCards = timecards.filter { $0.status == .submitted }
                let totalEmployeeHours = timecards.reduce(0.0) { $0 + $1.totalHours }
                
                "Timecard Summary:".draw(at: CGPoint(x: 50, y: yPosition), withAttributes: [.font: subheaderFont])
                yPosition += 25
                "Total Hours: \(String(format: "%.1f", totalEmployeeHours))".draw(at: CGPoint(x: 70, y: yPosition), withAttributes: [.font: bodyFont])
                yPosition += 20
                "Approved Timecards: \(approvedCards.count)".draw(at: CGPoint(x: 70, y: yPosition), withAttributes: [.font: bodyFont])
                yPosition += 20
                "Rejected Timecards: \(rejectedCards.count)".draw(at: CGPoint(x: 70, y: yPosition), withAttributes: [.font: bodyFont])
                yPosition += 20
                "Pending Timecards: \(pendingCards.count)".draw(at: CGPoint(x: 70, y: yPosition), withAttributes: [.font: bodyFont])
                yPosition += 40
                
                // Draw timecard details
                "Detailed Timecard Entries:".draw(at: CGPoint(x: 50, y: yPosition), withAttributes: [.font: subheaderFont])
                yPosition += 30
                
                // Draw table headers
                let columns: [(String, CGFloat)] = [
                    ("Date", 50),
                    ("Hours", 130),
                    ("Job Code", 200),
                    ("Status", 280),
                    ("Time", 360)
                ]
                
                for (header, x) in columns {
                    header.draw(at: CGPoint(x: x, y: yPosition), withAttributes: [.font: bodyFont])
                }
                yPosition += 20
                
                // Draw timecard entries
                for timecard in timecards.sorted(by: { $0.date > $1.date }) {
                    // Check if we need a new page
                    if yPosition > 700 {
                        context.beginPage()
                        yPosition = 50
                    }
                    
                    let statusColor: UIColor = {
                        switch timecard.status {
                        case .approved: return .systemGreen
                        case .rejected: return .systemRed
                        case .submitted: return .systemOrange
                        default: return .systemGray
                        }
                    }()
                    
                    // Draw timecard row
                    dateFormatter.string(from: timecard.date).draw(
                        at: CGPoint(x: columns[0].1, y: yPosition),
                        withAttributes: [.font: smallFont]
                    )
                    
                    String(format: "%.1f", timecard.totalHours).draw(
                        at: CGPoint(x: columns[1].1, y: yPosition),
                        withAttributes: [.font: smallFont]
                    )
                    
                    timecard.jobCode.draw(
                        at: CGPoint(x: columns[2].1, y: yPosition),
                        withAttributes: [.font: smallFont]
                    )
                    
                    timecard.status.rawValue.draw(
                        at: CGPoint(x: columns[3].1, y: yPosition),
                        withAttributes: [.font: smallFont, .foregroundColor: statusColor]
                    )
                    
                    "\(timeFormatter.string(from: timecard.startTime)) - \(timeFormatter.string(from: timecard.endTime))".draw(
                        at: CGPoint(x: columns[4].1, y: yPosition),
                        withAttributes: [.font: smallFont]
                    )
                    
                    yPosition += 20
                }
            }
        }
    }
    
    private func fetchTimecards(for employeeId: String, startDate: Date, endDate: Date) async throws -> [Timecard] {
        // First try with existing index
        do {
            // Use specific collection path query (not collection group)
            let snapshot = try await db.collection("timecards")  // Single collection path
                .whereField("userId", isEqualTo: employeeId)
                .whereField("date", isGreaterThanOrEqualTo: startDate)
                .whereField("date", isLessThanOrEqualTo: endDate)
                .order(by: "date", descending: true)
                .getDocuments()
            
            return snapshot.documents.compactMap { Timecard(document: $0) }
        } catch let error as NSError {
            if error.domain == "FIRFirestoreErrorDomain" && error.code == 9 {
                // Index error - provide guidance for single collection
                print("""
                    Please create the following index in Firebase:
                    Collection Scope: Single Collection
                    Collection: timecards
                    Fields to index:
                    - userId (Ascending)
                    - date (Ascending)
                    Query scope: Collection
                    """)
                
                // Fallback to simpler query and filter in memory
                let snapshot = try await db.collection("timecards")
                    .whereField("userId", isEqualTo: employeeId)
                    .getDocuments()
                
                return snapshot.documents
                    .compactMap { Timecard(document: $0) }
                    .filter { $0.date >= startDate && $0.date <= endDate }
            }
            throw error
        }
    }
}

