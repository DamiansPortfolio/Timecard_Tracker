//
//  JobCodePicker.swift
//  TimecardApp
//
//  Created by Damian Rozycki on 11/14/24.
//
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
                            Text(jobCode.description)
                                .font(.headline)
                            Text(jobCode.rawValue)
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                        Spacer()
                        if selectedJobCode == jobCode {
                            Image(systemName: "checkmark")
                                .foregroundColor(.blue)
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    JobCodePicker(selectedJobCode: .constant(.development))
}
