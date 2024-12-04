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
                            title: "Team Size",
                            value: "\(viewModel.managedEmployees.count)",
                            systemImage: "person.2.fill",
                            color: .blue
                        )
                        QuickStatCard(
                            title: "This Week",
                            value: String(format: "%.1fh", viewModel.weeklyHours),
                            systemImage: "chart.bar.fill",
                            color: .green
                        )
                        QuickStatCard(
                            title: "Pending",
                            value: "0",
                            systemImage: "clock.fill",
                            color: .pink
                        )
                    }
                    .padding()
                    
                    VStack(alignment: .leading, spacing: 0) {
                        
                        NavigationLink(destination: TeamListView(employees: viewModel.managedEmployees)) {
                            QuickActionRow(
                                title: "View My Team",
                                subtitle: "View all your team members here",
                                systemImage: "person.2.fill"
                            )
                            
                        }
                        
                        Divider()
                        
                        NavigationLink(destination: PendingTimecardApprovals(viewModel: viewModel, managerId: viewModel.managedEmployees.first?.id ?? "")) {
                            QuickActionRow(
                                title: "Manage Timecards",
                                subtitle: "Review all submitted timecards here",
                                systemImage: "clock.fill"
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
                        .scaleEffect(1)
                        .padding()
                }
                Spacer()
            }
        }
        .padding(.top, -50)
        .frame(height: 0)
    }
}

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

struct QuickActionRow: View {
    let title: String
    let subtitle: String
    let systemImage: String
    var trailing: String? = nil
    
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
            Image(systemName: "chevron.right")
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
