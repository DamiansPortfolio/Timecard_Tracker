import SwiftUI

struct TeamListView: View {
    let employees: [Profile]
    
    var body: some View {
        List(employees) { employee in
            VStack(alignment: .leading) {
                HStack {
                    Text("\(employee.fname) \(employee.lname)")
                        .font(.headline)
                    Spacer()
                    Text(employee.title)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                MemberInfoRow(icon: "mappin.and.ellipse", value: employee.location)
                MemberInfoRow(icon: "envelope.fill", value: employee.email)
                MemberInfoRow(icon: "phone.fill", value: employee.phone)

            }
        }
        .navigationTitle("Team Members")
    }
}

struct MemberInfoRow: View {
    var icon: String
    var value: String
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(.teal)
            Text(value)
        }
        .font(.subheadline)
    }
}
