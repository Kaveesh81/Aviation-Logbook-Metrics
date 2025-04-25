//
//  FlightDetailView.swift
//  AviationLogbook
//
//  Created by Kaveesh Passari on 12/3/24.
//

import SwiftUI

struct FlightDetailView: View {
    var flight: Flight

    var body: some View {
            VStack(spacing: 20) {

                VStack(alignment: .leading, spacing: 10) {
                    DetailRow(title: "Date", value: formatDate(flight.start))
                    DetailRow(title: "Duration", value: formatDuration(flight.duration))
                    DetailRow(title: "Distance", value: "\(String(format: "%.2f", flight.distance)) km")
                    DetailRow(title: "Altitude Changes", value: "\(flight.altitudeFluctuations) m")
                }
                .padding()
                .background(Color(UIColor.secondarySystemBackground))
                .cornerRadius(10)
                .shadow(radius: 3)

                Spacer()
            }
            .padding()
            .navigationTitle("Flight Details")
        }
    
    struct DetailRow: View {
        let title: String
        let value: String

        var body: some View {
            HStack {
                Text("\(title):")
                    .fontWeight(.semibold)
                Spacer()
                Text(value)
                    .foregroundColor(.secondary)
            }
            .font(.title3)
        }
    }

    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }

    private func formatDuration(_ duration: TimeInterval) -> String {
        let hours = Int(duration) / 3600
        let minutes = (Int(duration) % 3600) / 60
        return "\(hours)h \(minutes)m"
    }
}
