//import SwiftUI
//
//struct ManagerDashboardView: View {
//    @StateObject private var viewModel = ManagerViewModel()
//    
//    var body: some View {
//        NavigationView {
//            ScrollView {
//                RefreshControl(coordinateSpace: .named("refresh")) {
//                    if let userId = UserDefaults.standard.string(forKey: "userId") {
//                        viewModel.fetchManagerData(managerId: userId)
//                    }
//                }
//                
//                VStack(spacing: 20) {
//                        // Quick Stats Cards
//                    HStack(spacing: 8) {
//                        QuickStatCard(
//                            title: "Team Size",
//                            value: "\(viewModel.managedEmployees.count)",
//                            systemImage: "person.2.fill",
//                            color: .blue
//                        )
//                        
//                        QuickStatCard(
//                            title: "Pending",
//                            value: "0",
//                            systemImage: "clock.fill",
//                            color: .orange
//                        )
//                        
//                        
//                        QuickStatCard(
//                            title: "This Week",
//                            value: String(format: "%.1fh", viewModel.weeklyHours),
//                            systemImage: "chart.bar.fill",
//                            color: .green
//                        )
//                    }
//                    .padding(.horizontal)
//                    
//                        // Quick Actions
//                    VStack(alignment: .leading, spacing: 0) {
//                        Text("Quick Actions")
//                            .font(.headline)
//                            .padding()
//                        
//                        Divider()
//                        
//                        NavigationLink(destination: TeamListView(employees: viewModel.managedEmployees)) {
//                            QuickActionRow(
//                                title: "View Team",
//                                subtitle: "Manage your employees",
//                                systemImage: "person.2.fill",
//                                trailing: "\(viewModel.managedEmployees.count) Members"
//                            )
//                        }
//                        
//                        Divider()
//                        
//                        NavigationLink(destination: PendingApprovalsView()) {
//                            QuickActionRow(
//                                title: "Pending Approvals",
//                                subtitle: "Review timecards",
//                                systemImage: "clock.fill",
//                                badge: "0"
//                            )
//                        }
//                    }
//                    .background(Color(.systemBackground))
//                    .cornerRadius(15)
//                    .shadow(radius: 2)
//                    .padding(.horizontal)
//                    
//                        // Recent Activity
//                    VStack(alignment: .leading, spacing: 0) {
//                        Text("Recent Activity")
//                            .font(.headline)
//                            .padding()
//                        
//                        Divider()
//                        
//                        ForEach(0..<3) { _ in
//                            RecentActivityRow()
//                            Divider()
//                        }
//                    }
//                    .background(Color(.systemBackground))
//                    .cornerRadius(15)
//                    .shadow(radius: 2)
//                    .padding(.horizontal)
//                }
//                .padding(.top)
//            }
//            .coordinateSpace(name: "refresh")
//            .navigationTitle("Dashboard")
//            .background(Color(.systemGroupedBackground))
//            .overlay {
//                if viewModel.isLoading {
//                    ProgressView()
//                        .scaleEffect(1.5)
//                        .frame(maxWidth: .infinity, maxHeight: .infinity)
//                        .background(Color.black.opacity(0.1))
//                }
//            }
//        }
//        .onAppear {
//            if let userId = UserDefaults.standard.string(forKey: "userId") {
//                viewModel.fetchManagerData(managerId: userId)
//            }
//        }
//    }
//}
//
//    // RefreshControl Component
//struct RefreshControl: View {
//    var coordinateSpace: CoordinateSpace
//    var onRefresh: () -> Void
//    
//    @State private var refresh: Bool = false
//    @State private var frozen: Bool = false
//    
//    var body: some View {
//        GeometryReader { geo in
//            if geo.frame(in: coordinateSpace).midY > 50 {
//                Spacer()
//                    .onAppear {
//                        if !refresh {
//                            refresh = true
//                        }
//                    }
//            } else if geo.frame(in: coordinateSpace).maxY < 1 {
//                Spacer()
//                    .onAppear {
//                        if refresh {
//                            refresh = false
//                            frozen = false
//                        }
//                    }
//            }
//            
//            if refresh && !frozen {
//                Spacer()
//                    .onAppear {
//                        frozen = true
//                        onRefresh()
//                    }
//            }
//            
//            HStack {
//                Spacer()
//                if refresh {
//                    ProgressView()
//                        .scaleEffect(1.5)
//                        .padding()
//                }
//                Spacer()
//            }
//        }
//        .padding(.top, -50)
//        .frame(height: 0)
//    }
//}
//
//    // Supporting Views remain the same, but here they are for completeness:
//struct TeamListView: View {
//    let employees: [Profile]
//    
//    var body: some View {
//        List(employees) { employee in
//            VStack(alignment: .leading) {
//                Text("\(employee.fname) \(employee.lname)")
//                    .font(.headline)
//                Text(employee.title)
//                    .font(.subheadline)
//                    .foregroundColor(.gray)
//            }
//        }
//        .navigationTitle("Team Members")
//    }
//}
//
//struct PendingApprovalsView: View {
//    var body: some View {
//        Text("Pending Approvals View")
//            .navigationTitle("Pending Approvals")
//    }
//}
//
//struct QuickActionRow: View {
//    let title: String
//    let subtitle: String
//    let systemImage: String
//    var trailing: String? = nil
//    var badge: String? = nil
//    
//    var body: some View {
//        HStack {
//            Image(systemName: systemImage)
//                .foregroundColor(.gray)
//                .frame(width: 30)
//            
//            VStack(alignment: .leading, spacing: 2) {
//                Text(title)
//                    .font(.body)
//                    .fontWeight(.medium)
//                
//                Text(subtitle)
//                    .font(.caption)
//                    .foregroundColor(.gray)
//            }
//            
//            Spacer()
//            
//            if let badge = badge {
//                Text(badge)
//                    .font(.caption)
//                    .fontWeight(.medium)
//                    .foregroundColor(.white)
//                    .padding(.horizontal, 8)
//                    .padding(.vertical, 4)
//                    .background(Color.orange)
//                    .cornerRadius(10)
//            } else if let trailing = trailing {
//                Text(trailing)
//                    .font(.caption)
//                    .foregroundColor(.blue)
//            }
//            
//            if badge == nil && trailing == nil {
//                Image(systemName: "chevron.right")
//                    .foregroundColor(.gray)
//                    .font(.caption)
//            }
//        }
//        .padding()
//        .contentShape(Rectangle())
//    }
//}
//
//struct QuickStatCard: View {
//    let title: String
//    let value: String
//    let systemImage: String
//    let color: Color
//    
//    var body: some View {
//        VStack(alignment: .leading, spacing: 6) {
//            ZStack {
//                Circle()
//                    .fill(color.opacity(0.2))
//                    .frame(width: 28, height: 28)
//                
//                Image(systemName: systemImage)
//                    .foregroundColor(color)
//                    .font(.system(size: 14))
//            }
//            
//            Text(title)
//                .font(.caption)
//                .foregroundColor(.gray)
//            
//            Text(value)
//                .font(.title3)
//                .fontWeight(.bold)
//        }
//        .frame(maxWidth: .infinity)
//        .padding(.vertical, 12)
//        .padding(.horizontal, 8)
//        .background(Color(.systemBackground))
//        .cornerRadius(15)
//        .shadow(radius: 2)
//    }
//}
//
//struct RecentActivityRow: View {
//    var body: some View {
//        HStack {
//            VStack(alignment: .leading, spacing: 4) {
//                Text("John Doe")
//                    .font(.system(size: 16, weight: .medium))
//                Text("Submitted timecard")
//                    .font(.caption)
//                    .foregroundColor(.gray)
//            }
//            
//            Spacer()
//            
//            Text("2h ago")
//                .font(.caption)
//                .foregroundColor(.gray)
//        }
//        .padding()
//    }
//}


