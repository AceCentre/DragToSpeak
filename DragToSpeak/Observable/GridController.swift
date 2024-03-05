//
//  GridController.swift
//  DragToSpeak
//
//  Created by Gavin Henderson on 08/02/2024.
//

import Foundation

class GridController: ObservableObject {
    @Published var grid: [[Cell]] = []
    @Published var size: CGSize?
    @Published var pendingCell: Cell?
    @Published var activeCell: Cell?
    
    var voiceEngine: VoiceEngine?
    var messageController: MessageController?
    var appSettings: AppSettings?
    
    func setLayout(_ layout: Layout) {
        let spacesColumn = appSettings?.spacesColumn ?? .none
        
        var newGrid: [[Cell]] = []
        
        for row in layout.grid {
            let spaceCell = Cell(isSpace: true, widthModifier: 0.5)
            
            if spacesColumn == .left {
                newGrid.append([spaceCell] + row)
            } else if spacesColumn == .right {
                newGrid.append(row + [spaceCell])
            } else {
                newGrid.append(row)
            }
            
        }
        
        grid = newGrid
        
        
    }
    
    func resetCells() {
        pendingCell = nil
        activeCell = nil
    }
    
    func setPending(_ cell: Cell) {
        activeCell = nil
        pendingCell = cell
    }
    
    func selectCell(_ cell: Cell) {
        activeCell = cell
        pendingCell = nil
        
        if
            let unwrappedMessageController = messageController,
            let unwrappedVoiceEngine = voiceEngine
        {
            if cell.type == .letter {
                unwrappedVoiceEngine.speak(cell.speakText)
                unwrappedMessageController.currentMessage += cell.messageText
            } else if cell.type == .word {
                unwrappedVoiceEngine.speak(cell.speakText)
                
                if unwrappedMessageController.currentMessage == "" {
                    unwrappedMessageController.currentMessage = cell.messageText + " "
                } else {
                    unwrappedMessageController.currentMessage = unwrappedMessageController.currentMessage.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines) + " " + cell.messageText + " "
                }
                
            } else if cell.type == .space {
                unwrappedMessageController.currentMessage = unwrappedMessageController.currentMessage.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines) + " "
            } else if cell.type == .finish {
                unwrappedMessageController.finish()
            } else if cell.type == .delete {
                unwrappedMessageController.currentMessage = String(unwrappedMessageController.currentMessage.dropLast())
            }

        }
        
    }
    
    func loadMessageController(_ messageController: MessageController) {
        self.messageController = messageController
    }
    
    func loadVoiceEngine(_ voiceEngine: VoiceEngine) {
        self.voiceEngine = voiceEngine
    }
    
    func loadAppSettings(_ appSettings: AppSettings) {
        self.appSettings = appSettings
    }
    
    func updateSize(_ size: CGSize) {
        self.size = size
    }
    
    func getCellAtPoint(_ point: CGPoint) -> Cell? {
        guard let unwrappedSize = size else {
            return nil
        }
        
        let rowHeight = unwrappedSize.height / CGFloat(grid.count)
        let rowIndex = Int(point.y / rowHeight)
        
        guard let targetRow = grid[safe: rowIndex] else {
            return nil
        }
        
        let totalRowWidth: Double = targetRow.reduce(0, { current, currentCell in
            return current + currentCell.widthModifier
        })
        
        var currentX = 0.0
        for currentCell in targetRow {
            let cellWidth = (unwrappedSize.width / totalRowWidth) * currentCell.widthModifier
            currentX += cellWidth
            
            if point.x < currentX {
                return currentCell
            }
        }
            
        return nil
    }
}
