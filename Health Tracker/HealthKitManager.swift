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
