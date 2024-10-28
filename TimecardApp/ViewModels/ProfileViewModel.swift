//
//  ProfileViewModel.swift
//  TimecardApp
//
//  Created by Anh Phan on 10/26/24.
//


import SwiftUI
import Combine

class ProfileViewModel: ObservableObject {
    @Published var username: String = "Damian Rozycki"
    @Published var email: String = "damian@example.com"
    @Published var latestPay: Double = 1500.00 // Example pay amount
    @Published var title: String = "Software Developer"
    @Published var branch: String = "Main Branch"
    @Published var department: String = "Engineering"
}
