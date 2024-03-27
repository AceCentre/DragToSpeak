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
    @Environment(\.colorScheme) var colorScheme // Add this line to detect color scheme
    
    var body: some View {
        let fontSize = isPending ? appSettings.enlargeKeys ? 50 : appSettings.fontSize : appSettings.fontSize
        
        Text(text)
            .frame(width: cellWidth, height: cellHeight)
            .border(.black)
            .background(backgroundColor) // Adjusted to use colorScheme
            .foregroundColor(foregroundColor) // Adjusted to use colorScheme
            .font(.system(size: CGFloat(fontSize)))
    }

    // Adjusted to consider color scheme for background color
    private var backgroundColor: Color {
        let baseColor: Color
        if isActive {
            baseColor = .green
        } else if isPending {
            baseColor = .yellow.opacity(0.5)
        } else {
            switch cellType {
            case .finish:
                baseColor = .green.opacity(0.5)
            case .space:
                baseColor = .blue.opacity(0.5)
            case .clear:
                baseColor = .red.opacity(0.5)
            default:
                baseColor = .white
            }
        }
        
        // Adjust baseColor for dark mode if necessary
        return colorScheme == .dark ? baseColor.opacity(0.5) : baseColor // Example adjustment
    }

    // Adjusted to consider color scheme for foreground color
    private var foregroundColor: Color {
        switch backgroundColor {
        case .green, .blue, .yellow:
            return colorScheme == .dark ? .white : .black // Adjust based on color scheme
        default:
            return colorScheme == .dark ? .white : .primary // Adjust for dark mode
        }
    }
}
