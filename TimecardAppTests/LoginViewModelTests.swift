//
//  LoginViewModelTests.swift
//  TimecardApp
//
//  Created by Damian Rozycki on 12/9/24.
//


import XCTest
@testable import TimecardApp

class LoginViewModelTests: XCTestCase {
    var viewModel: LoginViewModel!
    
    override func setUp() {
        super.setUp()
        viewModel = LoginViewModel()
    }
    
    func testInitialState() {
        // Test initial state of all published properties
        XCTAssertEqual(viewModel.email, "")
        XCTAssertEqual(viewModel.password, "")
        XCTAssertFalse(viewModel.showPassword)
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertEqual(viewModel.errorMessage, "")
        XCTAssertFalse(viewModel.isAuthenticated)
    }
    
    func testLoginValidation() {
        // Test with empty email and password
        viewModel.login()
        XCTAssertEqual(viewModel.errorMessage, "Please enter both email and password")
        
        // Test with only email
        viewModel.email = "test@example.com"
        viewModel.password = ""
        viewModel.login()
        XCTAssertEqual(viewModel.errorMessage, "Please enter both email and password")
        
        // Test with only password
        viewModel.email = ""
        viewModel.password = "password123"
        viewModel.login()
        XCTAssertEqual(viewModel.errorMessage, "Please enter both email and password")
    }
    
    func testIsLoginDisabled() {
        // Should be disabled initially
        XCTAssertTrue(viewModel.isLoginDisabled)
        
        // Should be disabled with only email
        viewModel.email = "test@example.com"
        XCTAssertTrue(viewModel.isLoginDisabled)
        
        // Should be disabled with only password
        viewModel.email = ""
        viewModel.password = "password123"
        XCTAssertTrue(viewModel.isLoginDisabled)
        
        // Should be enabled with both email and password
        viewModel.email = "test@example.com"
        viewModel.password = "password123"
        XCTAssertFalse(viewModel.isLoginDisabled)
        
        // Should be disabled when loading
        viewModel.isLoading = true
        XCTAssertTrue(viewModel.isLoginDisabled)
    }
    
    func testShowPasswordToggle() {
        // Test toggle password visibility
        XCTAssertFalse(viewModel.showPassword)
        viewModel.showPassword.toggle()
        XCTAssertTrue(viewModel.showPassword)
        viewModel.showPassword.toggle()
        XCTAssertFalse(viewModel.showPassword)
    }
}
