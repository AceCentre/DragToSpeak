//
//  DragToSpeakApp.swift
//  DragToSpeak
//
//  Created by Will Wade on 21/11/2023.
//

import SwiftUI

@main
struct DragToSpeakApp: App {
    @StateObject var settings = AppSettings()
    
    var body: some Scene {
        WindowGroup {
            if settings.hasLaunchedBefore {
                SpellingBoardPage()
                    .environmentObject(settings)
            } else {
                OnboardingPage(hasLaunchedBefore: $settings.hasLaunchedBefore)
            }
            
        }
    }
}
