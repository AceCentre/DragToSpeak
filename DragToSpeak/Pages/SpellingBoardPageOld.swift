//
//  SpellingBoardPageOld.swift
//  DragToSpeak
//
//  Created by Gavin Henderson on 07/02/2024.
//

import Foundation
import SwiftUI
import AVKit

//struct SpellingBoardViewOld: View {
//    @EnvironmentObject var settings: AppSettings
//    @State private var showingSettings = false
//    
//    @State private var formedWord = ""
//    @State private var completedDwellCell: (row: Int, column: Int)? = nil
//    @State private var currentSentence = ""
//    @State private var hoveredButton: (row: Int, column: Int)? = nil
//
//    
//    @State private var dragPoints: [CGPoint] = []
//    // @State private var dragPointsWithTimeStamps: [TimeStampedPoints] = []
//    @State private var lastDirection: CGVector?
//    let angleThreshold = 20 * Double.pi / 180 // Convert 20 degrees to radians
//    
//    let dwellDuration = 0.5 // 0.5 seconds dwell time
//    @State private var dwellStartTime: Date? = nil
//    @State private var hoveredCell: (row: Int, column: Int)? = nil
//    
//    let speechSynthesizer = AVSpeechSynthesizer()
//    
//    @State var currentlyDwellingCell: (row: Int, column: Int)?
//    @State var dwellWorkItem: DispatchWorkItem?
//    @State var dwellCellSelecteced = false
//    
//    @State private var progressAmount = 0.0
//    let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
//
//    init() {
//        // This makes it work in silent mode by setting the audio to playback
//        do {
//            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .spokenAudio, options: .duckOthers)
//            try AVAudioSession.sharedInstance().setActive(true)
//        } catch {
//            print("Failed to set audio session category. Error: \(error)")
//        }
//    }
//
//    var body: some View {
//        if settings.hasLaunchedBefore {
//            VStack(spacing: 0) {
//                HStack {
//                    // Sentence display row
//                    // We dont ever want to display1 an empty string because that causes the line height to jump about
//                    // There is probably a better way to do this
//                    Text(currentSentence + formedWord)
//                        .frame(minHeight: 44)
//                        .frame(maxWidth: .infinity, alignment: .leading)
//                        .padding()
//                        .background(Color.gray.opacity(0.2))
//                        .border(Color(UIColor.separator))
//                        .layoutPriority(1) // Ensures the text field expands
//                    
//                    Spacer()
//                    
//                    // Buttons for additional functions
//                    Button(action: clearMessage) {
//                        Image(systemName: "trash")
//                    }
//                    /*
//                     Button(action: deleteLastCharacter) {
//                     Image(systemName: "delete.left")
//                     }
//                     Button(action: speakMessage) {
//                     Image(systemName: "speaker.wave.2")
//                     }
//                     */
//                    Button(action: {
//                        showingSettings = true
//                    }) {
//                        Image(systemName: "gear")
//                    }.padding(.trailing)
//                }
//                .sheet(isPresented: $showingSettings) {
//                    // SettingsView(settingsOpen: $showingSettings) // Pass the binding here
//                }
//                if settings.dragType == .dwell {
//                    ProgressView(value: progressAmount, total: 100)
//                        .onReceive(timer) { _ in
//                            // Ensure dwellTime is within a reasonable range
//                            guard settings.dwellTime > 0.05 else { return } // Example minimum dwell time
//                            
//                            if dwellWorkItem != nil {
//                                let current = 100 / (settings.dwellTime / 0.1)
//                                progressAmount = min(100, progressAmount + current)
//                            }
//                        }
//                    
//                }
//                GeometryReader { geometry in
//                    ZStack {
//                        VStack(spacing: 0) {
//                            ForEach(0..<settings.layout.rows.count, id: \.self) { rowIndex in
//                                HStack(spacing: 0) {
//                                    ForEach(settings.layout.rows[rowIndex].indices, id: \.self) { columnIndex in
//                                        let letter = settings.layout.rows[rowIndex][columnIndex]
//                                        Text(letter)
//                                            .scaleEffect((self.isHovered(row: rowIndex, column: columnIndex) && settings.enlargeKeys) ? 3 : 1.0)
//                                            .frame(width: self.keyWidth(for: rowIndex, in: geometry.size),
//                                                   height: geometry.size.height / CGFloat(settings.layout.rows.count))
//                                            .background(self.determineBackgroundColor(row: rowIndex, column: columnIndex))
//                                            .border(Color(UIColor.separator))
//                                    }
//                                }
//                            }
//                        }
//
//                    }
//                    .gesture(
//                        DragGesture(minimumDistance: 0, coordinateSpace: .local)
//                            .onChanged { value in
//                                if settings.dragType == .direction {
//                                    dragPoints.append(value.location)
//                                    // dragPointsWithTimeStamps.append(TimeStampedPoints(value.location))
//                                    selectLetter(value.location, gridSize: geometry.size) // Call the function to select the letter
//                                    processDragForLetterSelection(gridSize: geometry.size)
//                                }
//                                
//                                if settings.dragType == .dwell {
//                                    dragPoints.append(value.location)
//                                    // dragPointsWithTimeStamps.append(TimeStampedPoints(value.location))
//                                    
//                                    let cell = determineCell(at: value.location, gridSize: geometry.size)
//                                    
//                                    if let unwrappedCurrent = currentlyDwellingCell {
//                                        if unwrappedCurrent != cell {
//                                            // We have moved over into a new cell so start timer
//                                            currentlyDwellingCell = cell
//                                            cancelDwellTimer()
//                                            startDwellTimer()
//                                        }
//                                    } else {
//                                        // There was no cell stored so lets clear and start timer
//                                        currentlyDwellingCell = cell
//                                        cancelDwellTimer()
//                                        startDwellTimer()
//                                    }
//                                }
//                                
//                                if settings.enlargeKeys {
//                                    let cell = determineCell(at: value.location, gridSize: geometry.size)
//                                    hoveredButton = cell // Update hovered button only if the setting is enabled
//                                }
//                            }
//                            .onEnded { _ in
//                                if settings.dragType == .direction {
//                                    self.speakMessage(self.formedWord)
//                                    //self.currentSentence += formedWord + " "
//                                    //self.formedWord = "" // Reset for next word
//                                    self.dragPoints.removeAll()
//                                    // self.dragPointsWithTimeStamps.removeAll()
//                                    
//                                    self.lastDirection = nil // Reset the last direction on gesture end
//                                }
//                                
//                                if settings.dragType == .dwell {
//                                    // Cancell dwell timer
//                                    currentlyDwellingCell = nil
//                                    cancelDwellTimer()
//                                    
//                                    self.speakMessage(self.formedWord)
//                                    //self.currentSentence += " "
//                                    //self.formedWord = "" // Reset for next word
//                                    self.dragPoints.removeAll()
//                                    // self.dragPointsWithTimeStamps.removeAll()
//                                    self.lastDirection = nil // Reset the last direction on gesture end
//                                    
//                                }
//                                
//                                if settings.enlargeKeys {
//                                    hoveredButton = nil // Reset hovered button
//                                }
//                            }
//                        
//                    )
//                }
//            }
//        } else {
//            OnboardingView(hasLaunchedBefore: settings.$hasLaunchedBefore)
//        }
//    }
//    
//    func isHovered(row: Int, column: Int) -> Bool {
//        return hoveredButton?.row == row && hoveredButton?.column == column
//    }
//    
//    func keyWidth(for row: Int, in size: CGSize) -> CGFloat {
//        let numberOfKeysInRow = CGFloat(settings.layout.rows[row].count)
//        return size.width / numberOfKeysInRow
//    }
//    
//    func startDwellTimer() {
//        let newWorkItem = DispatchWorkItem(block: {
//            if let currentCell = currentlyDwellingCell {
//                dwellCellSelecteced = true
//                selectCell(currentCell)
//            }
//            
//        })
//        
//        dwellWorkItem = newWorkItem
//        DispatchQueue.main.asyncAfter(deadline: .now() + settings.dwellTime, execute: newWorkItem)
//    }
//    
//    func cancelDwellTimer() {
//        if let unwrappedWorkItem = dwellWorkItem {
//            unwrappedWorkItem.cancel()
//            dwellWorkItem = nil
//        }
//        dwellCellSelecteced = false
//        progressAmount = 0.0
//    }
//    
//    func determineLetter(at point: CGPoint, gridSize: CGSize) -> String {
//        // Calculate the dimensions of each cell
//        let cellWidth = gridSize.width / CGFloat(settings.layout.rows[0].count)
//        let cellHeight = gridSize.height / CGFloat(settings.layout.rows.count)
//        
//        // Calculate the row and column based on the touch point
//        let column = Int(point.x / cellWidth)
//        let row = Int(point.y / cellHeight)
//        
//        // Check if the calculated row and column are within the bounds of the grid
//        if row >= 0 && row < settings.layout.rows.count && column >= 0 && column < settings.layout.rows[row].count {
//            return settings.layout.rows[row][column]
//        } else {
//            // Return an empty string or some default value if the point is outside the grid
//            return ""
//        }
//    }
//    
//    func selectLetter(_ point: CGPoint, gridSize: CGSize) {
//        let cell = determineCell(at: point, gridSize: gridSize)
//        
//        // If hoveredCell is not set or is different from the current cell
//        if hoveredCell == nil || hoveredCell! != cell {
//            hoveredCell = cell
//            dwellStartTime = Date()
//        }
//        
//        // Check if the dwell time has been exceeded
//        if let startTime = dwellStartTime, Date().timeIntervalSince(startTime) >= dwellDuration {
//            // If completedDwellCell is not set or is different from the current cell
//            if completedDwellCell == nil || completedDwellCell! != cell {
//                selectCell(cell)
//                completedDwellCell = cell
//                dwellStartTime = nil
//                hoveredCell = nil
//            }
//        }
//    }
//    
//    
//    // Function to determine cell at a point
//    func determineCell(at point: CGPoint, gridSize: CGSize) -> (row: Int, column: Int) {
//        let rowHeight = gridSize.height / CGFloat(settings.layout.rows.count)
//        let row = Int(point.y / rowHeight)
//        
//        let numberOfColumnsInRow = CGFloat(settings.layout.rows[row].count)
//        let columnWidth = gridSize.width / numberOfColumnsInRow
//        let column = Int(point.x / columnWidth)
//        
//        return (row, column)
//    }
//    
//    
//    // Function to check dwell time
//    func checkDwellTime() {
//        if let startTime = dwellStartTime, Date().timeIntervalSince(startTime) >= dwellDuration {
//            if let cell = hoveredCell {
//                selectCell(cell)
//                completedDwellCell = cell // Mark this cell as selected
//                dwellStartTime = nil
//                hoveredCell = nil // Reset hovered cell
//            }
//        }
//    }
//    
//    // Function to select a cell
//    func selectCell(_ cell: (row: Int, column: Int)) {
//        guard cell.row >= 0, cell.row < settings.layout.rows.count,
//              cell.column >= 0, cell.column < settings.layout.rows[cell.row].count else {
//            print("Index out of range: row \(cell.row), column \(cell.column)")
//            return
//        }
//        let letter = settings.layout.rows[cell.row][cell.column]
//        if letter == "Delete" {
//            deleteLastCharacter()
//        } else if letter == "Finish" {
//            print("Before autocorrect: currentSentence='\(currentSentence)', formedWord='\(formedWord)'")
//            let fullSentence = currentSentence + formedWord
//            formedWord = "" // Reset formedWord
//            
//            if settings.writeWithoutSpacesEnabled {
//                correctNoSpaceSentence(fullSentence) { correctedSentence in
//                    DispatchQueue.main.async {
//                        if let corrected = correctedSentence {
//                            self.currentSentence = corrected
//                        } else {
//                            self.currentSentence = fullSentence // Fallback in case of error
//                        }
//                        self.postCorrectionProcessing()
//                    }
//                }
//            } else {
//                currentSentence = fullSentence
//                postCorrectionProcessing()
//            }
//        } else {
//            updateFormedWordAndSentence(with: letter)
//        }
//    }
//    
//    func postCorrectionProcessing() {
//        if settings.autocorrectEnabled {
//            currentSentence = autocorrectSentence(currentSentence)
//        }
//        print("Processed sentence: \(currentSentence)")
//        speakMessage()
//    }
//    
//    
//    func processDragForLetterSelection(gridSize: CGSize) {
//        guard dragPoints.count >= 2 else { return }
//        
//        let latestPoint = dragPoints.last!
//        let previousPoint = dragPoints[dragPoints.count - 2]
//        let newDirection = calculateDirection(from: previousPoint, to: latestPoint)
//        
//        if let lastDir = lastDirection, didChangeDirection(from: lastDir, to: newDirection) {
//            let cell = determineCell(at: latestPoint, gridSize: gridSize)
//            
//            if completedDwellCell == nil || completedDwellCell! != cell {
//                selectCell(cell)
//                completedDwellCell = cell
//            }
//        }
//        
//        lastDirection = newDirection
//    }
//    
//    
//    private func updateFormedWordAndSentence(with letter: String) {
//        if letter == " " || letter == "Space" { // Check for both a space character and the string "Space"
//            currentSentence += formedWord + " "
//            formedWord = ""
//        } else {
//            formedWord += letter
//        }
//    }
//    
//    func autocorrectSentence(_ sentence: String) -> String {
//        print("Autocorrecting sentence: \(sentence)")
//        let textChecker = UITextChecker()
//        var correctedSentence = ""
//        let words = sentence.split(separator: " ")
//        
//        for word in words {
//            let originalWord = String(word)
//            let range = NSRange(location: 0, length: originalWord.utf16.count)
//            let misspelledRange = textChecker.rangeOfMisspelledWord(in: originalWord, range: range, startingAt: 0, wrap: false, language: "en")
//            
//            if misspelledRange.location != NSNotFound {
//                print("Misspelled word found: \(originalWord)")
//                if let guesses = textChecker.guesses(forWordRange: misspelledRange, in: originalWord, language: "en"), !guesses.isEmpty {
//                    print("Guesses for \(originalWord): \(guesses)")
//                    let filteredGuesses = guesses.filter { guess in
//                        let isWithinLengthLimit = abs(guess.count - originalWord.count) <= 2
//                        print("Original: \(originalWord), Guess: \(guess), Within Length Limit: \(isWithinLengthLimit)")
//                        return isWithinLengthLimit
//                    }
//                    
//                    let correctedWord = filteredGuesses.first ?? originalWord
//                    correctedSentence += correctedWord + " "
//                } else {
//                    print("No guesses found for \(originalWord)")
//                    correctedSentence += originalWord + " "
//                }
//            } else {
//                print("No misspelling found in \(originalWord)")
//                correctedSentence += originalWord + " "
//            }
//        }
//        
//        let trimmedCorrectedSentence = correctedSentence.trimmingCharacters(in: .whitespaces)
//        print("Autocorrected sentence: \(trimmedCorrectedSentence)")
//        return trimmedCorrectedSentence
//    }
//    
//    
//    func determineBackgroundColor(row: Int, column: Int) -> Color {
//        let letter = settings.layout.rows[row][column]
//        
//        // Check for specific function keys
//        if letter == "Finish" {
//            return Color.green.opacity(0.5)  // Or any color that signifies 'action' or 'complete'
//        } else if letter == "Space" {
//            return Color.blue.opacity(0.5)  // Or a different color to indicate 'space'
//        } else if let unwrappedCurrent = currentlyDwellingCell, unwrappedCurrent.row == row && unwrappedCurrent.column == column {
//            return dwellCellSelecteced ? Color.red : Color.gray
//        } else if completedDwellCell?.row == row && completedDwellCell?.column == column {
//            return Color.red // Selected cell
//        } else if hoveredCell?.row == row && hoveredCell?.column == column {
//            return Color.gray // Currently hovered cell
//        } else {
//            return Color.clear
//        }
//    }
//    
//    
//    
//    func deleteLastCharacter() {
//        if !formedWord.isEmpty {
//            formedWord.removeLast()
//        } else if !currentSentence.isEmpty {
//            currentSentence.removeLast()
//        }
//    }
//    
//    func speakMessage() {
//        speakMessage(currentSentence)
//    }
//    
//    func speakMessage(_ word: String) {
//        let utterance = AVSpeechUtterance(string: word)
//        speechSynthesizer.speak(utterance)
//    }
//    
//    
//    func clearMessage() {
//        currentSentence = ""
//        formedWord = "" // Reset the formed word as well
//    }
//    
//    
//    
//    func didChangeDirection(from oldDirection: CGVector, to newDirection: CGVector) -> Bool {
//        let angle = angleBetween(v1: oldDirection, v2: newDirection)
//        return angle > angleThreshold // angleThreshold is a predefined constant
//    }
//    
//    func angleBetween(v1: CGVector, v2: CGVector) -> CGFloat {
//        let dotProduct = v1.dx * v2.dx + v1.dy * v2.dy
//        let magnitudeV1 = sqrt(v1.dx * v1.dx + v1.dy * v1.dy)
//        let magnitudeV2 = sqrt(v2.dx * v2.dx + v2.dy * v2.dy)
//        return acos(dotProduct / (magnitudeV1 * magnitudeV2))
//    }
//    
//    func calculateDirection(from startPoint: CGPoint, to endPoint: CGPoint) -> CGVector {
//        let dx = endPoint.x - startPoint.x
//        let dy = endPoint.y - startPoint.y
//        return CGVector(dx: dx, dy: dy)
//    }
//    
//    func correctNoSpaceSentence(_ text: String, completion: @escaping (String?) -> Void) {
//        guard let url = URL(string: "https://correctasentence.acecentre.net/correction/correct_sentence") else {
//            completion(nil)
//            return
//        }
//        
//        var request = URLRequest(url: url)
//        request.httpMethod = "POST"
//        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
//        
//        let body: [String: Any] = [
//            "text": text,
//            "correct_typos": false
//        ]
//        
//        request.httpBody = try? JSONSerialization.data(withJSONObject: body)
//        
//        URLSession.shared.dataTask(with: request) { data, response, error in
//            guard let data = data, error == nil else {
//                completion(nil)
//                return
//            }
//            
//            do {
//                let responseObj = try JSONDecoder().decode(CorrectionResponse.self, from: data)
//                completion(responseObj.correctedSentence)
//            } catch {
//                print("Error decoding response: \(error)")
//                completion(nil)
//            }
//        }.resume()
//    }
//    
//    
//}
