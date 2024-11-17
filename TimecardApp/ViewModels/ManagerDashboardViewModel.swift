import Foundation
import FirebaseFirestore

class ManagerDashboardViewModel: ObservableObject {
    @Published var employees: [Profile] = []
    
    private let db = Firestore.firestore()

    func fetchManagedEmployees(for managerId: String) {
        db.collection("employees") // Assuming your collection is named "employees"
            .whereField("managerId", isEqualTo: managerId) // Assuming each employee has a "managerId" field
            .getDocuments { [weak self] (querySnapshot, error) in
                if let error = error {
                    print("Error fetching managed employees: \(error)")
                    return
                }
                
                guard let documents = querySnapshot?.documents else {
                    print("No managed employees found.")
                    return
                }
                
                self?.employees = documents.compactMap { document in
                    let data = document.data()
                    return Profile(
                        username: data["username"] as? String ?? "",
                        password: data["password"] as? String ?? "",
                        fname: data["fname"] as? String ?? "",
                        lname: data["lname"] as? String ?? "",
                        mname: data["mname"] as? String,
                        email: data["email"] as? String ?? "",
                        phone: data["phone"] as? String ?? "",
                        title: data["title"] as? String ?? "",
                        branch: data["branch"] as? String ?? "",
                        department: data["department"] as? String ?? "",
                        location: data["location"] as? String ?? ""
                    )
                }
            }
    }
}
