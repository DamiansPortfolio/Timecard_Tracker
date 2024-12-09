import SwiftUI
import PDFKit
import FirebaseFirestore

@MainActor
class TimecardReportViewModel: ObservableObject {
    @Published var isGenerating: Bool = false
    @Published var errorMessage: String?
    
    private let db = Firestore.firestore()
    
    func generateReport(for employees: [Profile], startDate: Date, endDate: Date) async throws -> Data {
        await MainActor.run {
            isGenerating = true
            errorMessage = nil
        }
        
        defer {
            Task { @MainActor in
                isGenerating = false
            }
        }
        
        // Fetch timecards for all employees
        var employeeTimecards: [(Profile, [Timecard])] = []
        
        // Use Calendar for date comparisons
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: startDate)
        let endOfDay = calendar.date(bySettingHour: 23, minute: 59, second: 59, of: endDate) ?? endDate
        
        // Fetch all timecards concurrently
        try await withThrowingTaskGroup(of: (Profile, [Timecard]).self) { group in
            for employee in employees {
                group.addTask {
                    let timecards = try await self.fetchTimecards(
                        for: employee.username,
                        startDate: startOfDay,
                        endDate: endOfDay
                    )
                    return (employee, timecards)
                }
            }
            
            for try await result in group {
                employeeTimecards.append(result)
            }
        }
        
        // Sort employees by last name
        employeeTimecards.sort { $0.0.lname < $1.0.lname }
        
        // Create PDF
        let pdfMetaData = [
            kCGPDFContextCreator: "Timecard Management System",
            kCGPDFContextAuthor: "Manager Report",
            kCGPDFContextTitle: "Employee Timecard Report"
        ]
        
        let format = UIGraphicsPDFRendererFormat()
        format.documentInfo = pdfMetaData as [String: Any]
        
        let pageRect = CGRect(x: 0, y: 0, width: 612, height: 792)
        let renderer = UIGraphicsPDFRenderer(bounds: pageRect, format: format)
        
