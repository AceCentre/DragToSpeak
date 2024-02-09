//
//  TrailView.swift
//  DragToSpeak
//
//  Created by Gavin Henderson on 07/02/2024.
//

import Foundation
import SwiftUI

struct TrailView: View {
    @ObservedObject var trailController: TrailController
        
    var body: some View {
        Path { path in
            let dragPoints = trailController.dragPoints
                        
            if let initialDragPoint = dragPoints.first, dragPoints.count >= 2 {
                path.move(to: initialDragPoint)
                
                for point in dragPoints {
                    path.addLine(to: point)
                }
            }
        }
        .stroke(.blue, style: StrokeStyle(lineWidth: 10, lineCap: .round, lineJoin: .round))
    }
}
