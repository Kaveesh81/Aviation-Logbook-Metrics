//
//  LogFlightView.swift
//  AviationLogbook
//
//  Created by Kaveesh Passari on 12/3/24.
//

import SwiftUI
import AVFoundation
import CoreLocation
import CoreLocationUI

struct LogFlightView: View {
    @Binding var flightData: [Flight]
    @State private var isRecording = false
    @StateObject private var flightManager = FlightManager() // Observing the flight manager
    @State private var flightDuration: TimeInterval = 0 // Duration of the current flight
    @State private var distanceCovered: Double = 0 // Distance covered during the flight
    @State private var timer: Timer? // Timer for updating duration
    private var audioRecorder = AudioRecorder()
    init(flightData: Binding<[Flight]>) { // Explicit initializer
            _flightData = flightData
    }

        var body: some View {
            VStack(spacing: 20) {
                Text("Log Flight Data")
                    .font(.largeTitle)
                    .padding()
                Toggle("Simulated Mode", isOn: $flightManager.simulatedMode)
                                .padding()
                
                Text(flightManager.isFlightActive ? "Flight In Progress" : "No Active Flight")
                    .font(.title2)
                    .foregroundColor(flightManager.isFlightActive ? .green : .red)
                    .padding()

                if flightManager.isFlightActive {
                    Text("Duration: \(formatDuration(flightDuration))")
                        .font(.title2)
                }

                if flightManager.isFlightActive {
                    Text("Distance: \(String(format: "%.2f", distanceCovered)) km")
                        .font(.title2)
                }

                // Start/Stop Monitoring Button
                Button(action: {
                    if isRecording {
                        stopFlightTracking()
                    } else {
                        startFlightTracking()
                    }
                    isRecording.toggle()
                }) {
                    Text(isRecording ? "Stop Flight" : "Start Flight")
                        .font(.title2)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(isRecording ? Color.red : Color.green)
                        .cornerRadius(10)
                        .shadow(radius: 3)
                }
                .padding()

                // List of Previous Flights
                List(flightManager.flights) { flight in
                    VStack(alignment: .leading) {
                        Text("Date: \(formatDate(flight.start))")
                            .font(.headline)
                        Text("Duration: \(formatDuration(flight.duration))")
                    }
                }
                .navigationTitle("Logged Flights")

                Spacer()
            }
            .onAppear {
                audioRecorder.setupAudioSession()
            }
            .onChange(of: flightManager.isFlightActive) {
                if flightManager.isFlightActive {
                    startTimer()
                } else {
                    stopTimer()
                }
            }

            .onChange(of: flightManager.flightStartTime) {
                if let start = flightManager.flightStartTime {
                    flightDuration = Date().timeIntervalSince(start)
                }
            }
            .onChange(of: flightManager.totalDistance) { _, newDistance in
                distanceCovered = newDistance
            }
            .onDisappear {
                if let startTime = flightManager.flightStartTime {
                    let flight = Flight(start: startTime, duration: flightDuration, distance: 0, altitudeFluctuations: 0)
                    flightData.append(flight) // Add the flight to the shared data
                }
            }
            .navigationTitle("Log a Flight")
            .padding()
        }

        // Start Tracking Flight
        private func startFlightTracking() {
            flightManager.startMonitoring()
            flightManager.startMicrophoneMonitoring()
            flightManager.resetTracking()
            flightManager.flightStartTime = Date()
        }

        // Stop Tracking Flight
        private func stopFlightTracking() {
            flightManager.stopMonitoring()
            flightManager.stopMicrophoneMonitoring()
            stopTimer()
        }

        // Timer Functions
        private func startTimer() {
            timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
                if let start = flightManager.flightStartTime {
                    flightDuration = Date().timeIntervalSince(start)
                }
            }
        }

        private func stopTimer() {
            timer?.invalidate()
            timer = nil
        }

        // Format Duration for Display
        private func formatDuration(_ duration: TimeInterval) -> String {
            let hours = Int(duration) / 3600
            let minutes = (Int(duration) % 3600) / 60
            let seconds = Int(duration) % 60
            return String(format: "%02dh %02dm %02ds", hours, minutes, seconds)
        }
        private func formatDate(_ date: Date) -> String {
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            return formatter.string(from: date)
        }
    }
