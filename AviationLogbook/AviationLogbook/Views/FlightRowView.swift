//
//  FlightRowView.swift
//  AviationLogbook
//
//  Created by Kaveesh Passari on 12/3/24.
//
import SwiftUI

struct FlightRowView: View {
    let flight: Flight
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Date: \(formatDate(flight.start))")
                .font(.headline)
            Text("Duration: \(formatDuration(flight.duration))")
                .font(.subheadline)
            Text("Distance: \(String(format: "%.2f", flight.distance)) km")
                .font(.subheadline)
        }
        .padding()
        .frame(maxWidth: .infinity,alignment: .leading)
        .background(Color(UIColor.secondarySystemBackground))
        .cornerRadius(10)
        .shadow(radius: 2)
    }
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }

    // Format Duration for Display
    private func formatDuration(_ duration: TimeInterval) -> String {
        let hours = Int(duration) / 3600
        let minutes = (Int(duration) % 3600) / 60
        return "\(hours)h \(minutes)m"
    }
}
