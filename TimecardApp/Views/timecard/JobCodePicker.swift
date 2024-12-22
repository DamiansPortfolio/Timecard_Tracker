import SwiftUI

struct JobCodePicker: View {
    @Binding var selectedJobCode: JobCode
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            List {
                ForEach(JobCode.allCases, id: \.self) { jobCode in
                    Button(action: {
                        selectedJobCode = jobCode
                        dismiss()
                    }) {
                        HStack {
                            VStack(alignment: .leading) {
                                Text(jobCode.rawValue)
                                    .font(.headline)
                                Text(jobCode.description)
                                    .font(.subheadline)
                                    .foregroundColor(.black)
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
            .navigationTitle("Select Job Code")
            .toolbar {
                Button("Done") {
                    dismiss()
                }
                .bold()
            }
        }
    }
}
