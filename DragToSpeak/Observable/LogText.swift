//
//  LogText.swift
//  DragToSpeak
//
//  Created by Gavin Henderson on 12/03/2024.
//

import Foundation

class LogHistory: ObservableObject {
    var logFile: URL
    
    init() {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .allDomainsMask)
        let documentDirectoryPath = paths.first!
        logFile = documentDirectoryPath.appendingPathComponent("log.txt")

    }
    
    func newEntry(input: String, corrected: String) {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .allDomainsMask)
        let documentDirectoryPath = paths.first!
        let log = documentDirectoryPath.appendingPathComponent("log.txt")

        let logString = "\(Date()): \(input) -> \(corrected)\n"

        do {
           let handle = try FileHandle(forWritingTo: log)
           handle.seekToEndOfFile()
           handle.write(logString.data(using: .utf8)!)
           handle.closeFile()
        } catch {
           print("Ignore", error.localizedDescription)
           do {
               try logString.data(using: .utf8)?.write(to: log)
           } catch {
               print("Also ignores", error.localizedDescription)
           }
        }
    }
}
