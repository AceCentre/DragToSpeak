//
//  OnboardingView.swift
//  DragToSpeak
//
//  Created by Will Wade on 26/01/2024.
//
import SwiftUI
import AVFoundation
import AVKit

struct OnboardingView: View {
    @EnvironmentObject var settings: AppSettings
    
    private var player: AVPlayer {
        let videoName = UIDevice.current.orientation.isLandscape ? "LandscapeVideo" : "PortraitVideo"
        if let url = Bundle.main.url(forResource: videoName, withExtension: "mp4") {
            return AVPlayer(url: url)
        } else {
            fatalError("Video file not found \(videoName).mp4")
        }
    }
    
    
    var body: some View {
        VStack {
            VideoPlayer(player: player)
                .onAppear {
                    player.play()
                }
            Button("Continue") {
                settings.hasLaunchedBefore = true
            }
        }
    }
}
