//
//  DirectionController.swift
//  DragToSpeak
//
//  Created by Gavin Henderson on 08/02/2024.
//

import Foundation
import SwiftUI

class DirectionController: ObservableObject {
    var messageController: MessageController?
    var gridController: GridController?

    var dragPoints: [CGPoint] = []
    
    var lastDirection: CGVector?
    
    // 20 Degrees in radians
    let angleThreshold = 20 * Double.pi / 180
    
    var lastCell: Cell? = nil
    
    func dragChange(_ value: DragGesture.Value) {
        dragPoints.append(value.location)
    
        if let unwrappedGridController = gridController {
            
            if let cell = unwrappedGridController.getCellAtPoint(value.location) {
                
                if cell != lastCell {
                    unwrappedGridController.setPending(cell)
                    lastCell = nil
                }
                
                guard dragPoints.count >= 2 else { return }
                guard let latestPoint = dragPoints.last else { return }
                guard let previousPoint = dragPoints[safe: dragPoints.count - 2] else { return }
                
                let newDirection = calculateDirection(from: previousPoint, to: latestPoint)
                
                if let unwrappedLastDirection = lastDirection {
                    let angleChange = angleBetween(v1: unwrappedLastDirection, v2: newDirection)
                    
                    if angleChange > angleThreshold {
                        if lastCell != cell {
                            lastCell = cell
                            unwrappedGridController.selectCell(cell)
                        }
                    }
                    
                    
                }
                
                lastDirection = newDirection
            }
        }
        
        
        
        
    }
    
    func loadMessageController(_ messageController: MessageController) {
        self.messageController = messageController
    }
    
    func loadGridController(_ gridController: GridController) {
        self.gridController = gridController
    }
    
    func cancelDirection() {
        lastDirection = nil
    }
    
    func angleBetween(v1: CGVector, v2: CGVector) -> CGFloat {
        let dotProduct = v1.dx * v2.dx + v1.dy * v2.dy
        let magnitudeV1 = sqrt(v1.dx * v1.dx + v1.dy * v1.dy)
        let magnitudeV2 = sqrt(v2.dx * v2.dx + v2.dy * v2.dy)
        return acos(dotProduct / (magnitudeV1 * magnitudeV2))
    }
    
    func calculateDirection(from: CGPoint, to: CGPoint) -> CGVector {
        let dx = to.x - from.x
        let dy = to.y - from.y
        return CGVector(dx: dx, dy: dy)
    }
    
}
