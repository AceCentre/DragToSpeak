//
//  SheetLink.swift
//  DragToSpeak
//
//  Created by Gavin Henderson on 07/02/2024.
//

import SwiftUI

struct SheetLink<DestinationContent: View, LabelContent: View>: View {
    @ViewBuilder let destination: DestinationContent
    @ViewBuilder let label: LabelContent
    
    @State var openSheet: Bool = false
    
    var body: some View {
        Button(action: {
            openSheet = true
        }, label: {
            label
        }).sheet(isPresented: $openSheet) {
            destination
        }.buttonStyle(.borderedProminent)
    }
}
