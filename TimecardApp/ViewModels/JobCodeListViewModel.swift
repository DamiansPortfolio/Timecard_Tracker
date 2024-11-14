import SwiftUI

class JobCodeListViewModel: ObservableObject {
    @Published var jobCodes: [JobCode] = JobCode.allCases.map { $0 }
    @Published var filteredJobCodes: [JobCode] = JobCode.allCases.map { $0 }
    @Published var selectedJobCode: JobCode?
    
    func filterByText(_ text: String?) {
        if let text = text, !text.isEmpty {
            filteredJobCodes = jobCodes.filter { jobCode in
                jobCode.description.localizedCaseInsensitiveContains(text) ||
                jobCode.rawValue.localizedCaseInsensitiveContains(text)
            }
        } else {
            filteredJobCodes = jobCodes
        }
    }
    
    func sortAlphabetically() {
        filteredJobCodes.sort { $0.description < $1.description }
    }
}
