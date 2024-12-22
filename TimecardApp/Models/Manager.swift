//
//  Manager.swift
//  TimecardApp
//
//  Created by Damian Rozycki on 11/17/24.
//
struct Manager: Identifiable {
    var id: String // This will be the manager_id
    var managedEmployees: [String] // Array of employee IDs they manage
}
