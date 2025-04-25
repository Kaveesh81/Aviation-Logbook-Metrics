//
//  FlightLocationManager.swift
//  AviationLogbook
//
//  Created by Kaveesh Passari on 12/3/24.
//
import Foundation
import CoreLocation

class FlightLocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published var authorizationStatus: CLAuthorizationStatus = .notDetermined
    @Published var totalDistance: Double = 0

    private var locationManager: CLLocationManager
    private var lastLocation: CLLocation?

    override init() {
        locationManager = CLLocationManager()
        super.init()
        locationManager.delegate = self
    }

    func requestAuthorization() {
        locationManager.requestWhenInUseAuthorization()
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        authorizationStatus = manager.authorizationStatus
        if authorizationStatus == .authorizedWhenInUse || authorizationStatus == .authorizedAlways {
            locationManager.startUpdatingLocation()
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let currentLocation = locations.last else { return }
        if let lastLocation = lastLocation {
            let distance = currentLocation.distance(from: lastLocation) / 1000 // Convert to kilometers
            totalDistance += distance
        }
        lastLocation = currentLocation
    }
}
