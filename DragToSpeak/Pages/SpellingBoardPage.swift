//
//  SpellingBoardView.swift
//  DragToSpeak
//
//  Created by Will Wade on 26/01/2024.
//
import SwiftUI
import AVFoundation
import AVKit

struct SpellingBoardPage: View {
    @StateObject var voiceEngine = VoiceEngine()
    @StateObject var messageController = MessageController()
    @StateObject var dwellController = DwellController()
    @StateObject var gridController = GridController()
    @StateObject var directionController = DirectionController()
    @StateObject var logger = LogHistory()
    
    @EnvironmentObject var settings: AppSettings
    
    var body: some View {
        VStack(spacing: 0) {
            MessageAndControlsArea(messageController: messageController)
            
            if settings.dragType == .dwell {
                DwellProgress(dwellController: dwellController, appSettings: settings)
            }
            
            SpellingBoard()
        }.onAppear {
            dwellController.loadMessageController(messageController)
            dwellController.loadAppSettings(settings)
            dwellController.loadGridController(gridController)
            
            directionController.loadGridController(gridController)
            directionController.loadMessageController(messageController )
            
            gridController.loadAppSettings(settings)
            gridController.setLayout(settings.layout)
            gridController.loadMessageController(messageController)
            gridController.loadVoiceEngine(voiceEngine)
            
            messageController.loadVoiceEngine(voiceEngine)
            messageController.loadAppSettings(settings)
            messageController.loadLogger(logger)
        }
        .onChange(of: settings.layout) {
            gridController.setLayout(settings.layout)
        }
        .onChange(of: settings.spacesColumn) {
            gridController.setLayout(settings.layout)
        }
        .environmentObject(dwellController)
        .environmentObject(gridController)
        .environmentObject(directionController)
        .environmentObject(messageController)
        .environmentObject(logger)
    }
}

struct SpellingBoardView_Previews: PreviewProvider {
    static var previews: some View {
        SpellingBoardPage()
            .environmentObject(AppSettings()) // Provide AppSettings for previews
    }
}
