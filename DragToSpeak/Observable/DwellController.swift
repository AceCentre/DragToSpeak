//
//  DwellController.swift
//  DragToSpeak
//
//  Created by Gavin Henderson on 08/02/2024.
//

import SwiftUI

class DwellController: ObservableObject {
    var appSettings: AppSettings?
    var messageController: MessageController?
    var gridController: GridController?
    
    @Published var dwellStartTime: Date? = nil
    @Published var dwellWorkItem: DispatchWorkItem?
    @Published var currentlyDwellingCell: Cell?
        
    func loadMessageController(_ messageController: MessageController) {
        self.messageController = messageController
    }
    
    func loadAppSettings(_ appSettings: AppSettings) {
        self.appSettings = appSettings
    }
    
    func loadGridController(_ gridController: GridController) {
        self.gridController = gridController
    }
    
    func cancelDwell() {
        currentlyDwellingCell = nil
        dwellWorkItem?.cancel()
        dwellStartTime = nil
    }
    
    func dragChange(_ point: DragGesture.Value) {
        if
            let unwrappedGridController = gridController,
            let unwrappedAppSettings = appSettings
        {
            if let cell = unwrappedGridController.getCellAtPoint(point.location) {
                if cell != currentlyDwellingCell {
                    dwellWorkItem?.cancel()
                    dwellStartTime = Date()
                    
                    currentlyDwellingCell = cell
                    unwrappedGridController.setPending(cell)
                    
                    let newWorkItem = DispatchWorkItem(block: {
                        unwrappedGridController.selectCell(cell)
                    })
                    
                    dwellWorkItem = newWorkItem
                    DispatchQueue.main.asyncAfter(deadline: .now() + unwrappedAppSettings.dwellTime, execute: newWorkItem)
                }
            }
        }
    }
}
