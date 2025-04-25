//
//  AudioRecorder.swift
//  AviationLogbook
//
//  Created by Kaveesh Passari on 12/3/24.
//

import Foundation
import AVFoundation

class AudioRecorder {
    private var audioSession: AVAudioSession!
    private var audioRecorder: AVAudioRecorder?

    // Set up the audio session
    func setupAudioSession() {
        audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(.playAndRecord, options: [.defaultToSpeaker, .allowBluetooth])
            try audioSession.setActive(true)
            enableBuiltInMic()
        } catch {
            fatalError("Failed to configure and activate session.")
        }
    }

    // Enable the built-in microphone
    private func enableBuiltInMic() {
        guard let availableInputs = audioSession.availableInputs,
              let builtInMicInput = availableInputs.first(where: { $0.portType == .builtInMic }) else {
            print("The device must have a built-in microphone.")
            return
        }

        do {
            try audioSession.setPreferredInput(builtInMicInput)
        } catch {
            print("Unable to set the built-in mic as the preferred input.")
        }
    }

    // Start recording
    func startRecording() {
        let recordingURL = FileManager.default.temporaryDirectory.appendingPathComponent("flight_audio.m4a")
        let settings: [String: Any] = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 44100.0,
            AVNumberOfChannelsKey: 2,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]

        do {
            audioRecorder = try AVAudioRecorder(url: recordingURL, settings: settings)
            audioRecorder?.prepareToRecord()
            audioRecorder?.record()
            print("Recording started at \(recordingURL)")
        } catch {
            print("Failed to start recording: \(error)")
        }
    }

    // Stop recording
    func stopRecording() {
        audioRecorder?.stop()
        audioRecorder = nil
        print("Recording stopped.")
    }
}




    
