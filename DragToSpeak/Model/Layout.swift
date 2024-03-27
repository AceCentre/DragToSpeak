//
//  Layout.swift
//  DragToSpeak
//
//  Created by Gavin Henderson on 07/02/2024.
//

import Foundation

enum SpacesColumn: Int {
    case left
    case right
    case none
}

enum Layout: Int {
    case alphabetical
    case alphabeticalNoNumbers
    case frequency
    case qwerty
    
    var grid: [[Cell]] {
        switch self {
            
       case .alphabetical:
            return [[Cell(letter:"A"), Cell(letter: "B"), Cell(letter: "C"), Cell(letter: "D"), Cell(letter: "E")],
                    [Cell(letter:"F"), Cell(letter: "G"), Cell(letter: "H"), Cell(letter: "I"), Cell(letter: "J")],
                    [Cell(letter:"K"), Cell(letter: "L"), Cell(letter: "M"), Cell(letter: "N"), Cell(letter: "O")],
                    [Cell(letter:"P"), Cell(letter: "Q"), Cell(letter: "R"), Cell(letter: "S"), Cell(letter: "T")],
                   [Cell(letter:"U"), Cell(letter: "V"), Cell(letter: "W"), Cell(letter: "X"), Cell(letter: "Y")],
                   [Cell(letter:"Z"), Cell(isSpace: true), Cell(word: "YES"), Cell(word: "NO"), Cell(isDelete: true)],
                    [Cell(word:"Thank you"), Cell(word: "OK"), Cell(word: "Please"), Cell(isClear: true), Cell(isFinish: true)],
                   [Cell(letter:"0"), Cell(letter: "1"), Cell(letter: "2"), Cell(letter: "3"), Cell(letter: "4")],
                   [Cell(letter:"5"), Cell(letter: "6"), Cell(letter: "7"), Cell(letter: "8"), Cell(letter: "9")]]
       case .alphabeticalNoNumbers:
           return [[Cell(letter:"A"), Cell(letter: "B"), Cell(letter: "C"), Cell(letter: "D"), Cell(letter: "E")],
                   [Cell(letter:"F"), Cell(letter: "G"), Cell(letter: "H"), Cell(letter: "I"), Cell(letter: "J")],
                   [Cell(letter:"K"), Cell(letter: "L"), Cell(letter: "M"), Cell(letter: "N"), Cell(letter: "O")],
                   [Cell(letter:"P"), Cell(letter: "Q"), Cell(letter: "R"), Cell(letter: "S"), Cell(letter: "T")],
                   [Cell(letter:"U"), Cell(letter: "V"), Cell(letter: "W"), Cell(letter: "X"), Cell(letter: "Y")],
                   [Cell(letter:"Z"), Cell(isSpace: true), Cell(word: "YES"), Cell(word: "NO"), Cell(isDelete: true)],
                   [Cell(word:"Thank you"), Cell(word: "OK"), Cell(word: "Please"), Cell(isClear: true),  Cell(isFinish: true)]]
       case .frequency:
           return  [[Cell(letter:" Z"), Cell(letter: "V"), Cell(letter: "C"), Cell(letter: "H"), Cell(letter: "W"), Cell(letter: "K")],
                    [Cell(letter:"F"), Cell(letter: "I"), Cell(letter: "T"), Cell(letter: "A"), Cell(letter: "L"), Cell(letter: "Y")],
                    [Cell(letter:""), Cell(isSpace: true), Cell(letter: "N"), Cell(letter: "E"), Cell(isDelete: true), Cell(isFinish: true)],
                    [Cell(letter:"G"), Cell(letter: "D"), Cell(letter: "O"), Cell(letter: "R"), Cell(letter: "S"), Cell(letter: "B")],
                    [Cell(letter:"Q"), Cell(letter: "J"), Cell(letter: "U"), Cell(letter: "M"), Cell(letter: "P"), Cell(letter: "X")],
                    [Cell(word:"Thank you"), Cell(word: "OK"), Cell(isClear: true), Cell(word: "Yes"), Cell(word: "NO"), Cell(word: "Please")],
                    [Cell(letter:"0"), Cell(letter: "1"), Cell(letter: "2"), Cell(letter: "3"), Cell(letter: "4"), Cell(isBlank: true)],
                    [Cell(letter:"5"), Cell(letter: "6"), Cell(letter: "7"), Cell(letter: "8"), Cell(letter: "9"), Cell(isBlank: true)]]
       case .qwerty:
           return [[Cell(word:"All done"), Cell(word: "Thanks"), Cell(word: "Can you help me"), Cell(isBlank: true), Cell(isBlank: true)],
                   [Cell(letter:"1"), Cell(letter: "2"), Cell(letter: "3"), Cell(letter: "4"), Cell(letter: "5"), Cell(letter: "6"), Cell(letter: "7"), Cell(letter: "8"), Cell(letter: "9"), Cell(letter: "0")],
                   [Cell(letter:"Q"), Cell(letter: "W"), Cell(letter: "E"), Cell(letter: "R"), Cell(letter: "T"), Cell(letter: "Y"), Cell(letter: "U"), Cell(letter: "I"), Cell(letter: "O"), Cell(letter: "P")],
                   [Cell(letter:"A"), Cell(letter: "S"), Cell(letter: "D"), Cell(letter: "F"), Cell(letter: "G"), Cell(letter: "H"), Cell(letter: "J"), Cell(letter: "K"), Cell(letter: "L"), Cell(word: "Some word")],
                   [Cell(letter:"Z"), Cell(letter: "X"), Cell(letter: "C"), Cell(letter: "V"), Cell(letter: "B"), Cell(letter: "N"), Cell(letter: "M"), Cell(isBlank: true), Cell(letter: "?"), Cell(word: "I need the toilet")],
                   [Cell(isFinish: true), Cell(isSpace: true), Cell(isDelete: true), Cell(isClear: true)]]

    }
}
}
