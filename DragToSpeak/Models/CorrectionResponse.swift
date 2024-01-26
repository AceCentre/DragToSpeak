//
//  CorrectionResponse.swift
//  DragToSpeak
//
//  Created by Will Wade on 26/01/2024.
//

struct CorrectionResponse: Decodable {
    let correctedSentence: String

    enum CodingKeys: String, CodingKey {
        case correctedSentence = "corrected_sentence"
    }
}
