import SwiftUI

struct JobCodeDetailView: View {
    let jobCode: JobCode
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text(jobCode.description)
                .font(.title)
                .bold()
            
            Text("Code: \(jobCode.rawValue)")
                .font(.headline)
                .foregroundColor(.gray)
            
            Spacer()
        }
        .padding()
    }
}
