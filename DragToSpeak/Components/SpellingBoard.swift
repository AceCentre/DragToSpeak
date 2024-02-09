//
//  SpellingBoard.swift
//  DragToSpeak
//
//  Created by Gavin Henderson on 08/02/2024.
//

import SwiftUI

struct SpellingBoard: View {
    @EnvironmentObject var settings: AppSettings
    @EnvironmentObject var dwellController: DwellController
    @EnvironmentObject var gridController: GridController
    @EnvironmentObject var directionController: DirectionController
    @EnvironmentObject var messageController: MessageController
    
    @StateObject var trailController = TrailController()
    
    var body: some View {
        GeometryReader { reader in
            let cellHeight = reader.size.height / CGFloat(gridController.grid.count)
                        
            ZStack {
                VStack(spacing: 0) {
                    ForEach(gridController.grid, id: \.self) { row in
                        HStack(spacing: 0) {
                            ForEach(row, id: \.self) { cell in
                                let cellWidth = reader.size.width / CGFloat(row.count)
                                CellView(
                                    text: cell.displayText,
                                    isActive: gridController.activeCell == cell,
                                    isPending: gridController.pendingCell == cell,
                                    cellType: cell.type,
                                    cellWidth: cellWidth,
                                    cellHeight: cellHeight
                                )
                                
                            }
                        }
                    }
                }
                
                if settings.showTrail {
                    TrailView(trailController: trailController)
                }
            }
            .onAppear {
                gridController.updateSize(reader.size)
            }
            .onChange(of: reader.size) {
                gridController.updateSize(reader.size)
            }
            .gesture(
                DragGesture(minimumDistance: 0, coordinateSpace: .local)
                    .onChanged { value in
                        trailController.dragChange(value)
                        
                        if settings.dragType == .dwell {
                            dwellController.dragChange(value)
                        }
                        
                        if settings.dragType == .direction {
                            directionController.dragChange(value)
                        }
                    }
                    .onEnded { _ in
                        trailController.end()
                        if settings.dragType == .dwell {
                            dwellController.cancelDwell()
                        }
                        if settings.dragType == .direction {
                            directionController.cancelDirection()
                        }
                        gridController.resetCells()
                        
                        if settings.finishOnDragEnd {
                            messageController.finish()
                        }
                    }
                )
        }
    }
}
