//
//  String.swift
//  DragToSpeak
//
//  Created by Gavin Henderson on 09/02/2024.
//

import Foundation

extension String {
    func base64Encoded() -> String? {
        data(using: .utf8)?.base64EncodedString()
    }
}
