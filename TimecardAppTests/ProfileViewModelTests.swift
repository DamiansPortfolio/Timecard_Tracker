//
//  ProfileViewModelTests.swift
//  TimecardApp
//
//  Created by Damian Rozycki on 12/9/24.
//

import XCTest
@testable import TimecardApp

class ProfileViewModelTests: XCTestCase {
    var viewModel: ProfileViewModel!
    
    override func setUp() {
        super.setUp()
        // Clear UserDefaults before each test
        if let bundleID = Bundle.main.bundleIdentifier {
            UserDefaults.standard.removePersistentDomain(forName: bundleID)
        }
    }
    
    func testInitialStateWithoutUserId() {
        viewModel = ProfileViewModel()
        
        // Since there's no userId in UserDefaults, the viewModel should be in an error state
        XCTAssertEqual(viewModel.firstName, "")
        XCTAssertEqual(viewModel.lastName, "")
        XCTAssertEqual(viewModel.middleName, "")
        XCTAssertEqual(viewModel.title, "")
        XCTAssertEqual(viewModel.username, "")
        XCTAssertEqual(viewModel.email, "")
        XCTAssertEqual(viewModel.phone, "")
        XCTAssertEqual(viewModel.branch, "")
        XCTAssertEqual(viewModel.department, "")
        XCTAssertEqual(viewModel.location, "")
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertEqual(viewModel.errorMessage, "No user ID found")
        XCTAssertTrue(viewModel.isLoggedOut)
        XCTAssertFalse(viewModel.showPasswordError)
        XCTAssertFalse(viewModel.showPasswordSuccess)
        XCTAssertNil(viewModel.passwordErrorMessage)
    }
    
    func testInitialStateWithUserId() {
        // Setup UserDefaults with a userId before initializing viewModel
        UserDefaults.standard.set("test-user-id", forKey: "userId")
        viewModel = ProfileViewModel()
        
        // Even with a userId, initial properties should be empty until Firebase fetch completes
        XCTAssertEqual(viewModel.firstName, "")
        XCTAssertEqual(viewModel.lastName, "")
        XCTAssertEqual(viewModel.middleName, "")
        XCTAssertEqual(viewModel.title, "")
        XCTAssertEqual(viewModel.username, "")
        XCTAssertEqual(viewModel.email, "")
        XCTAssertEqual(viewModel.phone, "")
        XCTAssertEqual(viewModel.branch, "")
        XCTAssertEqual(viewModel.department, "")
        XCTAssertEqual(viewModel.location, "")
        XCTAssertTrue(viewModel.isLoading) // Should be loading since fetch was triggered
        XCTAssertNil(viewModel.errorMessage)
        XCTAssertFalse(viewModel.isLoggedOut)
    }
    
    func testLogOut() {
        // Setup initial UserDefaults values
        UserDefaults.standard.set("test@example.com", forKey: "userEmail")
        UserDefaults.standard.set("John", forKey: "userName")
        UserDefaults.standard.set("123", forKey: "userId")
        UserDefaults.standard.set(true, forKey: "isManager")
        
        viewModel = ProfileViewModel()
        
        // Set some values in the view model
        viewModel.firstName = "John"
        viewModel.lastName = "Doe"
        viewModel.email = "test@example.com"
        
        // Perform logout
        viewModel.logOut()
        
        // Verify UserDefaults are cleared
        XCTAssertNil(UserDefaults.standard.string(forKey: "userEmail"))
        XCTAssertNil(UserDefaults.standard.string(forKey: "userName"))
        XCTAssertNil(UserDefaults.standard.string(forKey: "userId"))
        XCTAssertNil(UserDefaults.standard.object(forKey: "isManager"))
        
        // Verify view model state is cleared
        XCTAssertEqual(viewModel.firstName, "")
        XCTAssertEqual(viewModel.lastName, "")
        XCTAssertEqual(viewModel.middleName, "")
        XCTAssertEqual(viewModel.title, "")
        XCTAssertEqual(viewModel.username, "")
        XCTAssertEqual(viewModel.email, "")
        XCTAssertEqual(viewModel.phone, "")
        XCTAssertEqual(viewModel.branch, "")
        XCTAssertEqual(viewModel.department, "")
        XCTAssertEqual(viewModel.location, "")
        
    }
    
    func testUpdatePasswordValidation() {
        viewModel = ProfileViewModel()
        
        // Test with no userId in UserDefaults
        viewModel.updatePassword(currentPassword: "oldpass", newPassword: "newpass")
        XCTAssertTrue(viewModel.showPasswordError)
        XCTAssertEqual(viewModel.passwordErrorMessage, "No user ID found")
    }
    
    func testUpdateProfileValidation() {
        viewModel = ProfileViewModel()
        
        // Test with no userId in UserDefaults
        viewModel.updateProfile(
            firstName: "John",
            lastName: "Doe",
            phone: "123-456-7890",
            title: "Developer",
            branch: "Engineering",
            department: "Software",
            location: "NY"
        )
        
        XCTAssertEqual(viewModel.errorMessage, "No user ID found")
    }
    
    func testClearUserData() {
        viewModel = ProfileViewModel()
        
        // Set some initial values
        viewModel.firstName = "John"
        viewModel.lastName = "Doe"
        viewModel.email = "test@example.com"
        viewModel.phone = "123-456-7890"
        
        // Trigger clear through logout
        viewModel.logOut()
        
        // Verify all fields are cleared
        XCTAssertEqual(viewModel.firstName, "")
        XCTAssertEqual(viewModel.lastName, "")
        XCTAssertEqual(viewModel.middleName, "")
        XCTAssertEqual(viewModel.email, "")
        XCTAssertEqual(viewModel.phone, "")
        XCTAssertEqual(viewModel.title, "")
        XCTAssertEqual(viewModel.branch, "")
        XCTAssertEqual(viewModel.department, "")
        XCTAssertEqual(viewModel.location, "")
    }
}
