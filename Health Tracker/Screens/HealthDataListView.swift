//
//  HealthDataListView.swift
//  Health Tracker
//
//  Created by Andres Made on 4/25/24.
//

import SwiftUI

struct HealthDataListView: View {
    var metric: HealthMetrixContext
    @State private var isShowingAddData: Bool = false
    @State private var addDateData: Date = .now
    @State private var valueToAdd: String = ""
    
    var body: some View {
        VStack {
            List(0 ..< 28) { item in
                LabeledContent {
                    Text(1000, format: .number.precision(.fractionLength(metric == .steps ? 0 : 1)))
                        .foregroundStyle(.primary)
                } label: {
                    Text(Date(), format: .dateTime.month().day().year())
                }

            }
            .listStyle(.plain)
        }
        .navigationTitle(metric.title)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("Add Metric", systemImage: "plus") {
                    isShowingAddData.toggle()
                }
            }
        }
        .sheet(isPresented: $isShowingAddData) {
           addDetailview
        }
    }
    var addDetailview: some View {
        NavigationStack {
            Form {
                DatePicker("Add Date", selection: $addDateData, displayedComponents: .date)
                
                LabeledContent(metric.title) {
                    TextField("Value", text: $valueToAdd)
                        .multilineTextAlignment(.trailing)
                        .frame(width: 50)
                        .keyboardType(metric == .steps ? .numberPad : .decimalPad)
                }
            }
            .navigationTitle(metric.title)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") {
                        isShowingAddData = false
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Add Data") {
                        isShowingAddData = false
                    }
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        HealthDataListView(metric: .weight)
    }
}
