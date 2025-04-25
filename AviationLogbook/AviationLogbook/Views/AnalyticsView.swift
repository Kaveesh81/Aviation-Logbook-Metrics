//
//  AnalyticsView.swift
//  AviationLogbook
//
//  Created by Kaveesh Passari on 12/3/24.
//

import SwiftUI

struct AnalyticsView: View {
    @Binding var flightData: [Flight] // Data source for all flights
    @StateObject private var locationManager = FlightLocationManager()

    var body: some View {
        NavigationView {
                    VStack {
                        ScrollView {
                            LazyVStack(spacing: 10) {
                                ForEach(flightData, id: \.id) { flight in
                                    NavigationLink(destination: FlightDetailView(flight: flight)) {
                                        FlightRowView(flight: flight)
                                    }
                                    .buttonStyle(PlainButtonStyle()) // To remove default link styling
                                }
                            }
                            .padding()
                        }
                    }
                    .padding()
                    .navigationTitle("Flight Logbook")
                }
    }
    
    
}
