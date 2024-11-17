
import SwiftUI
struct ManagerDashboardView: View {
    @StateObject private var viewModel = ManagerDashboardViewModel()
    private let managerId = "manager123" // Replace with actual manager ID logic

    var body: some View {
        NavigationView {
            List(viewModel.employees) { employee in
                NavigationLink(destination: EmployeeDetailView(employee: employee)) {
                    VStack(alignment: .leading) {
                        Text("\(employee.fname) \(employee.lname)")
                            .font(.headline)
                        Text(employee.title)
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                }
            }
            .navigationTitle("Manage Employees")
        }
        .onAppear {
            viewModel.fetchManagedEmployees(for: managerId)
        }
    }
}
