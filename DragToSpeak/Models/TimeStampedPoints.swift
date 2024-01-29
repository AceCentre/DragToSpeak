//
//  TimeStampedPoints.swift
//  DragToSpeak
//
//  Created by Will Wade on 26/01/2024.
//

import UIKit

class TimeStampedPoints {
    var point: CGPoint
    var timestamp: Double
    
    init(_ point: CGPoint) {
        self.point = point
        timestamp = Date().timeIntervalSince1970
    }
}
