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
    }
    
    var type: CellType
    var displayText: String
    var speakText: String
    var messageText: String
    
    init(isDelete: Bool) {
        type = .delete
        displayText = "Delete"
        messageText = " "
        speakText = ""
    }
    
    init(isBlank: Bool) {
        type = .blank
        displayText = ""
        messageText = UUID().uuidString
        speakText = ""
    }
    
    init(isSpace: Bool) {
        type = .space
        displayText = "Space"
        messageText = " "
        speakText = ""
    }
    
    init(isFinish: Bool) {
        type = .finish
        displayText = "Finish"
        messageText = ""
        speakText = ""
    }
    
    init(letter: String) {
        displayText = letter.uppercased()
        speakText = letter.lowercased()
        messageText = letter.lowercased()
        type = .letter
    }
    
    init(word: String) {
        displayText = word
        speakText = word
        messageText = word
        type = .word
    }
}
