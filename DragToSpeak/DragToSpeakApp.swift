//
//  DragToSpeakApp.swift
//  DragToSpeak
//
//  Created by Will Wade on 21/11/2023.
//

import SwiftUI

@main
struct DragToSpeakApp: App {
    var settings = AppSettings()
    var body: some Scene {
        WindowGroup {
            SpellingBoardView()
                .environmentObject(settings)
        }
    }
}
