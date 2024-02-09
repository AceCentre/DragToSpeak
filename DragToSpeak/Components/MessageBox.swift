//
//  MessageBox.swift
//  DragToSpeak
//
//  Created by Gavin Henderson on 08/02/2024.
//

import Foundation
import SwiftUI

struct MessageBox: View {
    var message: String
    
    var body: some View {
        HStack {
            if message == "" {
                Text("Start dragging to enter your message")
                    .frame(minHeight: 23)
                    .foregroundStyle(Color(.systemGray))
            } else {
                Text(message)
                    .frame(minHeight: 23)
            }
            Spacer()
        }
        .padding()
        .background(Color("textBar").clipShape(RoundedRectangle(cornerRadius:20)))

    }
}
