import SwiftUI

struct JobCodePicker: View {
    @Binding var selectedJobCode: JobCode
    
    var body: some View {
        List {
            ForEach(JobCode.allCases, id: \.self) { jobCode in
                Button(action: {
                    selectedJobCode = jobCode
                }) {
                    HStack {
                        VStack(alignment: .leading) {
                            Text(jobCode.rawValue)
                                .font(.headline)
                            Text(jobCode.description)
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                        Spacer()
                        if selectedJobCode == jobCode {
                            Image(systemName: "checkmark")
                                .foregroundColor(.teal)
                        }
                    }
                }
            }
        }
    }
}
