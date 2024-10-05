//
//  JobCodeListViewModel.swift
//  TimecardApp
//
//  Created by Damian Rozycki on 10/4/24.
//

import Foundation

class JobCodeListViewModel: ObservableObject {
    @Published var jobCodes: [JobCode] = []
    
    init() {
        fetchJobCodes()
    }
    
    func fetchJobCodes() {
        // TODO: Replace with actual API call
        jobCodes = [
            JobCode(id: UUID(), name: "Development"),
            JobCode(id: UUID(), name: "Design"),
            JobCode(id: UUID(), name: "Testing")
        ]
    }
}

struct JobCode: Identifiable {
    let id: UUID
    let name: String
}
