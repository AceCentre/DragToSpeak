import SwiftUI
import AVFoundation

enum DragType: Int {
    case direction = 1
    case dwell = 2
}

class TimeStampedPoints {
    var point: CGPoint
    var timestamp: Double
    
    init(_ point: CGPoint) {
        self.point = point
        timestamp = Date().timeIntervalSince1970
    }
}

enum Layout: Int {
    case alphabetical
    case frequency
    
    var rows: [[String]] {
        switch self {
        case .alphabetical:
            return [["A", "B", "C", "D", "E"],
            ["F", "G", "H", "I", "J"],
            ["K", "L", "M", "N", "O"],
            ["P", "Q", "R", "S", "T"],
            ["U", "V", "W", "X", "Y"],
            ["Z", "Space", "YES", "NO", "Please"],
            ["Thank you", "OK", "The", " ", " "],
            ["0", "1", "2", "3", "4"],
            ["5", "6", "7", "8", "9"]]
        case .frequency:
            return  [["Space", "E", "A", "R", "D", "U"],
            ["T", "O", "I", "L", "G", "V"],
            ["N", "S", "F", "Y", "X", " "],
            ["H", "C", "P", "K", "J", " "],
            ["M", "B", "W", "Q", "Z", " "],
            ["Thank you", "OK", "The", "YES", "NO", "PLEASE"],
            ["0", "1", "2", "3", "4", " "],
            ["5", "6", "7", "8", "9", " "]]
        }
    }
}

struct SpellingBoardView: View {
    @State private var formedWord = ""
    @State private var completedDwellCell: (row: Int, column: Int)? = nil
    @State private var currentSentence = ""
    
    @State private var dragPoints: [CGPoint] = []
    @State private var dragPointsWithTimeStamps: [TimeStampedPoints] = []
    @State private var lastDirection: CGVector?
    let angleThreshold = 20 * Double.pi / 180 // Convert 20 degrees to radians
    
    let dwellDuration = 0.5 // 0.5 seconds dwell time
    @State private var dwellStartTime: Date? = nil
    @State private var hoveredCell: (row: Int, column: Int)? = nil
    
    let speechSynthesizer = AVSpeechSynthesizer()
    
    @State var settingsOpen = false
    @AppStorage("dragType") var dragType: DragType = .dwell
    @AppStorage("dwellTime") var dwellTime: Double = 3
    @AppStorage("showTrail") var showTrail: Bool = true
    @AppStorage("Layout") var layout: Layout = .alphabetical
    
    @State var currentlyDwellingCell: (row: Int, column: Int)?
    @State var dwellWorkItem: DispatchWorkItem?
    @State var dwellCellSelecteced = false
    
    @State private var progressAmount = 0.0
    let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
    
