import SwiftUI

struct AddTimecardView: View {
    @Environment(\.dismiss) var dismiss
    @State private var date = Date()
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Select Date")) {
                    DatePicker("Date", selection: $date, displayedComponents: .date)
                        .datePickerStyle(GraphicalDatePickerStyle()) // Optional: Graphical style for calendar view
                }
            }
            .navigationTitle("Add Timecard")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
}
