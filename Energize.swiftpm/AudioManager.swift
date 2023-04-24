//
//  AudioManager.swift
//  Energize
//
//  Created by Gustavo Munhoz Correa on 07/04/23.
//
import AVFoundation

class AudioManager {
    var audioRecorder: AVAudioRecorder?

    func requestMicrophonePermission(completion: @escaping (Bool) -> Void) {
        AVAudioSession.sharedInstance().requestRecordPermission { granted in
            completion(granted)
        }
    }
    
    func setupAudioRecorder() {
        let audioFilename = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("temp.m4a")
        let audioSession = AVAudioSession.sharedInstance()
        let settings: [String: Any] = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 44100.0,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.low.rawValue
        ]
        
        do {
            try audioSession.setCategory(.playAndRecord, options: [.defaultToSpeaker])
            try audioSession.setActive(true)
        } catch {
            print("Failed to set up audio session: \(error)")
        }
        
        do {
            audioRecorder = try AVAudioRecorder(url: audioFilename, settings: settings)
            audioRecorder?.prepareToRecord()
            audioRecorder?.isMeteringEnabled = true
            audioRecorder?.record()
        } catch {
            print("Error setting up the audio recorder: \(error.localizedDescription)")
        }
    }
    
    func getMicrophoneVolume() -> CGFloat {
        audioRecorder?.updateMeters()
        guard let volume = audioRecorder?.averagePower(forChannel: 0) else {
            return 0.0
        }
        return CGFloat(volume)
    }
    
    func volumeToRotationDegree(volume: CGFloat) -> CGFloat {
        let minVolume: CGFloat = -62.5
        let maxVolume: CGFloat = 0
        let minDegree: CGFloat = 0
        let maxDegree: CGFloat = 3.6

        let normalizedVolume = max(min(volume, maxVolume), minVolume)
        let degree = ((normalizedVolume - minVolume) * (maxDegree - minDegree) / (maxVolume - minVolume)) + minDegree

        return degree
    }
}
