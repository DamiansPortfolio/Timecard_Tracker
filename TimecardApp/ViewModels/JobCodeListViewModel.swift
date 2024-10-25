import SwiftUI

class JobCodeListViewModel: ObservableObject {
    @Published var jobCodes: [JobCode] = []
    @Published var filteredJobCodes: [JobCode] = []
    @Published var selectedJobCode: JobCode? // Track the selected job code
    
    init() {
        fetchJobCodes()
        filteredJobCodes = jobCodes // Initially, show all job codes
    }
    
    func fetchJobCodes() {
        // TODO: Replace with actual API call or data fetching logic
        jobCodes = [
            JobCode(id: UUID(), name: "Development", description: "Tasks related to software development."),
            JobCode(id: UUID(), name: "Design", description: "Tasks related to graphic design and UI/UX."),
            JobCode(id: UUID(), name: "Testing", description: "Tasks related to quality assurance and testing."),
            JobCode(id: UUID(), name: "Project Management", description: "Tasks related to managing projects."),
            JobCode(id: UUID(), name: "Research", description: "Tasks related to research and analysis."),
            // Add more JobCode entries as needed
        ]
        filteredJobCodes = jobCodes // Reset filtered job codes when fetched
    }
    
    func filterByText(_ text: String?) {
        if let text = text, !text.isEmpty {
            // Filter job codes based on the search text (case insensitive)
            filteredJobCodes = jobCodes.filter { jobCode in
                jobCode.name.localizedCaseInsensitiveContains(text) ||
                jobCode.description.localizedCaseInsensitiveContains(text)
            }
        } else {
            // If no text, reset to show all job codes
            filteredJobCodes = jobCodes
        }
    }
    
    func sortAlphabetically() {
        // Sort filtered job codes alphabetically by name
        filteredJobCodes.sort { $0.name < $1.name }
    }
}
