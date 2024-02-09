//
//  MessageController.swift
//  DragToSpeak
//
//  Created by Gavin Henderson on 08/02/2024.
//

import Foundation

// I dislike this name
class MessageController: ObservableObject {
    @Published var currentMessage = ""
    
    var appSettings: AppSettings?
    
    var voiceEngine: VoiceEngine?
    
    func clearMessage() {
        currentMessage = ""
    }
    
    func loadVoiceEngine(_ voiceEngine: VoiceEngine) {
        self.voiceEngine = voiceEngine
    }
    
    func finish() {
        if
            let unwrappedVoiceMessage = voiceEngine,
            let unwrappedAppSettings = appSettings
        {
            
            if unwrappedAppSettings.writeWithoutSpacesEnabled {
                addSpaces(currentMessage) { newMessage in
                    DispatchQueue.main.async {
                        self.currentMessage = newMessage
                        unwrappedVoiceMessage.speak(newMessage)
                    }
                }
            } else {
                unwrappedVoiceMessage.speak(currentMessage)
            }
        }
    }
    
    func loadAppSettings(_ appSettings: AppSettings) {
        self.appSettings = appSettings
    }
    
    struct Body: Encodable {
        var text: String
        var correction_method: String
        var correct_typos: Bool
    }
    
    struct CorrectionResponse: Decodable {
        let correctedSentence: String
        
        enum CodingKeys: String, CodingKey {
            case correctedSentence = "corrected_sentence"
        }
    }

    
    func addSpaces(_ text: String, completion: @escaping (String) -> Void) {
        guard let url = URL(string: "https://correctasentence.acecentre.net/correction/correct_sentence") else {
            completion(text)
            print("Failed to get URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let auth = Secrets.azureUserPass?.base64Encoded() ?? ""
        
        request.addValue(auth, forHTTPHeaderField: "Authorization")
        
        let body = Body(
            text: text,
            correction_method: "gpt",
            correct_typos: false
        )
        
        guard let encoded = try? JSONEncoder().encode(body) else {
            print("Failed to encode order")
            completion(text)
            return
        }
        
        request.httpBody = encoded
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                completion(text)
                return
            }
            
            do {
                // print(String(data))
                let responseObj = try JSONDecoder().decode(CorrectionResponse.self, from: data)
                completion(responseObj.correctedSentence)
            } catch {
                print("Error decoding response: \(error)")
                completion(text)
            }
        }.resume()
    }
    
    func selectCell(_ cell: Cell) {
        currentMessage += cell.displayText
    }
}
