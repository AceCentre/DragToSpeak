//
//  Secrets.swift
//  DragToSpeak
//
//  Created by Gavin Henderson on 09/02/2024.
//

import Foundation

struct Secrets {
    private static func secrets() -> [String: String] {
        let fileName = "secrets"
        guard let path = Bundle.main.path(forResource: fileName, ofType: "json") else { return [:] }
        
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
            let result = try JSONSerialization.jsonObject(with: data)
            
            return result as? [String: String] ?? [:]
        } catch {
            return [:]
        }
    }

    static var azureUserPass: String? {
        return secrets()["AZURE_USER_PASS"]
    }
}
