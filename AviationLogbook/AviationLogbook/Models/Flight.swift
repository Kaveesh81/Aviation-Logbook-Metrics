//
//  Flight.swift
//  AviationLogbook
//
//  Created by Kaveesh Passari on 12/3/24.
//
import Foundation

struct Flight: Identifiable {
    let id = UUID()
    let start: Date
    let duration: TimeInterval
    let distance: Double // In kilometers
    let altitudeFluctuations: Double // In meters
}

