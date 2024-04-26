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
    
}
