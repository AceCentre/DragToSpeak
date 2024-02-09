//
//  ResponsiveStack.swift
//  DragToSpeak
//
//  Created by Gavin Henderson on 08/02/2024.
//

import SwiftUI

struct ResponsiveStack<Content: View>: View {
    @ViewBuilder let content: Content
    
    @Environment(\.horizontalSizeClass) var horizontalSizeClass: UserInterfaceSizeClass?

    var body: some View {
        if horizontalSizeClass == .compact {
            VStack {
                content
            }
        } else {
            HStack {
                content
            }
        }
    }
}
