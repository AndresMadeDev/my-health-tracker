//
//  DashboardView.swift
//  Health Tracker
//
//  Created by Andres Made on 4/25/24.
//

import SwiftUI
import Charts

enum HealthMetrixContext: CaseIterable, Identifiable {
    case steps, weight
    var id: Self { self }
    var title: String {
        switch self {
        case .steps:
            return "Setps"
        case .weight:
            return "Weight"
        }
    }
}

struct DashboardView: View {
    @Environment(HealthKitManager.self) private var hkManager
    @AppStorage("hasSeenPermision") private var hasSeenPermision = false
    @State private var isShowingPermision: Bool = false
    @State private var selectedStat: HealthMetrixContext = .steps
    var isSteps: Bool {selectedStat == .steps}
    
    var averageStepCount: Double {
        guard !hkManager.stepData.isEmpty else { return 0 }
        let totalStep = hkManager.stepData.reduce(0, {$0 + $1.value})
        return totalStep/Double(hkManager.stepData.count)
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    Picker("Selected Stet", selection: $selectedStat) {
                        ForEach(HealthMetrixContext.allCases) {
                            Text($0.title)
                        }
                    }
                    .pickerStyle(.segmented)
                    
                    VStack{
                        NavigationLink(value: selectedStat) {
                            HStack {
                                VStack(alignment: .leading) {
                                    Label("Steps", systemImage: "figure.walk")
                                        .font(.title).bold()
                                        .foregroundStyle(.pink)
                                    Text("Avg \(Int(averageStepCount)) steps")
                                        .font(.caption)
                                }
                                Spacer()
                                Image(systemName: "chevron.right")
                            }
                        }
                        .foregroundStyle(.secondary)
                        .padding(.bottom, 12)
                        
                        Chart {
                            RuleMark(y: .value("Average", averageStepCount))
                                .foregroundStyle(.secondary)
                                .lineStyle(.init(lineWidth: 1, dash: [5]))
                            
                            ForEach(hkManager.stepData) { steps in
                                BarMark(x: .value("Date", steps.date, unit: .day),
                                        y: .value("Steps", steps.value)
                                )
                                .foregroundStyle(Color.pink.gradient)
                            }
                        }
                        .frame(height: 150)
                        .chartXAxis {
                            AxisMarks {
                                AxisValueLabel(format: .dateTime.month(.defaultDigits).day())
                            }
                        }
                        .chartYAxis {
                            AxisMarks { value in
                                AxisGridLine()
                                    .foregroundStyle(.secondary.opacity(0.3))
                                AxisValueLabel((value.as(Double.self) ?? 0).formatted(.number.notation(.compactName)))
                            }
                        }
                        
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color(Color(.secondarySystemBackground)))
                    )
                    
                    VStack(alignment: .leading){
                        VStack(alignment: .leading) {
                            Label("Averages", systemImage: "calendar")
                                .font(.title).bold()
                                .foregroundStyle(.pink)
                            Text("Last 28 Days")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        .padding(.bottom, 12)
                        RoundedRectangle(cornerRadius: 12)
                            .foregroundStyle(.secondary)
                            .frame(height: 240)
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color(Color(.secondarySystemBackground)))
                    )
                }
            }
            .padding()
            .task {
                await hkManager.fetchStepCount()
                isShowingPermision = !hasSeenPermision
            }
            .navigationTitle("Dashboard")
            .navigationDestination(for: HealthMetrixContext.self) { metric in
                HealthDataListView(metric: metric)
            }
            .sheet(isPresented: $isShowingPermision, onDismiss: {
                
            }, content: {
                HealthKitPermissionView(hasSeen: $hasSeenPermision)
            })
        }
        .tint(isSteps ? .pink : .indigo)
    }
}

#Preview {
    DashboardView()
        .environment(HealthKitManager())
}
