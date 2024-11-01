//
//  DocumentsView.swift
//  TimecardApp
//
//  Created by Anh Phan on 11/1/24.
//

import SwiftUI

struct DocumentsView: View {
    var body: some View {
        VStack {
            Text("Documents")
                .font(.largeTitle)
                .bold()
                .foregroundColor(.teal)
                .padding()
            
            // List of documents with icons
            List {
                DocumentRow(documentName: "Tax Forms")
                DocumentRow(documentName: "Pay Stubs")
                DocumentRow(documentName: "Employee Handbook")
            }
        }
    }
}

struct DocumentRow: View {
    var documentName: String
    
    var body: some View {
        HStack {
            Image(systemName: "doc.text")
                .foregroundColor(.teal)
            Text(documentName)
                .foregroundColor(.black)
        }
    }
}
