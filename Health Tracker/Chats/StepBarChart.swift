//
//  StepBarChart.swift
//  Health Tracker
//
//  Created by Andres Made on 5/4/24.
//

import SwiftUI
import Charts

struct StepBarChart: View {
    var chartData: [HealthMetric]
    var selectedStat: HealthMetrixContext
    
    @State  private var rawSelectedDate: Date?
    
    var averageStepCount: Double {
        guard !chartData.isEmpty else { return 0 }
        let totalStep = chartData.reduce(0, {$0 + $1.value})
        return totalStep/Double(chartData.count)
    }
    
    var selectedHeatlhMetric: HealthMetric? {
        guard let rawSelectedDate else { return nil }
        return chartData.first {
            Calendar.current.isDate(rawSelectedDate, inSameDayAs: $0.date)
        }
    }
    
    var body: some View {
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
                
                ForEach(chartData) { steps in
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
    StepBarChart(chartData: HealthMetric.dummyData, selectedStat: .steps)
        .environment(HealthKitManager())
}
