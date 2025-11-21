import SwiftUI
import Charts

struct DashboardView: View {
    @ObservedObject var goalStore: GoalStore
    @StateObject private var analytics: AnalyticsViewModel
    @Environment(\.colorScheme) var colorScheme
    
    init(goalStore: GoalStore) {
        self.goalStore = goalStore
        _analytics = StateObject(wrappedValue: AnalyticsViewModel(goals: goalStore.goals))
    }
    
    var body: some View {
        ZStack {
            VintageColors.cream
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 24) {
                    // Header Stats
                    DashboardHeaderView(analytics: analytics.analytics)
                    
                    // Completion Rate Chart
                    CompletionChartView(analytics: analytics.analytics)
                    
                    // Category Distribution Chart
                    CategoryChartView(analytics: analytics.analytics)
                    
                    // Progress Overview
                    ProgressOverviewView(analytics: analytics.analytics)
                }
                .padding()
            }
        }
        .onAppear {
            analytics.update(with: goalStore.goals)
        }
        .navigationTitle("Dashboard")
        .navigationBarTitleDisplayMode(.large)
    }
}

struct DashboardHeaderView: View {
    let analytics: GoalAnalytics
    
    var body: some View {
        VStack(spacing: 16) {
            HStack(spacing: 20) {
                DashboardStatCard(
                    label: "Total Goals",
                    value: "\(analytics.totalGoals)",
                    icon: "target",
                    color: VintageColors.burntOrange
                )
                
                DashboardStatCard(
                    label: "Completed",
                    value: "\(analytics.completedGoals)",
                    icon: "checkmark.circle.fill",
                    color: VintageColors.forestGreen
                )
            }
            
            HStack(spacing: 20) {
                DashboardStatCard(
                    label: "In Progress",
                    value: "\(analytics.inProgressGoals)",
                    icon: "clock.fill",
                    color: VintageColors.dustyBlue
                )
                
                DashboardStatCard(
                    label: "Avg Progress",
                    value: "\(Int(analytics.averageProgress * 100))%",
                    icon: "chart.bar.fill",
                    color: VintageColors.sageGreen
                )
            }
        }
    }
}

struct DashboardStatCard: View {
    let label: String
    let value: String
    let icon: String
    let color: Color
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 32))
                .foregroundColor(color)
                .shadow(color: color.opacity(colorScheme == .dark ? 0.5 : 0.3), radius: 4, x: 0, y: 2)
            
            Text(value)
                .font(.system(size: 28, design: .rounded))
                .fontWeight(.bold)
                .foregroundColor(VintageColors.deepBrown)
            
            Text(label)
                .font(.system(size: 12, design: .rounded))
                .foregroundColor(VintageColors.warmGray)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .vintageCard()
    }
}

struct CompletionChartView: View {
    let analytics: GoalAnalytics
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Goal Completion")
                .font(.system(size: 20, design: .rounded))
                .fontWeight(.bold)
                .foregroundColor(VintageColors.deepBrown)
            
            Chart {
                BarMark(
                    x: .value("Status", "Completed"),
                    y: .value("Count", analytics.completedGoals)
                )
                .foregroundStyle(VintageColors.forestGreen)
                .annotation(position: .overlay) {
                    Text("\(analytics.completedGoals)")
                        .font(.system(size: 14, design: .rounded))
                        .foregroundColor(.white)
                }
                
                BarMark(
                    x: .value("Status", "In Progress"),
                    y: .value("Count", analytics.inProgressGoals)
                )
                .foregroundStyle(VintageColors.burntOrange)
                .annotation(position: .overlay) {
                    Text("\(analytics.inProgressGoals)")
                        .font(.system(size: 14, design: .rounded))
                        .foregroundColor(.white)
                }
            }
            .frame(height: 200)
            .chartXAxis {
                AxisMarks { value in
                    AxisGridLine(stroke: StrokeStyle(lineWidth: 0.5))
                        .foregroundStyle(VintageColors.warmGray.opacity(colorScheme == .dark ? 0.2 : 0.3))
                    AxisValueLabel()
                        .font(.system(size: 12, design: .rounded))
                        .foregroundStyle(VintageColors.deepBrown)
                }
            }
            .chartYAxis {
                AxisMarks { value in
                    AxisGridLine(stroke: StrokeStyle(lineWidth: 0.5))
                        .foregroundStyle(VintageColors.warmGray.opacity(colorScheme == .dark ? 0.2 : 0.3))
                    AxisValueLabel()
                        .font(.system(size: 10, design: .rounded))
                        .foregroundStyle(VintageColors.warmGray)
                }
            }
        }
        .padding()
        .vintageCard()
    }
}

