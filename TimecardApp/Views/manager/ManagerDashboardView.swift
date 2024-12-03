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
                
                VStack(spacing: 10) {
                        // Quick Stats Cards
                    HStack(spacing: 15) {
                        QuickStatCard(
                            title: "Pending Timecards",
                            value: "0",
                            systemImage: "clock.fill",
                            color: .pink
                        )
                        
                        QuickStatCard(
                            title: "Total Hours This Week",
                            value: String(format: "%.1f", viewModel.weeklyHours),
                            systemImage: "chart.bar.fill",
                            color: .green
                        )
                    }
                    .padding()
                    
                    VStack(alignment: .leading, spacing: 0) {
                        
                        NavigationLink(destination: TeamListView(employees: viewModel.managedEmployees)) {
                            QuickActionRow(
                                title: "View My Team",
                                subtitle: "View all your team members here",
                                systemImage: "person.2.fill",
                                badge: "\(viewModel.managedEmployees.count)"
                            )
                        }

                        Divider()
                        
                        NavigationLink(destination: PendingApprovalsView()) {
                            QuickActionRow(
                                title: "Pending Approvals",
                                subtitle: "Review all submitted timecards here",
                                systemImage: "clock.fill",
                                badge: "0"
                            )
                        }
                    }
                    .background(Color(.systemBackground))
                    .cornerRadius(15)
                    .shadow(radius: 1)
                    .padding()
                    
                    
                }
            }
            .coordinateSpace(name: "refresh")
            .navigationTitle("Team Dashboard")
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
                .frame(width: 40)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.body)
                    .fontWeight(.medium)
                    .foregroundColor(.black)

                Text(subtitle)
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            if let badge = badge {
                Text(badge)
                    .font(.caption)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .foregroundColor(.white)
                    .background(.gray.opacity(0.6))
                    .cornerRadius(10)
            }
            if badge == nil {
                Image(systemName: "chevron.right")
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
        VStack(spacing: 5) {
            ZStack {
                Circle()
                    .fill(color.opacity(0.2))
                    .frame(width: 30, height: 30)
                
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
        .padding()
        .background(.white)
        .cornerRadius(15)
        .shadow(radius: 1)
    }
}
