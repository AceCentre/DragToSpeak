//
//  TrailController.swift
//  DragToSpeak
//
//  Created by Gavin Henderson on 07/02/2024.
//

import Foundation
import SwiftUI

class TrailController: ObservableObject {
    @Published var dragPointsWithTimeStamps: [TimeStampedPoints] = []
    @Published var dragPoints: [CGPoint] = []
    
    func dragChange(_ value: DragGesture.Value) {
        let newPoint = TimeStampedPoints(value.location)
        dragPointsWithTimeStamps = dragPointsWithTimeStamps + [newPoint]
                
        dragPointsWithTimeStamps = dragPointsWithTimeStamps.filter { point in
            let now = Date().timeIntervalSince1970
            let timeBetween = now - point.timestamp
            return timeBetween < 1
        }
        
        dragPoints = dragPointsWithTimeStamps.map { currentPoint in
            return currentPoint.point
        }
    }
    
    func end() {
        dragPoints = []
        dragPointsWithTimeStamps = []
    }
    
    struct TimeStampedPoints {
        var point: CGPoint
        var timestamp: Double
        
        init(_ point: CGPoint) {
            self.point = point
            timestamp = Date().timeIntervalSince1970
        }
    }

}
