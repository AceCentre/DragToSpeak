//
//  DwellProgress.swift
//  DragToSpeak
//
//  Created by Gavin Henderson on 07/02/2024.
//

import Foundation
import SwiftUI

struct DwellProgress: View {
    @ObservedObject var dwellController: DwellController
    @ObservedObject var appSettings: AppSettings
    
    @State var progressAmount: Double = 0.0
    
    let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        ProgressView(value: progressAmount, total: 100)
            .onReceive(timer, perform: { _ in
                if let dwellStartTime = dwellController.dwellStartTime {
                    let timeSinceStart = Date().timeIntervalSince1970 - dwellStartTime.timeIntervalSince1970
                    let progress = (timeSinceStart / appSettings.dwellTime) * 100
                                        
                    progressAmount = min(100, progress)
                } else {
                    progressAmount = 0
                }
            })
    }
}
