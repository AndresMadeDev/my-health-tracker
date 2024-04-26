//
//  DashboardView.swift
//  Health Tracker
//
//  Created by Andres Made on 4/25/24.
//

import SwiftUI

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
    @State private var selectedStat: HealthMetrixContext = .steps
    var isSteps: Bool {selectedStat == .steps}
    
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
                                    Text("Avg 10K steps")
                                        .font(.caption)
                                }
                                Spacer()
                                Image(systemName: "chevron.right")
                            }
                        }
                        .foregroundStyle(.secondary)
                        .padding(.bottom, 12)
                        RoundedRectangle(cornerRadius: 12)
                            .foregroundStyle(.secondary)
                            .frame(height: 150)
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color(Color(.secondarySystemBackground)))
                    )
                    
                    VStack(alignment: .leading){                        VStack(alignment: .leading) {
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
            .navigationTitle("Dashboard")
            .navigationDestination(for: HealthMetrixContext.self) { metric in
                HealthDataListView(metric: metric)
            }
        }
        .tint(isSteps ? .pink : .indigo)
    }
}

#Preview {
    DashboardView()
}