    init() {
        // This makes it work in silent mode by setting the audio to playback
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
        } catch let error {
            print("This error message from SpeechSynthesizer \(error.localizedDescription)")
        }
    }
    
    var body: some View {
        
        VStack(spacing: 0) {
            HStack {
                // Sentence display row
                // We dont ever want to display an empty string because that causes the line height to jump about
                // There is probably a better way to do this
                Text(currentSentence == "" ? " " : currentSentence)
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
                Button(action: {
                    settingsOpen = true
                }) {
                    Image(systemName: "gear")
                }.padding(.trailing)
            }
            .sheet(isPresented: $settingsOpen, content: {
                NavigationStack {
                    Form {
                        Section(content: {
                            VStack(alignment: .leading) {
                                Label("Drag Type", systemImage: "hand.draw")
                                    .labelStyle(.titleOnly)
                                Picker("Drag Type", selection: $dragType) {
                                    Text("Direction Change").tag(DragType.direction)
                                    Text("Dwell").tag(DragType.dwell)
                                }
                                .pickerStyle(.segmented)
                            }.frame(alignment: .leading)
                        }, footer: {
                            Text("Change how we calculate letter selection")
                            
                        })
                        
                        Section(content: {
                            Picker("Layout", selection: $layout) {
                                Text("Alphabetical").tag(Layout.alphabetical)
                                Text("Frequency").tag(Layout.frequency)
                            }
                            
                        }, footer: {
                            Text("The layout of the letters on the grid")
                        })
                        
                        Section(content: {
                            VStack {
                                HStack {
                                    Text("Dwell Time")
                                    Spacer()
                                    Text(String(format: "%.2f", dwellTime))
                                }
                                
                                Slider(
                                    value: $dwellTime,
                                    in: 0.1...10,
                                    step: 0.1
                                ) {
                                    Text("Dwell Time")
                                } minimumValueLabel: {
                                    Text("0.1s")
                                } maximumValueLabel: {
                                    Text("10s")
                                }
                            }
                        }, footer: {
                            Text("The amount of time you must keep your finger on a letter to register a click. This only work in Dwell mode")
                        })
                        
                        Section(content: {
                            Toggle("Show Trail", isOn: $showTrail)
                        }, footer: {
                            Text("A trail is shown behind the users finger as they drag about")
                        })
                    }
                    .navigationTitle("Settings")
                    .toolbar {
                        ToolbarItemGroup(placement:.primaryAction) {
                            Button("Done") {
                                settingsOpen = false
                            }
                        }
                    }
                }
            })
            if dragType == .dwell {
                ProgressView(value: progressAmount, total: 100)
                    .onReceive(timer) { _ in
                        // If we have a work item we should bump this
                        if dwellWorkItem != nil {
                            let current = 100 / (dwellTime / 0.1)
                            progressAmount = min(100, progressAmount + current)
                        }
                    }
            }
            GeometryReader { geometry in
                ZStack {
                    VStack(spacing: 0) {
                        ForEach(0..<layout.rows.count, id: \.self) { rowIndex in
                            HStack(spacing: 0) {
                                ForEach(layout.rows[rowIndex].indices, id: \.self) { columnIndex in
                                    let letter = layout.rows[rowIndex][columnIndex]
                                    Text(letter)
                                        .frame(width: geometry.size.width / CGFloat(layout.rows[0].count), height: geometry.size.height / CGFloat(layout.rows.count))
                                        .border(Color.black)
                                        .background(determineBackgroundColor(row: rowIndex, column: columnIndex))
                                }
                            }
                        }
                    }
                    if showTrail {
                        Path { path in
                            let validDragPoints = dragPointsWithTimeStamps.filter { point in
                                let now = Date().timeIntervalSince1970
                                let timeBetween = now - point.timestamp
                                return timeBetween < 1
                            }
                            
                            
                            if let initialDragPoint = validDragPoints.first, validDragPoints.count >= 2 {
                                path.move(to: initialDragPoint.point)
                                
                                for index in 1...(validDragPoints.count - 1) {
                                    path.addLine(to: validDragPoints[index].point)
                                }
                            }
                        }
                        .stroke(.blue, style: StrokeStyle(lineWidth: 10, lineCap: .round, lineJoin: .round))
                    }
                }
                .gesture(
                    DragGesture(minimumDistance: 0, coordinateSpace: .local)
                        .onChanged { value in
                            if dragType == .direction {
                                dragPoints.append(value.location)
                                dragPointsWithTimeStamps.append(TimeStampedPoints(value.location))
                                selectLetter(value.location, gridSize: geometry.size) // Call the function to select the letter
                                processDragForLetterSelection(gridSize: geometry.size)
                            }
                            
                            if dragType == .dwell {
                                dragPoints.append(value.location)
                                dragPointsWithTimeStamps.append(TimeStampedPoints(value.location))
                                
                                let cell = determineCell(at: value.location, gridSize: geometry.size)
                                
                                if let unwrappedCurrent = currentlyDwellingCell {
                                    if unwrappedCurrent != cell {
                                        // We have moved over into a new cell so start timer
                                        currentlyDwellingCell = cell
                                        cancelDwellTimer()
                                        startDwellTimer()
                                    }
                                } else {
                                    // There was no cell stored so lets clear and start timer
                                    currentlyDwellingCell = cell
                                    cancelDwellTimer()
                                    startDwellTimer()
                                }
                            }
                        }
                        .onEnded { _ in
                            if dragType == .direction {
                                // Removed correction just now as it ends up doubling up the output
                                // TODO Re-enable corrections
                                // let correctedWord = self.autocorrectWord(self.formedWord.trimmingCharacters(in: .whitespaces)) ?? self.formedWord.trimmingCharacters(in: .whitespaces)
                                // self.currentSentence += correctedWord + " "
                                self.speakMessage(self.formedWord)
                                self.currentSentence += " "
                                self.formedWord = "" // Reset for next word
                                self.dragPoints.removeAll()
                                self.dragPointsWithTimeStamps.removeAll()

                                self.lastDirection = nil // Reset the last direction on gesture end
                            }
                            
                            if dragType == .dwell {
                                // Cancell dwell timer
                                currentlyDwellingCell = nil
                                cancelDwellTimer()
                                
                                self.speakMessage(self.formedWord)
                                self.currentSentence += " "
                                self.formedWord = "" // Reset for next word
                                self.dragPoints.removeAll()
                                self.dragPointsWithTimeStamps.removeAll()
                                self.lastDirection = nil // Reset the last direction on gesture end

                            }
                        }
                    
                )
            }
        }
    }
    
    func startDwellTimer() {
        let newWorkItem = DispatchWorkItem(block: {
            if let currentCell = currentlyDwellingCell {
                dwellCellSelecteced = true
                selectCell(currentCell)
            }
            
        })
        
        dwellWorkItem = newWorkItem
        DispatchQueue.main.asyncAfter(deadline: .now() + dwellTime, execute: newWorkItem)
    }
    
    func cancelDwellTimer() {
        if let unwrappedWorkItem = dwellWorkItem {
            unwrappedWorkItem.cancel()
            dwellWorkItem = nil
        }
        dwellCellSelecteced = false
        progressAmount = 0.0
    }
    
    func determineLetter(at point: CGPoint, gridSize: CGSize) -> String {
        // Calculate the dimensions of each cell
        let cellWidth = gridSize.width / CGFloat(layout.rows[0].count)
        let cellHeight = gridSize.height / CGFloat(layout.rows.count)

        // Calculate the row and column based on the touch point
        let column = Int(point.x / cellWidth)
        let row = Int(point.y / cellHeight)

        // Check if the calculated row and column are within the bounds of the grid
        if row >= 0 && row < layout.rows.count && column >= 0 && column < layout.rows[row].count {
            return layout.rows[row][column]
        } else {
            // Return an empty string or some default value if the point is outside the grid
            return ""
        }
    }

    func selectLetter(_ point: CGPoint, gridSize: CGSize) {
        let cell = determineCell(at: point, gridSize: gridSize)

        // If hoveredCell is not set or is different from the current cell
        if hoveredCell == nil || hoveredCell! != cell {
            hoveredCell = cell
            dwellStartTime = Date()
        }

        // Check if the dwell time has been exceeded
        if let startTime = dwellStartTime, Date().timeIntervalSince(startTime) >= dwellDuration {
            // If completedDwellCell is not set or is different from the current cell
            if completedDwellCell == nil || completedDwellCell! != cell {
                selectCell(cell)
                completedDwellCell = cell
                dwellStartTime = nil
                hoveredCell = nil
            }
        }
    }








    // Function to determine cell at a point
    func determineCell(at point: CGPoint, gridSize: CGSize) -> (row: Int, column: Int) {
        let cellWidth = gridSize.width / CGFloat(layout.rows[0].count)
        let cellHeight = gridSize.height / CGFloat(layout.rows.count)

        let column = Int(point.x / cellWidth)
        let row = Int(point.y / cellHeight)

        return (row, column)
    }

    // Function to check dwell time
    func checkDwellTime() {
        if let startTime = dwellStartTime, Date().timeIntervalSince(startTime) >= dwellDuration {
            if let cell = hoveredCell {
                selectCell(cell)
                completedDwellCell = cell // Mark this cell as selected
                dwellStartTime = nil
                hoveredCell = nil // Reset hovered cell
            }
        }
    }



    // Function to select a cell
    func selectCell(_ cell: (row: Int, column: Int)) {
        let letter = layout.rows[cell.row][cell.column]
        updateFormedWordAndSentence(with: letter)
        // Any additional selection logic here
    }

    func processDragForLetterSelection(gridSize: CGSize) {
        guard dragPoints.count >= 2 else { return }

        let latestPoint = dragPoints.last!
        let previousPoint = dragPoints[dragPoints.count - 2]
        let newDirection = calculateDirection(from: previousPoint, to: latestPoint)

        if let lastDir = lastDirection, didChangeDirection(from: lastDir, to: newDirection) {
            let cell = determineCell(at: latestPoint, gridSize: gridSize)
            
            if completedDwellCell == nil || completedDwellCell! != cell {
                selectCell(cell)
                completedDwellCell = cell
            }
        }

        lastDirection = newDirection
    }


    private func updateFormedWordAndSentence(with letter: String) {
        // Check if the letter is "Space" and handle accordingly
        if letter == "Space" {
            // Replace "Space" with an actual space character
            currentSentence += " "
            formedWord += "" // Reset for next word
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
        if let unrwappedCurrent = currentlyDwellingCell {
            if row == unrwappedCurrent.row && unrwappedCurrent.column == column {
                return dwellCellSelecteced ? Color.red : Color.gray
            }
        }
        
        
        if completedDwellCell?.row == row && completedDwellCell?.column == column {
            return Color.red // Selected cell
        } else if hoveredCell?.row == row && hoveredCell?.column == column {
            return Color.gray // Currently hovered cell
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

#Preview {
    SpellingBoardView()
}
