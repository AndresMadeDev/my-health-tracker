//
//  ContentView.swift
//  Health Tracker
//
//  Created by Andres Made on 4/25/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    VStack{
                        HStack {
                            VStack(alignment: .leading) {
                               Label("Steps", systemImage: "figure.walk")
                                    .font(.title).bold()
                                    .foregroundStyle(.pink)
                                Text("Avg 10K steps")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                            Spacer()
                            Image(systemName: "chevron.right")
                                .foregroundStyle(.secondary)
                        }
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
        }
    }
}

#Preview {
    ContentView()
}
