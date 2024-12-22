//
//  BasicModelTests.swift
//  TimecardAppTests
//
//  Created by Damian Rozycki on 12/9/24.
//

import XCTest
@testable import TimecardApp

final class BasicModelTests: XCTestCase {
    
    func testProfileInitialization() {
        // Given
        let username = "jdoe"
        let password = "securepass123"
        let fname = "John"
        let lname = "Doe"
        let email = "john.doe@example.com"
        let phone = "123-456-7890"
        let title = "Developer"
        let branch = "Engineering"
        let department = "Software"
        let location = "New York"
        let isManager = false
        
        // When
        let profile = Profile(
            username: username,
            password: password,
            fname: fname,
            lname: lname,
            mname: nil,
            email: email,
            phone: phone,
            title: title,
            branch: branch,
            department: department,
            location: location,
            isManager: isManager
        )
        
        // Then
        XCTAssertEqual(profile.username, username)
        XCTAssertEqual(profile.password, password)
        XCTAssertEqual(profile.fname, fname)
        XCTAssertEqual(profile.lname, lname)
        XCTAssertNil(profile.mname)
        XCTAssertEqual(profile.email, email)
        XCTAssertEqual(profile.phone, phone)
        XCTAssertEqual(profile.title, title)
        XCTAssertEqual(profile.branch, branch)
        XCTAssertEqual(profile.department, department)
        XCTAssertEqual(profile.location, location)
        XCTAssertFalse(profile.isManager)
        XCTAssertEqual(profile.id, profile.username)
    }
    
    func testTimecardInitialization() {
        // Given
        let now = Date()
        let startTime = now.addingTimeInterval(-3600) // 1 hour ago
        let endTime = now
        
        // When
        let timecard = Timecard(
            id: "test-id",
            userId: "user123",
            employeeId: "emp456",
            firstName: "John",
            lastName: "Doe",
            date: now,
            totalHours: 1.0,
            status: .draft,
            jobCode: "DEV101",
            startTime: startTime,
            endTime: endTime,
            breakDuration: 0.0
        )
        
        // Then
        XCTAssertEqual(timecard.id, "test-id")
        XCTAssertEqual(timecard.userId, "user123")
        XCTAssertEqual(timecard.employeeId, "emp456")
        XCTAssertEqual(timecard.firstName, "John")
        XCTAssertEqual(timecard.lastName, "Doe")
        XCTAssertEqual(timecard.date, now)
        XCTAssertEqual(timecard.totalHours, 1.0)
        XCTAssertEqual(timecard.status, .draft)
        XCTAssertEqual(timecard.jobCode, "DEV101")
        XCTAssertEqual(timecard.startTime, startTime)
        XCTAssertEqual(timecard.endTime, endTime)
        XCTAssertEqual(timecard.breakDuration, 0.0)
    }
    
    func testJobCodeEnum() {
        // Test raw values
        XCTAssertEqual(JobCode.development.rawValue, "DEV")
        XCTAssertEqual(JobCode.testing.rawValue, "QA")
        XCTAssertEqual(JobCode.meetings.rawValue, "MTG")
        XCTAssertEqual(JobCode.training.rawValue, "TRN")
        XCTAssertEqual(JobCode.documentation.rawValue, "DOC")
        XCTAssertEqual(JobCode.support.rawValue, "SUP")
        
        // Test descriptions
        XCTAssertEqual(JobCode.development.description, "Software Development")
        XCTAssertEqual(JobCode.testing.description, "Quality Assurance")
        XCTAssertEqual(JobCode.meetings.description, "Meetings")
        XCTAssertEqual(JobCode.training.description, "Training")
        XCTAssertEqual(JobCode.documentation.description, "Documentation")
        XCTAssertEqual(JobCode.support.description, "Customer Support")
        
        // Test name property matches description
        XCTAssertEqual(JobCode.development.name, JobCode.development.description)
        XCTAssertEqual(JobCode.testing.name, JobCode.testing.description)
        
        // Test Identifiable conformance
        XCTAssertEqual(JobCode.development.id, "DEV")
        XCTAssertEqual(JobCode.testing.id, "QA")
        
        // Test CaseIterable
        let allCases = JobCode.allCases
        XCTAssertEqual(allCases.count, 6)
        XCTAssertTrue(allCases.contains(.development))
        XCTAssertTrue(allCases.contains(.testing))
        XCTAssertTrue(allCases.contains(.meetings))
        XCTAssertTrue(allCases.contains(.training))
        XCTAssertTrue(allCases.contains(.documentation))
        XCTAssertTrue(allCases.contains(.support))
    }
    
    func testTimecardStatusEnum() {
        // Test all possible status values
        XCTAssertEqual(TimecardStatus.draft.rawValue, "draft")
        XCTAssertEqual(TimecardStatus.submitted.rawValue, "submitted")
        XCTAssertEqual(TimecardStatus.approved.rawValue, "approved")
        XCTAssertEqual(TimecardStatus.rejected.rawValue, "rejected")
        
        // Test initialization from raw values
        XCTAssertEqual(TimecardStatus(rawValue: "draft"), .draft)
        XCTAssertEqual(TimecardStatus(rawValue: "submitted"), .submitted)
        XCTAssertEqual(TimecardStatus(rawValue: "approved"), .approved)
        XCTAssertEqual(TimecardStatus(rawValue: "rejected"), .rejected)
        
        // Test invalid raw value
        XCTAssertNil(TimecardStatus(rawValue: "invalid"))
    }
}
