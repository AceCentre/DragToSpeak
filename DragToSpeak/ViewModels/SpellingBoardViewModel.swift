//
//  SpellingBoardViewModel.swift
//  DragToSpeak
//
//  Created by Will Wade on 26/01/2024.
//
import SwiftUI

enum DragType: Int {
    case direction = 1
    case dwell = 2
}


enum Layout: Int {
    case alphabetical
    case frequency
    case qwerty
    
    var rows: [[String]] {
        switch self {
        case .alphabetical:
            return [["A", "B", "C", "D", "E"],
            ["F", "G", "H", "I", "J"],
            ["K", "L", "M", "N", "O"],
            ["P", "Q", "R", "S", "T"],
            ["U", "V", "W", "X", "Y"],
            ["Z", "Space", "YES", "NO", "Delete"],
            ["Thank you", "OK", "The", "Please", "Finish"],
            ["0", "1", "2", "3", "4"],
            ["5", "6", "7", "8", "9"]]
        case .frequency:
            return  [[" Z", "V", "C", "H", "W", "K"],
            ["F", "I", "T", "A", "L", "Y"],
            [" ", "Space", "N", "E", "Delete", "Finish"],
            ["G", "D", "O", "R", "S", "B"],
            ["Q", "J", "U", "M", "P", "X"],
            ["Thank you", "OK", "The", "Yes", "NO", "Please"],
            ["0", "1", "2", "3", "4", " "],
            ["5", "6", "7", "8", "9", " "]]
        case .qwerty:
            return [["All done", "Thanks", "Can you help me", "", ""],
            ["1", "2", "3", "4", "5", "6", "7", "8", "9", "0"],
            ["Q", "W", "E", "R", "T", "Y", "U", "I", "O", "P"],
            ["A", "S", "D", "F", "G", "H", "J", "K", "L", "Some word"],
            ["Z", "X", "C", "V", "B", "N", "M", "", "?", "I need the toilet"],
            ["Finish", "Space", "Delete"]]
        }
    }
}



class AppSettings: ObservableObject {
    @Published var layout: Layout = .alphabetical
    @Published var writeWithoutSpacesEnabled: Bool = false
    @Published var dwellTime: Double = 0.5
    @Published var showTrail: Bool = true
    @Published var autocorrectEnabled: Bool = true
    @Published var hasLaunchedBefore: Bool = false
    @Published var enlargeKeys: Bool = false
    @Published var dragType: DragType = .dwell
    @State var settingsOpen = false
}
