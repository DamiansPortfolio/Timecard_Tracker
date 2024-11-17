import Foundation

struct Profile: Identifiable {
    var id: String { username } // Use `username` as the unique identifier
    var username: String
    var password: String
    var fname: String
    var lname: String
    var mname: String?
    var email: String
    var phone: String
    var title: String
    var branch: String
    var department: String
    var location: String
}

enum EditingSection {
    case information, workDetails, none
}
