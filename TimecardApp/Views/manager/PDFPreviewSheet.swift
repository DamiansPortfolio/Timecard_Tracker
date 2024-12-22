//
//  PDFPreviewSheet.swift
//  TimecardApp
//
//  Created by Anh Phan on 12/9/24.
//



import SwiftUI
import PDFKit

struct PDFPreviewSheet: View {
    let pdfData: Data
    @Binding var showingPreview: Bool
    @Binding var showingShareSheet: Bool

    var body: some View {
        NavigationView {
            VStack {
                PDFPreviewView(data: pdfData)
                    .edgesIgnoringSafeArea(.all)
            }
            .navigationTitle("PDF Preview")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem (placement: .topBarLeading) {
                    Button(action: {
                        showingPreview = false
                        showingShareSheet = true
                    }) {
                        Image(systemName: "square.and.arrow.up")
                    }
                }
                ToolbarItem (placement: .topBarTrailing) {
                    Button(action: { showingPreview = false }) {
                        Image(systemName: "xmark")
                    }
                }
            }
        }
    }
}


struct PDFPreviewView: UIViewRepresentable {
    let data: Data
    
    func makeUIView(context: Context) -> PDFView {
        let pdfView = PDFView()
        pdfView.autoScales = true
        
        // Create and set the PDF document
        if let document = PDFDocument(data: data) {
            pdfView.document = document
        }
        
        return pdfView
    }
    
    func updateUIView(_ pdfView: PDFView, context: Context) {
        if let document = PDFDocument(data: data) {
            pdfView.document = document
        }
    }
}