import SwiftUI

struct ManagerDashboardView: View {
    @StateObject private var viewModel = ManagerViewModel()
    
    var body: some View {
        NavigationView {
            ScrollView {
                RefreshControl(coordinateSpace: .named("refresh")) {
                    if let userId = UserDefaults.standard.string(forKey: "userId") {
                        viewModel.fetchManagerData(managerId: userId)
                    }
                }
                
                VStack(spacing: 20) {
                        // Quick Stats Cards
                    HStack(spacing: 8) {
                        QuickStatCard(
                            title: "Team Size",
                            value: "\(viewModel.managedEmployees.count)",
                            systemImage: "person.2.fill",
                            color: .blue
                        )
                        
                        QuickStatCard(
                            title: "Pending",
                            value: "0",
                            systemImage: "clock.fill",
                            color: .orange
                        )
                        
                        
                        QuickStatCard(
                            title: "This Week",
                            value: String(format: "%.1fh", viewModel.weeklyHours),
                            systemImage: "chart.bar.fill",
                            color: .green
                        )
                    }
                    .padding(.horizontal)
                    
                        // Quick Actions
                    VStack(alignment: .leading, spacing: 0) {
                        Text("Quick Actions")
                            .font(.headline)
                            .padding()
                        
                        Divider()
                        
                        NavigationLink(destination: TeamListView(employees: viewModel.managedEmployees)) {
                            QuickActionRow(
                                title: "View Team",
                                subtitle: "Manage your employees",
                                systemImage: "person.2.fill",
                                trailing: "\(viewModel.managedEmployees.count) Members"
                            )
                        }
                        
                        Divider()
                        
                        NavigationLink(destination: PendingTimecardApprovals(viewModel: viewModel, managerId: viewModel.managedEmployees.first?.id ?? "")) {
                            QuickActionRow(
                                title: "Pending Approvals",
                                subtitle: "Review timecards",
                                systemImage: "clock.fill",
                                badge: "\(viewModel.pendingTimecards.count + viewModel.pendingLeaveRequests.count)"
                            )
                        }

                        NavigationLink(destination: LeaveRequestsView(viewModel: viewModel)) {
                            QuickActionRow(
                                title: "Leave Requests",
                                subtitle: "Review Leave Requests",
                                systemImage: "clock.fill",
                                badge: "0"
                            )
                        }
                    }
                    .background(Color(.systemBackground))
                    .cornerRadius(15)
                    .shadow(radius: 2)
                    .padding(.horizontal)
                    
                        // Recent Activity
                    VStack(alignment: .leading, spacing: 0) {
                        Text("Recent Activity")
                            .font(.headline)
                            .padding()
                        
                        Divider()
                        
                        ForEach(0..<3) { _ in
                            RecentActivityRow()
                            Divider()
                        }
                    }
                    .background(Color(.systemBackground))
                    .cornerRadius(15)
                    .shadow(radius: 2)
                    .padding(.horizontal)
                }
                .padding(.top)
            }
            .coordinateSpace(name: "refresh")
            .navigationTitle("Dashboard")
            .background(Color(.systemGroupedBackground))
            .overlay {
                if viewModel.isLoading {
                    ProgressView()
                        .scaleEffect(1.5)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(Color.black.opacity(0.1))
                }
            }
        }
        .onAppear {
            if let userId = UserDefaults.standard.string(forKey: "userId") {
                viewModel.fetchManagerData(managerId: userId)
            }
        }
    }
}

    // RefreshControl Component
