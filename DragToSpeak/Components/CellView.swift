//
//  CellView.swift
//  DragToSpeak
//
//  Created by Gavin Henderson on 08/02/2024.
//

import SwiftUI

struct CellView: View {
    var text: String
    var isActive: Bool
    var isPending: Bool
    var cellType: Cell.CellType
    var cellWidth: CGFloat
    var cellHeight: CGFloat

    @EnvironmentObject var appSettings: AppSettings
    
    var body: some View {        
        let fontSize = isPending ? appSettings.enlargeKeys ? 50 : appSettings.fontSize : appSettings.fontSize
        
        Text(text)
            .frame(width: cellWidth, height: cellHeight)
            .border(.black)
            .background(isActive ? .green : isPending ? .yellow.opacity(0.5) : cellType == .finish ? .green.opacity(0.5) : cellType == .space ? .blue.opacity(0.5) : .white) // This line is crazy, dont ask
            .font(.system(size: CGFloat(fontSize)))
    }
}
