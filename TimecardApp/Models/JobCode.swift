//
//  JobCode.swift
//  TimecardApp
//
//  Created by Anh Phan on 10/24/24.
//
enum JobCode: String, CaseIterable, Identifiable {
    case development = "DEV"
    case testing = "QA"
    case meetings = "MTG"
    case training = "TRN"
    case documentation = "DOC"
    case support = "SUP"
    
    var id: String { self.rawValue } // For Identifiable conformance
    
    var name: String { self.description } // Add name property to match the view's usage
    
    var description: String {
        switch self {
        case .development: return "Software Development"
        case .testing: return "Quality Assurance"
        case .meetings: return "Meetings"
        case .training: return "Training"
        case .documentation: return "Documentation"
        case .support: return "Customer Support"
        }
    }
}
