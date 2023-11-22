import SwiftUI
import AVFoundation

struct SpellingBoardView: View {

    @State private var formedWord = ""
    @State private var currentRow: Int? = nil
    @State private var currentColumn: Int? = nil
    @State private var dwellTimer: Timer? = nil
    @State private var completedDwellCell: (row: Int, column: Int)? = nil
    @State private var lastUpdateTime: Date? = nil
    let dwellThreshold = 0.3 // 0.2 seconds for dwell
    @State private var currentSentence = ""
    @State private var hasSelectedLetter = false // Add this state variable
    @State private var selectionDebounceTimer: Timer?
    
    @State private var dragPoints: [CGPoint] = []
    @State private var lastDirection: CGVector?
    let angleThreshold = 20 * Double.pi / 180 // Convert 20 degrees to radians

    
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
                            ForEach(rows[rowIndex].indices, id: \.self) { columnIndex in
                                let letter = rows[rowIndex][columnIndex]
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
                            dragPoints.append(value.location)
                            processDragForLetterSelection(gridSize: geometry.size)
                        }
                        .onEnded { _ in
                            let correctedWord = self.autocorrectWord(self.formedWord.trimmingCharacters(in: .whitespaces)) ?? self.formedWord.trimmingCharacters(in: .whitespaces)
                            self.speakMessage(correctedWord)
                            self.currentSentence += correctedWord + " "
                            self.formedWord = "" // Reset for next word
                            self.dragPoints.removeAll()
                            self.lastDirection = nil // Reset the last direction on gesture end
                        }

                )
            }
        }

  
    
    func determineLetter(at point: CGPoint, gridSize: CGSize) -> String {
        // Calculate the dimensions of each cell
        let cellWidth = gridSize.width / CGFloat(rows[0].count)
        let cellHeight = gridSize.height / CGFloat(rows.count)

        // Calculate the row and column based on the touch point
        let column = Int(point.x / cellWidth)
        let row = Int(point.y / cellHeight)

        // Check if the calculated row and column are within the bounds of the grid
        if row >= 0 && row < rows.count && column >= 0 && column < rows[row].count {
            return rows[row][column]
        } else {
            // Return an empty string or some default value if the point is outside the grid
            return ""
        }
    }

    func selectLetter(_ point: CGPoint, gridSize: CGSize) {
        let selectedLetter = determineLetter(at: point, gridSize: gridSize)
        if !selectedLetter.isEmpty {
            updateFormedWordAndSentence(with: selectedLetter)
        }
    }

    private func updateFormedWordAndSentence(with letter: String) {
        // Check if the letter is "Space" and handle accordingly
        if letter == "Space" {
            // Replace "Space" with an actual space character
            currentSentence += " "
            checkAndCorrectWordIfNeeded(letter: " ")
            formedWord = "" // Reset for next word
        } else {
            formedWord += letter
            currentSentence += letter
            checkAndCorrectWordIfNeeded(letter: letter)
        }
    }


       private func checkAndCorrectWordIfNeeded(letter: String) {
           if letter == " " {
               let correctedWord = autocorrectWord(formedWord.trimmingCharacters(in: .whitespaces)) ?? formedWord.trimmingCharacters(in: .whitespaces)
               currentSentence = currentSentence.trimmingCharacters(in: .whitespaces) + correctedWord + " "
               formedWord = "" // Reset for next word
           }
       }

       // Implement the autocorrectWord function
       func autocorrectWord(_ word: String) -> String? {
           let textChecker = UITextChecker()
           let range = NSRange(location: 0, length: word.utf16.count)

           let misspelledRange = textChecker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")
           if misspelledRange.location != NSNotFound, let guesses = textChecker.guesses(forWordRange: misspelledRange, in: word, language: "en"), !guesses.isEmpty {
               return guesses[0] // Return the first guess
           }
           return nil // No correction found
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

    func deleteLastCharacter() {
               formedWord = String(formedWord.dropLast())
           }

    func speakMessage() {
               speakMessage(currentSentence)
    }
    
    func speakMessage(_ word: String) {
           let utterance = AVSpeechUtterance(string: word)
           speechSynthesizer.speak(utterance)
       }
    func clearMessage() {
               currentSentence = ""
           }
    
    func processDragForLetterSelection(gridSize: CGSize) {
            guard dragPoints.count >= 2 else { return }

            let latestPoint = dragPoints.last!
            let previousPoint = dragPoints[dragPoints.count - 2]

            // Calculate the new direction
            let newDirection = calculateDirection(from: previousPoint, to: latestPoint)

            // Update last direction
            self.lastDirection = newDirection
        }
    
    func didChangeDirection(from oldDirection: CGVector, to newDirection: CGVector) -> Bool {
            let angle = angleBetween(v1: oldDirection, v2: newDirection)
            return angle > angleThreshold // angleThreshold is a predefined constant
        }

        func angleBetween(v1: CGVector, v2: CGVector) -> CGFloat {
            let dotProduct = v1.dx * v2.dx + v1.dy * v2.dy
            let magnitudeV1 = sqrt(v1.dx * v1.dx + v1.dy * v1.dy)
            let magnitudeV2 = sqrt(v2.dx * v2.dx + v2.dy * v2.dy)
            return acos(dotProduct / (magnitudeV1 * magnitudeV2))
        }
    
    func calculateDirection(from startPoint: CGPoint, to endPoint: CGPoint) -> CGVector {
          let dx = endPoint.x - startPoint.x
          let dy = endPoint.y - startPoint.y
          return CGVector(dx: dx, dy: dy)
      }
}