struct CategoryChartView: View {
    let analytics: GoalAnalytics
    @Environment(\.colorScheme) var colorScheme
    
    var sortedCategories: [(key: String, value: Int)] {
        analytics.goalsByCategory.sorted { $0.value > $1.value }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Goals by Category")
                .font(.system(size: 20, design: .rounded))
                .fontWeight(.bold)
                .foregroundColor(VintageColors.deepBrown)
            
            Chart {
                ForEach(sortedCategories, id: \.key) { category in
                    BarMark(
                        x: .value("Category", category.key),
                        y: .value("Count", category.value)
                    )
                    .foregroundStyle(VintageColors.colorForCategory(category.key))
                    .annotation(position: .overlay) {
                        Text("\(category.value)")
                            .font(.system(size: 12, design: .rounded))
                            .foregroundColor(.white)
                    }
                }
            }
            .frame(height: 200)
            .chartXAxis {
                AxisMarks { value in
                    AxisGridLine(stroke: StrokeStyle(lineWidth: 0.5))
                        .foregroundStyle(VintageColors.warmGray.opacity(colorScheme == .dark ? 0.2 : 0.3))
                    AxisValueLabel()
                        .font(.system(size: 10, design: .rounded))
                        .foregroundStyle(VintageColors.deepBrown)
                }
            }
            .chartYAxis {
                AxisMarks { value in
                    AxisGridLine(stroke: StrokeStyle(lineWidth: 0.5))
                        .foregroundStyle(VintageColors.warmGray.opacity(colorScheme == .dark ? 0.2 : 0.3))
                    AxisValueLabel()
                        .font(.system(size: 10, design: .rounded))
                        .foregroundStyle(VintageColors.warmGray)
                }
            }
        }
        .padding()
        .vintageCard()
    }
}

struct ProgressOverviewView: View {
    let analytics: GoalAnalytics
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Overall Progress")
                .font(.system(size: 20, design: .rounded))
                .fontWeight(.bold)
                .foregroundColor(VintageColors.deepBrown)
            
            VStack(spacing: 16) {
                ProgressRing(
                    progress: analytics.completionRate,
                    color: VintageColors.forestGreen,
                    label: "Completion Rate"
                )
                
                if !sortedCategories.isEmpty {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Top Categories")
                            .font(.system(size: 14, design: .rounded))
                            .foregroundColor(VintageColors.deepBrown.opacity(0.7))
                        
                        ForEach(sortedCategories.prefix(3), id: \.key) { category in
                            HStack {
                                Circle()
                                    .fill(VintageColors.colorForCategory(category.key))
                                    .frame(width: 12, height: 12)
                                
                                Text(category.key)
                                    .font(.system(size: 14, design: .rounded))
                                    .foregroundColor(VintageColors.deepBrown)
                                
                                Spacer()
                                
                                Text("\(category.value)")
                                    .font(.system(size: 14, design: .rounded))
                                    .fontWeight(.semibold)
                                    .foregroundColor(VintageColors.warmGray)
                            }
                        }
                    }
                    .padding()
                    .background(
                        colorScheme == .dark 
                            ? Color.white.opacity(0.05)
                            : VintageColors.parchment.opacity(0.5)
                    )
                    .cornerRadius(10)
                }
            }
        }
        .padding()
        .vintageCard()
    }
    
    var sortedCategories: [(key: String, value: Int)] {
        analytics.goalsByCategory.sorted { $0.value > $1.value }
    }
}

struct ProgressRing: View {
    let progress: Double
    let color: Color
    let label: String
    
    var body: some View {
        VStack(spacing: 12) {
            ZStack {
                Circle()
                    .stroke(color.opacity(0.2), lineWidth: 16)
                
                Circle()
                    .trim(from: 0, to: progress)
                    .stroke(
                        LinearGradient(
                            colors: [color, color.opacity(0.6)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        style: StrokeStyle(lineWidth: 16, lineCap: .round)
                    )
                    .rotationEffect(.degrees(-90))
                    .animation(.spring(response: 0.6, dampingFraction: 0.8), value: progress)
                
                VStack {
                    Text("\(Int(progress * 100))%")
                        .font(.system(size: 32, design: .rounded))
                        .fontWeight(.bold)
                        .foregroundColor(VintageColors.deepBrown)
                }
            }
            .frame(width: 140, height: 140)
            
            Text(label)
                .font(.system(size: 14, design: .rounded))
                .foregroundColor(VintageColors.warmGray)
        }
    }
}

