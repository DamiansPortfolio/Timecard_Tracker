//
//  JobCodeListView.swift
//  TimecardApp
//
//  Created by Damian Rozycki on 10/4/24.
//

import SwiftUI

struct JobCodeListView: View {
    @StateObject private var viewModel = JobCodeListViewModel()
    
    var body: some View {
        NavigationView {
            List(viewModel.jobCodes) { jobCode in
                Text(jobCode.name)
            }
            .navigationTitle("Job Codes")
            .toolbar {
                Button(action: {
                    // Add new job code action
                }) {
                    Image(systemName: "plus")
                }
            }
        }
    }
}

struct JobCodeListView_Previews: PreviewProvider {
    static var previews: some View {
        JobCodeListView()
    }
}
