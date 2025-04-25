//
//  ContentView.swift
//  AviationLogbook
//
//  Created by Kaveesh Passari on 11/25/24.
//

import SwiftUI
import AVFoundation
import CoreLocation
import CoreLocationUI

struct ContentView: View {
    @State private var flightData: [Flight] = []
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("Aviation Logbook")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding()
                
                NavigationLink(destination: LogFlightView(flightData: $flightData)) {
                    FeatureButton(title: "Log a Flight", iconName: "airplane.circle")
                }
                
                NavigationLink(destination: AnalyticsView(flightData: $flightData)) {
                    FeatureButton(title: "View Analytics", iconName: "chart.bar.fill")
                }
                
                NavigationLink(destination: PilotProfileView()) {
                    FeatureButton(title: "Pilot Profile", iconName: "person.crop.circle")
                }
                
                Spacer()
            }
            .padding()
            .navigationTitle("Home")
        }
    }
}
private var mockFlightData: [Flight] {
    return [
        Flight(start: Date(), duration: 5400, distance: 150, altitudeFluctuations: 300),
        Flight(start: Calendar.current.date(byAdding: .day, value: -1, to: Date())!, duration: 3600, distance: 100, altitudeFluctuations: 200)
    ]
}

struct FeatureButton: View {
    let title: String
    let iconName: String
    
    var body: some View {
        HStack {
            Image(systemName: iconName)
                .imageScale(.large)
                .foregroundColor(.blue)
            Text(title)
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundColor(.primary)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color(UIColor.systemGray5))
        .cornerRadius(10)
        .shadow(radius: 3)
    }
}

#Preview {
    ContentView()
}
