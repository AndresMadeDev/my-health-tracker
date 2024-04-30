//
//  HealthKitManager.swift
//  Health Tracker
//
//  Created by Andres Made on 4/25/24.
//

import Foundation
import HealthKit
import Observation

@Observable class HealthKitManager {
    
    let store = HKHealthStore()
    
    let types: Set = [HKQuantityType(.stepCount), HKQuantityType(.bodyMass)]
    var stepData: [HealthMetric] = []
    var weightData: [HealthMetric] = []
    
    func fetchStepCount() async {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: .now)
        let endDate = calendar.date(bySetting: .day, value: 1, of: today)!
        let startDate = calendar.date(bySetting: .day, value: -28, of: endDate)
        
        let queryPredicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate)
        let samplePredicate = HKSamplePredicate.quantitySample(type: HKQuantityType(.stepCount), predicate: queryPredicate)
        
        let stepQuery = HKStatisticsCollectionQueryDescriptor(
            predicate: samplePredicate,
            options: .cumulativeSum,
            anchorDate: endDate,
            intervalComponents: .init(day: 1))
        
        do {
            let stepCounts = try await stepQuery.result(for: store)
            stepData = stepCounts.statistics().map {
                .init(date: $0.startDate, value: $0.sumQuantity()?.doubleValue(for: .count()) ?? 0)
            }
        } catch {
            
        }

    }
    
    func fetchWeight() async {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: .now)
        let endDate = calendar.date(bySetting: .day, value: 1, of: today)!
        let startDate = calendar.date(bySetting: .day, value: -28, of: endDate)
        
        let queryPredicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate)
        let samplePredicate = HKSamplePredicate.quantitySample(type: HKQuantityType(.bodyMass), predicate: queryPredicate)
        
        let weightQuery = HKStatisticsCollectionQueryDescriptor(
            predicate: samplePredicate,
            options: .mostRecent,
            anchorDate: endDate,
            intervalComponents: .init(day: 1))
        
        do {
            let weight = try await weightQuery.result(for: store)
            weightData = weight.statistics().map {
                .init(date: $0.startDate, value: $0.mostRecentQuantity()?.doubleValue(for: .pound()) ?? 0)
            }
        } catch {
            
        }

    }
   
//    func addSimulaterData() async {
//        var mocSample: [HKQuantitySample] = []
//        
//        for i in 0..<28 {
//            let stepQuantity = HKQuantity(unit: .count(), doubleValue: .random(in: 4_000...10_000))
//            let weightQuantity = HKQuantity(unit: .pound(), doubleValue: .random(in: (160 + Double(i/3)...165 + Double(i/3))))
//            
//            let startDate = Calendar.current.date(byAdding: .day, value: -i, to: .now)!
//            let endDate = Calendar.current.date(byAdding: .second, value: 1, to: startDate)!
//            
//            let stepSample = HKQuantitySample(type: HKQuantityType(.stepCount),
//                                              quantity: stepQuantity,
//                                              start: startDate,
//                                              end: endDate)
//            let weaighSample = HKQuantitySample(type: HKQuantityType(.bodyMass),
//                                                quantity: weightQuantity,
//                                                start: startDate,
//                                                end: endDate)
//            
//            mocSample.append(stepSample)
//            mocSample.append(weaighSample)
//        }
//        
//        try! await store.save(mocSample)
//        print("✅ Dummy data sent up")
//    }
    
}
