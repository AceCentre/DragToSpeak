//
//  VoiceEngine.swift
//  DragToSpeak
//
//  Created by Gavin Henderson on 08/02/2024.
//

import Foundation
import AVKit

class VoiceEngine: ObservableObject {
    var speechSynthesiser: AVSpeechSynthesizer = AVSpeechSynthesizer()
    
    init() {
        // This makes it work in silent mode by setting the audio to playback
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .spokenAudio, options: .duckOthers)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("Failed to set audio session category. Error: \(error)")
        }
    }
    
    func speak(_ text: String) {
        let utterance = AVSpeechUtterance(string: text)
        speechSynthesiser.speak(utterance)
    }
}
