//
//  AppSettings.swift
//  DragToSpeak
//
//  Created by Gavin Henderson on 07/02/2024.
//

import Foundation
import SwiftUI

class AppSettings: ObservableObject {
    // Persist
    @AppStorage("hasLaunchedBefore") var hasLaunchedBefore: Bool = false
    @AppStorage("layout") var layout: Layout = .alphabetical
    @AppStorage("writeWithoutSpacesEnabled") var writeWithoutSpacesEnabled: Bool = false
    @AppStorage("dwellTime") var dwellTime: Double = 0.5
    @AppStorage("showTrail") var showTrail: Bool = true
    @AppStorage("autocorrectEnabled") var autocorrectEnabled: Bool = true
    @AppStorage("enlargeKeys") var enlargeKeys: Bool = false
    @AppStorage("dragType") var dragType: DragType = .dwell
    @AppStorage("fontSize") var fontSize: Int = 10
    @AppStorage("finishOnDragEnd") var finishOnDragEnd: Bool = false
}
