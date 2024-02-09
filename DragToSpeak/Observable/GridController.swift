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
    
    func setLayout(_ layout: Layout) {
        grid = layout.grid
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
        
        let columnWidth = unwrappedSize.width / CGFloat(targetRow.count)
        
        let columnIndex = Int(point.x / columnWidth)
        
        let cell = targetRow[safe: columnIndex]
            
        return cell
    }
}
