//
//  HealthMetrics.swift
//  Health Tracker
//
//  Created by Andres Made on 4/30/24.
//

import Foundation

struct HealthMetric: Identifiable {
    let id = UUID()
    let date: Date
    let value: Double
    
    static var dummyData: [HealthMetric] {
        var array: [HealthMetric] = []
        
        for i in 0..<28 {
            let metric = HealthMetric(date: Calendar.current.date(byAdding: .day, value: -i, to: .now)!,
                                      value: .random(in: 4000...9000))
            array.append(metric)
        }
        return array
    }
}
