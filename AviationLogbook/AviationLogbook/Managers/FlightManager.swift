//
//  FlightManager.swift
//  AviationLogbook
//
//  Created by Kaveesh Passari on 12/3/24.
//
import Foundation
import CoreLocation
import AVFoundation

class FlightManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let locationManager = CLLocationManager()
    private var audioRecorder: AVAudioRecorder?
    @Published var isFlightActive = false
    @Published var totalDistance: Double = 0
    @Published var flightStartTime: Date?
    @Published var authorizationStatus: CLAuthorizationStatus = .notDetermined

    @Published var flights: [Flight] = []
    private let microphoneThreshold: Float = -30
    private let movementSpeedThreshold: Double = -1
    private var previousLocation: CLLocation?
    var simulatedMode: Bool = false
    
    func startMonitoring() {
        if simulatedMode {
                    isFlightActive = true
                    flightStartTime = Date()
                    print("Simulated Flight Started at \(flightStartTime!)")
        } else {
            Task {
                do {
                    let stream = CLLocationUpdate.liveUpdates()
                    for try await update in stream {
                        handleLocationUpdate(update)
                    }
                } catch {
                    print("Failed to receive location updates: \(error)")
                }
            }
        }
    }
    func stopMonitoring() {
        if simulatedMode {
                    isFlightActive = false
                    if let startTime = flightStartTime {
                        let duration = Date().timeIntervalSince(startTime)
                        logFlight(start: startTime, duration: duration)
                        print("Simulated Flight Stopped")
                    }
                } else {
                    locationManager.stopUpdatingLocation()
                    print("Location monitoring stopped.")

                }
    }
    private func handleLocationUpdate(_ update: CLLocationUpdate) {
        if let location = update.location {
            print("Location: \(location.coordinate), Speed: \(location.speed) m/s")
            
            if let previousLocation = previousLocation {
                let distance = location.distance(from: previousLocation) / 1000 
                totalDistance += distance
            }
            previousLocation = location
            
            if location.speed > movementSpeedThreshold && isMicrophoneInputActive() {
                startFlightIfNeeded()
            } else if location.speed < movementSpeedThreshold && !isMicrophoneInputActive() {
                stopFlightIfNeeded()
            }
        }
        else {
        print ("not good")}
        if update.authorizationDenied {
            print("Location authorization denied.")
        }
    }
    func startMicrophoneMonitoring() {
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(.record, mode: .measurement, options: .duckOthers)
            try audioSession.setActive(true)
            audioRecorder = try AVAudioRecorder(url: FileManager.default.temporaryDirectory.appendingPathComponent("mic_input.caf"), settings: [
                AVFormatIDKey: Int(kAudioFormatAppleIMA4),
                AVSampleRateKey: 44100.0,
                AVNumberOfChannelsKey: 1,
                AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
            ])
            audioRecorder?.isMeteringEnabled = true
            audioRecorder?.record()
            Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
                self.checkMicrophoneInput()
                print("timer interrupt")
                Task {
                    do {
                        let stream = CLLocationUpdate.liveUpdates()
                        for try await update in stream {
                            self.handleLocationUpdate(update)
                        }
                    } catch {
                        print("Failed to receive location updates: \(error)")
                    }
                }
                
            }
        } catch {
            print("Failed to start microphone monitoring: \(error)")
        }
    }
    private func checkMicrophoneInput() {
            audioRecorder?.updateMeters()
            let averagePower = audioRecorder?.averagePower(forChannel: 0) ?? -160
            if averagePower > microphoneThreshold {
                startFlightIfNeeded()
            } else {
                stopFlightIfNeeded()
            }
    }
    func stopMicrophoneMonitoring() {
        audioRecorder?.stop()
    }
    private func startFlightIfNeeded() {
            if !isFlightActive {
                isFlightActive = true
                flightStartTime = Date()
                print("Flight started at \(flightStartTime!)")
            }
        }
    private func stopFlightIfNeeded() {
            if isFlightActive {
                isFlightActive = false
                if let startTime = flightStartTime {
                    let duration = Date().timeIntervalSince(startTime)
                    logFlight(start: startTime, duration: duration)
                }
            }
        }
    private func isMicrophoneInputActive() -> Bool {
        audioRecorder?.updateMeters()
        print("microphone is being tested")
        return audioRecorder?.averagePower(forChannel: 0) ?? -160 > microphoneThreshold
    }

    private func logFlight(start: Date, duration: TimeInterval) {
        let flight = Flight(start: start, duration: duration, distance: 0, altitudeFluctuations: 0)
        flights.append(flight)
        print("Flight logged: \(flight)")
    }
   func resetTracking() {
            flightStartTime = nil
            totalDistance = 0
            previousLocation = nil
    }
}
