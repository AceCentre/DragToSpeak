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
    case alphabeticalNoNumbers
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
        case .alphabeticalNoNumbers:
            return [["A", "B", "C", "D", "E"],
                    ["F", "G", "H", "I", "J"],
                    ["K", "L", "M", "N", "O"],
                    ["P", "Q", "R", "S", "T"],
                    ["U", "V", "W", "X", "Y"],
                    ["Z", "Space", "YES", "NO", "Delete"],
                    ["Thank you", "OK", "The", "Please", "Finish"]]
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
    // Persist
    @AppStorage("hasLaunchedBefore") var hasLaunchedBefore: Bool = false
    @AppStorage("layout") var layout: Layout = .alphabetical
    @AppStorage("writeWithoutSpacesEnabled") var writeWithoutSpacesEnabled: Bool = false
    @AppStorage("dwellTime") var dwellTime: Double = 0.5
    @AppStorage("showTrail") var showTrail: Bool = true
    @AppStorage("autocorrectEnabled") var autocorrectEnabled: Bool = true
    @AppStorage("enlargeKeys") var enlargeKeys: Bool = false
    @AppStorage("dragType") var dragType: DragType = .dwell
}