struct RefreshControl: View {
    var coordinateSpace: CoordinateSpace
    var onRefresh: () -> Void
    
    @State private var refresh: Bool = false
    @State private var frozen: Bool = false
    
    var body: some View {
        GeometryReader { geo in
            if geo.frame(in: coordinateSpace).midY > 50 {
                Spacer()
                    .onAppear {
                        if !refresh {
                            refresh = true
                        }
                    }
            } else if geo.frame(in: coordinateSpace).maxY < 1 {
                Spacer()
                    .onAppear {
                        if refresh {
                            refresh = false
                            frozen = false
                        }
                    }
            }
            
            if refresh && !frozen {
                Spacer()
                    .onAppear {
                        frozen = true
                        onRefresh()
                    }
            }
            
            HStack {
                Spacer()
                if refresh {
                    ProgressView()
                        .scaleEffect(1.5)
                        .padding()
                }
                Spacer()
            }
        }
        .padding(.top, -50)
        .frame(height: 0)
    }
}

    // Supporting Views remain the same, but here they are for completeness:
struct TeamListView: View {
    let employees: [Profile]
    
    var body: some View {
        List(employees) { employee in
            VStack(alignment: .leading) {
                Text("\(employee.fname) \(employee.lname)")
                    .font(.headline)
                Text(employee.title)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
        }
        .navigationTitle("Team Members")
    }
}

struct PendingApprovalsView: View {
    var body: some View {
        Text("Pending Approvals View")
            .navigationTitle("Pending Approvals")
    }
}

struct QuickActionRow: View {
    let title: String
    let subtitle: String
    let systemImage: String
    var trailing: String? = nil
    var badge: String? = nil
    
    var body: some View {
        HStack {
            Image(systemName: systemImage)
                .foregroundColor(.gray)
                .frame(width: 30)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.body)
                    .fontWeight(.medium)
                
                Text(subtitle)
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            if let badge = badge {
                Text(badge)
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(.white)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.orange)
                    .cornerRadius(10)
            } else if let trailing = trailing {
                Text(trailing)
                    .font(.caption)
                    .foregroundColor(.blue)
            }
            
            if badge == nil && trailing == nil {
                Image(systemName: "chevron.right")
                    .foregroundColor(.gray)
                    .font(.caption)
            }
        }
        .padding()
        .contentShape(Rectangle())
    }
}

struct QuickStatCard: View {
    let title: String
    let value: String
    let systemImage: String
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            ZStack {
                Circle()
                    .fill(color.opacity(0.2))
                    .frame(width: 28, height: 28)
                
                Image(systemName: systemImage)
                    .foregroundColor(color)
                    .font(.system(size: 14))
            }
            
            Text(title)
                .font(.caption)
                .foregroundColor(.gray)
            
            Text(value)
                .font(.title3)
                .fontWeight(.bold)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 12)
        .padding(.horizontal, 8)
        .background(Color(.systemBackground))
        .cornerRadius(15)
        .shadow(radius: 2)
    }
}

struct RecentActivityRow: View {
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("John Doe")
                    .font(.system(size: 16, weight: .medium))
                Text("Submitted timecard")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            Text("2h ago")
                .font(.caption)
                .foregroundColor(.gray)
        }
        .padding()
    }
}
