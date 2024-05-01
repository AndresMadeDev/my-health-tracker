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
    @State  private var rawSelectedDate: Date?
    var isSteps: Bool {selectedStat == .steps}
    var selectedHeatlhMetric: HealthMetric? {
        guard let rawSelectedDate else { return nil }
        return hkManager.stepData.first {
            Calendar.current.isDate(rawSelectedDate, inSameDayAs: $0.date)
        }
        
    }
    
    
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
                            if let selectedHeatlhMetric {
                                RuleMark(x: .value("Selected Metric", selectedHeatlhMetric.date, unit: .day))
                                    .foregroundStyle(Color.secondary.opacity(0.3))
                                    .offset(y: -10)
                                    .annotation(position: .top,
                                                spacing: 0,
                                                overflowResolution: .init(x: .fit(to: .chart),y: .disabled)) {
                                        anotationView
                                    }
                            }
                            RuleMark(y: .value("Average", averageStepCount))
                                .foregroundStyle(.secondary)
                                .lineStyle(.init(lineWidth: 1, dash: [5]))
                            
                            ForEach(hkManager.stepData) { steps in
                                BarMark(x: .value("Date", steps.date, unit: .day),
                                        y: .value("Steps", steps.value)
                                )
                                .foregroundStyle(Color.pink.gradient)
                                .opacity(rawSelectedDate == nil || steps.date  == selectedHeatlhMetric?.date ? 1.0 : 0.3)
                            }
                        }
                        .frame(height: 150)
                        .chartXSelection(value: $rawSelectedDate.animation(.easeInOut))
                       
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
    var anotationView: some View {
        VStack(alignment: .leading) {
            Text(selectedHeatlhMetric?.date ?? .now, format: .dateTime.weekday(.abbreviated).month(.abbreviated).day())
                .font(.footnote.bold())
                .foregroundStyle(.secondary)
            
            Text(selectedHeatlhMetric?.value ?? 0, format: .number.precision(.fractionLength(0 )))
                .fontWeight(.heavy)
                .foregroundStyle(.pink)
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 4)
                .fill(Color(.secondarySystemBackground))
                .shadow(color: .secondary.opacity(0.3), radius: 2, x: 2, y: 2)
        )
    }
}

#Preview {
    DashboardView()
        .environment(HealthKitManager())
}
