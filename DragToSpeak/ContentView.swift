import SwiftUI
import AVFoundation

struct SpellingBoardView: View {

    @State private var formedWord = ""
    @State private var currentRow: Int? = nil
    @State private var currentColumn: Int? = nil
    @State private var dwellTimer: Timer? = nil
    @State private var completedDwellCell: (row: Int, column: Int)? = nil
    @State private var currentSentence = ""


    
    let dwellDuration = 0.5 // 0.5 seconds dwell time
    
    let rows = [
        ["A", "B", "C", "D", "E"],
        ["F", "G", "H", "I", "J"],
        ["K", "L", "M", "N", "O"],
        ["P", "Q", "R", "S", "T"],
        ["U", "V", "W", "X", "Y"],
        ["Z", "Space", "YES", "NO", "Please"],
        ["Thank you", "OK", "The", " ", " "],
        ["0", "1", "2", "3", "4"],
        ["5", "6", "7", "8", "9"]
    ]
    let speechSynthesizer = AVSpeechSynthesizer()

    var body: some View {
            GeometryReader { geometry in
                VStack(spacing: 0) {
                    HStack {
                        // Sentence display row
                        Text(currentSentence)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding()
                            .background(Color.gray.opacity(0.2))
                            .border(Color.gray)
                            .layoutPriority(1) // Ensures the text field expands
                        
                        Spacer()
                        
                        // Buttons for additional functions
                        Button(action: clearMessage) {
                            Image(systemName: "trash")
                        }
                        Button(action: deleteLastCharacter) {
                            Image(systemName: "delete.left")
                        }
                        Button(action: speakMessage) {
                            Image(systemName: "speaker.wave.2")
                        }
                    }

                    ForEach(0..<rows.count, id: \.self) { rowIndex in
                        HStack(spacing: 0) {
                            ForEach(rows[rowIndex], id: \.self) { letter in
                                let columnIndex = rows[rowIndex].firstIndex(of: letter) ?? 0
                                Text(letter)
                                    .frame(width: geometry.size.width / CGFloat(rows[0].count), height: geometry.size.height / CGFloat(rows.count))
                                    .border(Color.black)
                                    .background(determineBackgroundColor(row: rowIndex, column: columnIndex))
                            }
                        }
                    }
                }
                .gesture(
                    DragGesture(minimumDistance: 0, coordinateSpace: .local)
                        .onChanged { value in
                            let location = value.location
                            updateSelection(at: location, in: geometry.size)
                        }
                        .onEnded { _ in
                            dwellTimer?.invalidate()
                            if let correctedWord = self.autocorrectWord(self.formedWord) {
                                self.speakWord(correctedWord)
                            } else {
                                self.speakWord(self.formedWord)
                            }
                            self.formedWord = ""
                        }
                )
            }
        }

    func clearMessage() {
            currentSentence = ""
        }

        func deleteLastCharacter() {
            formedWord = String(formedWord.dropLast())
        }

        func speakMessage() {
            speakWord(currentSentence)
        }
    
    func determineBackgroundColor(row: Int, column: Int) -> Color {
            if completedDwellCell?.row == row && completedDwellCell?.column == column {
                return Color.red
            } else if currentRow == row && currentColumn == column {
                return Color.gray
            } else {
                return Color.clear
            }
        }
    
    func updateSelection(at location: CGPoint, in size: CGSize) {
        let cellWidth = size.width / CGFloat(rows[0].count)
        let cellHeight = size.height / CGFloat(rows.count)

        let column = Int(location.x / cellWidth)
        let row = Int(location.y / cellHeight)

        if row >= 0 && row < rows.count && column >= 0 && column < rows[0].count {
                if currentRow != row || currentColumn != column {
                    currentRow = row
                    currentColumn = column
                    completedDwellCell = nil // Reset completed dwell cell
                    restartDwellTimer(for: rows[row][column])
                }
            }
    }

    func restartDwellTimer(for letter: String) {
        dwellTimer?.invalidate()
        dwellTimer = Timer.scheduledTimer(withTimeInterval: dwellDuration, repeats: false) { _ in
            self.completedDwellCell = (self.currentRow ?? -1, self.currentColumn ?? -1)

            // Append each selected letter to 'currentSentence'
            self.currentSentence += letter

            if letter == "Space" {
                let wordToSpeak = self.autocorrectWord(self.formedWord) ?? self.formedWord
                self.speakWord(wordToSpeak)
                
                // Reset 'formedWord' after a space is added
                self.formedWord = ""
            } else {
                // Continue forming the word
                self.formedWord += letter
            }
            
            self.dwellTimer?.invalidate() // Stop the timer
        }
    }



    
    func autocorrectWord(_ word: String) -> String? {
        let textChecker = UITextChecker()
        let range = NSRange(location: 0, length: word.utf16.count)

        // Find a misspelled range
        let misspelledRange = textChecker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")

        if misspelledRange.location != NSNotFound, let guesses = textChecker.guesses(forWordRange: misspelledRange, in: word, language: "en"), !guesses.isEmpty {
            return guesses[0] // Return the first guess
        }

        return nil // No correction found
    }

    func speakLetter(_ letter: String) {
        let utterance = AVSpeechUtterance(string: letter)
        speechSynthesizer.speak(utterance)
    }

    func speakWord(_ word: String) {
        let utterance = AVSpeechUtterance(string: word)
        speechSynthesizer.speak(utterance)
    }


        func resetState() {
            currentRow = nil
            currentColumn = nil
            dwellTimer?.invalidate()
        }

        func addLetter(at location: CGPoint, in size: CGSize) {
            let cellWidth = size.width / CGFloat(rows[0].count)
            let cellHeight = size.height / CGFloat(rows.count)

            let column = Int(location.x / cellWidth)
            let row = Int(location.y / cellHeight)

            // Update the current selection
            if row >= 0 && row < rows.count && column >= 0 && column < rows[0].count {
                currentRow = row
                currentColumn = column

                let letter = rows[row][column]

            // To prevent adding the same letter multiple times if the drag stays within the same cell,
            // you can check if the last character of 'formedWord' is different from 'letter'
            if let lastChar = formedWord.last, String(lastChar) != letter {
                formedWord += letter
            } else if formedWord.isEmpty {
                formedWord += letter
            }
        }
    }

}