        return renderer.pdfData { context in
            // Formatters
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium
            
            let timeFormatter = DateFormatter()
            timeFormatter.timeStyle = .short
            
            // Fonts
            let titleFont = UIFont.boldSystemFont(ofSize: 20)
            let headerFont = UIFont.boldSystemFont(ofSize: 16)
            let subheaderFont = UIFont.boldSystemFont(ofSize: 14)
            let bodyFont = UIFont.systemFont(ofSize: 12)
            let smallFont = UIFont.systemFont(ofSize: 10)
            
            // Draw cover page
            drawCoverPage(
                context: context,
                employeeTimecards: employeeTimecards,
                startDate: startDate,
                endDate: endDate,
                dateFormatter: dateFormatter,
                fonts: (titleFont, headerFont, subheaderFont, bodyFont)
            )
            
            // Draw employee pages
            for (employee, timecards) in employeeTimecards {
                drawEmployeePage(
                    context: context,
                    employee: employee,
                    timecards: timecards.sorted(by: { $0.date > $1.date }),
                    dateFormatter: dateFormatter,
                    timeFormatter: timeFormatter,
                    fonts: (headerFont, subheaderFont, bodyFont, smallFont)
                )
            }
        }
    }
    
    private func drawCoverPage(
        context: UIGraphicsPDFRendererContext,
        employeeTimecards: [(Profile, [Timecard])],
        startDate: Date,
        endDate: Date,
        dateFormatter: DateFormatter,
        fonts: (title: UIFont, header: UIFont, subheader: UIFont, body: UIFont)
    ) {
        context.beginPage()
        
        // Title
        let title = "Timecard Summary Report"
        let dateRange = "\(dateFormatter.string(from: startDate)) - \(dateFormatter.string(from: endDate))"
        
        title.draw(at: CGPoint(x: 50, y: 50), withAttributes: [.font: fonts.title])
        dateRange.draw(at: CGPoint(x: 50, y: 80), withAttributes: [.font: fonts.header])
        
        // Summary
        var yPos: CGFloat = 120
        let totalEmployees = employeeTimecards.count
        let totalTimecards = employeeTimecards.reduce(0) { $0 + $1.1.count }
        let totalHours = employeeTimecards.reduce(0.0) { sum, pair in
            sum + pair.1.reduce(0.0) { $0 + $1.totalHours }
        }
        
        "Report Summary:".draw(
            at: CGPoint(x: 50, y: yPos),
            withAttributes: [.font: fonts.subheader]
        )
        yPos += 25
        
        let summaryTexts = [
            "Total Employees: \(totalEmployees)",
            "Total Timecards: \(totalTimecards)",
            String(format: "Total Hours: %.1f", totalHours)
        ]
        
        for text in summaryTexts {
            text.draw(
                at: CGPoint(x: 70, y: yPos),
                withAttributes: [.font: fonts.body]
            )
            yPos += 20
        }
    }
    
    private func drawEmployeePage(
        context: UIGraphicsPDFRendererContext,
        employee: Profile,
        timecards: [Timecard],
        dateFormatter: DateFormatter,
        timeFormatter: DateFormatter,
        fonts: (header: UIFont, subheader: UIFont, body: UIFont, small: UIFont)
    ) {
        context.beginPage()
        var yPos: CGFloat = 50
        
        // Employee header
        "\(employee.fname) \(employee.lname)".draw(
            at: CGPoint(x: 50, y: yPos),
            withAttributes: [.font: fonts.header]
        )
        yPos += 25
        
        // Employee details
        for detail in [
            "Title: \(employee.title)",
            "Department: \(employee.department)",
            "Email: \(employee.email)"
        ] {
            detail.draw(
                at: CGPoint(x: 50, y: yPos),
                withAttributes: [.font: fonts.body]
            )
            yPos += 20
        }
        yPos += 10
        
        // Timecard summary
        let approved = timecards.filter { $0.status == .approved }
        let rejected = timecards.filter { $0.status == .rejected }
        let pending = timecards.filter { $0.status == .submitted }
        let totalHours = timecards.reduce(0.0) { $0 + $1.totalHours }
        
        "Timecard Summary:".draw(
            at: CGPoint(x: 50, y: yPos),
            withAttributes: [.font: fonts.subheader]
        )
        yPos += 25
        
        for (text, count) in [
            ("Total Hours", String(format: "%.1f", totalHours)),
            ("Approved Timecards", "\(approved.count)"),
            ("Rejected Timecards", "\(rejected.count)"),
            ("Pending Timecards", "\(pending.count)")
        ] {
            "\(text): \(count)".draw(
                at: CGPoint(x: 70, y: yPos),
                withAttributes: [.font: fonts.body]
            )
            yPos += 20
        }
        yPos += 20
        
        // Table
        drawTimecardTable(
            context: context,
            timecards: timecards,
            startY: &yPos,
            dateFormatter: dateFormatter,
            timeFormatter: timeFormatter,
            fonts: fonts
        )
    }
    
    private func drawTimecardTable(
        context: UIGraphicsPDFRendererContext,
        timecards: [Timecard],
        startY: inout CGFloat,
        dateFormatter: DateFormatter,
        timeFormatter: DateFormatter,
        fonts: (header: UIFont, subheader: UIFont, body: UIFont, small: UIFont)
    ) {
        let columns = [
            ("Date", 50),
            ("Hours", 130),
            ("Job Code", 200),
            ("Status", 280),
            ("Time", 360)
        ]
        
        "Timecard Details:".draw(
            at: CGPoint(x: 50, y: startY),
            withAttributes: [.font: fonts.subheader]
        )
        startY += 25
        
        // Headers
        for (header, x) in columns {
            header.draw(
                at: CGPoint(x: CGFloat(x), y: startY),
                withAttributes: [.font: fonts.body]
            )
        }
        startY += 20
        
        // Rows
        for timecard in timecards {
            if startY > 700 {
                context.beginPage()
                startY = 50
            }
            
            let statusColor: UIColor = {
                switch timecard.status {
                case .approved: return .systemGreen
                case .rejected: return .systemRed
                case .submitted: return .systemOrange
                default: return .systemGray
                }
            }()
            
            // Draw row data
            dateFormatter.string(from: timecard.date).draw(
                at: CGPoint(x: CGFloat(columns[0].1), y: startY),
                withAttributes: [.font: fonts.small]
            )
            
            String(format: "%.1f", timecard.totalHours).draw(
                at: CGPoint(x: CGFloat(columns[1].1), y: startY),
                withAttributes: [.font: fonts.small]
            )
            
            timecard.jobCode.draw(
                at: CGPoint(x: CGFloat(columns[2].1), y: startY),
                withAttributes: [.font: fonts.small]
            )
            
            timecard.status.rawValue.draw(
                at: CGPoint(x: CGFloat(columns[3].1), y: startY),
                withAttributes: [.font: fonts.small, .foregroundColor: statusColor]
            )
            
            let timeString = "\(timeFormatter.string(from: timecard.startTime)) - \(timeFormatter.string(from: timecard.endTime))"
            timeString.draw(
                at: CGPoint(x: CGFloat(columns[4].1), y: startY),
                withAttributes: [.font: fonts.small]
            )
            
            startY += 20
        }
    }
    
    private func fetchTimecards(for employeeId: String, startDate: Date, endDate: Date) async throws -> [Timecard] {
        do {
            let snapshot = try await db.collection("timecards")
                .whereField("userId", isEqualTo: employeeId)
                .whereField("date", isGreaterThanOrEqualTo: startDate)
                .whereField("date", isLessThanOrEqualTo: endDate)
                .order(by: "date", descending: true)
                .getDocuments()
            
            return snapshot.documents.compactMap { Timecard(document: $0) }
        } catch let error as NSError {
            if error.domain == "FIRFirestoreErrorDomain" && error.code == 9 {
                print("""
                    Please create the following index in Firebase:
                    Collection Scope: Single Collection
                    Collection: timecards
                    Fields to index:
                    - userId (Ascending)
                    - date (Ascending)
                    Query scope: Collection
                    """)
                
                // Fallback to simpler query
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
