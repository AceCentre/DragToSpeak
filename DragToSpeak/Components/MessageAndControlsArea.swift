//
//  MessageAndControlsArea.swift
//  DragToSpeak
//
//  Created by Gavin Henderson on 08/02/2024.
//

import SwiftUI

struct MessageAndControlsArea: View {
    @ObservedObject var messageController: MessageController
    
    var body: some View {
        HStack {
            ResponsiveStack {
                MessageBox(message: messageController.currentMessage)
                
                HStack {
                    Button(action: {
                        messageController.clearMessage()
                    }) {
                        Label("Clear", systemImage: "trash")
                    }.buttonStyle(.borderedProminent)
                    
                    SheetLink(destination: {
                        SettingsPage()
                    }, label: {
                        Label("Settings", systemImage: "gear")
                    })
                }
            }
            .padding()
        }.background(Color("background"))
    }
}
