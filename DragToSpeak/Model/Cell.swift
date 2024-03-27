//
//  Cell.swift
//  DragToSpeak
//
//  Created by Gavin Henderson on 08/02/2024.
//

import Foundation

struct Cell: Equatable, Hashable {
    enum CellType {
        case letter
        case word
        case space
        case finish
        case delete
        case blank
        case clear
    }
    
    var type: CellType
    var displayText: String
    var speakText: String
    var messageText: String
    var widthModifier: Double
    
    init(isClear: Bool) {
        type = .clear
        displayText = "Clear"
        messageText = ""
        speakText = ""
        widthModifier = 1
    }
    
    init(isDelete: Bool) {
        type = .delete
        displayText = "Delete"
        messageText = " "
        speakText = ""
        widthModifier = 1
    }
    
    init(isBlank: Bool) {
        type = .blank
        displayText = ""
        messageText = UUID().uuidString
        speakText = ""
        widthModifier = 1
    }
    
    init(isSpace: Bool) {
        type = .space
        displayText = "Space"
        messageText = " "
        speakText = ""
        widthModifier = 1
    }
    
    init(isSpace: Bool, widthModifier: Double) {
        type = .space
        displayText = "Space"
        messageText = " "
        speakText = ""
        self.widthModifier = widthModifier
    }
    
    init(isFinish: Bool) {
        type = .finish
        displayText = "Finish"
        messageText = ""
        speakText = ""
        widthModifier = 1
    }
    
    init(letter: String) {
        displayText = letter.uppercased()
        speakText = letter.lowercased()
        messageText = letter.lowercased()
        type = .letter
        widthModifier = 1
    }
    
    init(word: String) {
        displayText = word
        speakText = word
        messageText = word
        type = .word
        widthModifier = 1
    }
}
