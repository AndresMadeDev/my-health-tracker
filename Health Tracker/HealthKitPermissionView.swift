//
//  HealthKitPermissionView.swift
//  Health Tracker
//
//  Created by Andres Made on 4/25/24.
//

import SwiftUI
import HealthKitUI

struct HealthKitPermissionView: View {
    @Environment(HealthKitManager.self) private var hkManager
    @Environment(\.dismiss) private var dismiss
    @State private var isShowingHealthKitPermission: Bool = false
    
    var description = """
    This app displays your step and weight data in interactive charts.
    
    You can also add new step or weight data to Apple Health from this app. Your data is private and secured.
    """
    
    var body: some View {
        VStack(spacing: 130) {
            VStack(alignment: .leading, spacing: 12) {
                Image(uiImage: .healthkitIcon)
                    .resizable()
                    .frame(width: 90, height: 90)
                    .shadow(color: .gray.opacity(0.3),radius: 15)
                    .padding(.bottom, 12)
                
                Text("Apple Healt Intergration")
                    .font(.title2).bold()
                
                Text(description)
                    .foregroundStyle(.secondary)
            }
            
            Button("Connect Apple Health") {
                isShowingHealthKitPermission = true
            }
            .buttonStyle(.borderedProminent)
            .tint(.pink)
        }
        .padding(30)
        .healthDataAccessRequest(store: hkManager.store,
                                 shareTypes: hkManager.types,
                                 readTypes: hkManager.types,
                                 trigger: isShowingHealthKitPermission) { result in
            switch result {
            case .success( _):
                dismiss()
            case .failure( _):
                dismiss()
            }
        }
    }
}

#Preview {
    HealthKitPermissionView()
        .environment(HealthKitManager())
}
