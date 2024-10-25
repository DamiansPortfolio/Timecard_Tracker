import SwiftUI

struct JobCodeDetailView: View {
    let jobCode: JobCode
    
    // Environment variable to dismiss the view
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack {
            // Close button (X)
            HStack {
                Spacer()
                Button(action: {
                    presentationMode.wrappedValue.dismiss() // Dismiss the modal
                }) {
                    Image(systemName: "xmark")
                        .bold()
                        .foregroundColor(.white)
                        .padding()
                }
            }
            
            // Job code name
            Text(jobCode.name)
                .font(.largeTitle)
                .foregroundColor(.white)
                .padding()
            
            // Job code description
            Text(jobCode.description)
                .font(.body)
                .foregroundColor(.white)
                .padding()
            
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.teal)
    }
}

struct JobCodeDetailView_Previews: PreviewProvider {
    static var previews: some View {
        JobCodeDetailView(jobCode: JobCode(id: UUID(), name: "Development", description: "Tasks related to software development."))
    }
}
