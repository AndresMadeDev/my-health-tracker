//
//  Health_TrackerApp.swift
//  Health Tracker
//
//  Created by Andres Made on 4/25/24.
//

import SwiftUI

@main
struct Health_TrackerApp: App {
    let hkManager = HealthKitManager()
    
    var body: some Scene {
        WindowGroup {
            DashboardView()
                .environment(hkManager)
        }
    }
}
