//
//  SavedPageModel.swift
//  test 2 app
//
//  Created by Jack white on 14/11/2024.
//

import Foundation

struct SavedPage: Identifiable, Codable {
    let id: UUID
    let boxName: String
    let content: String
    let timestamp: Date
    
    init(boxName: String, content: String, timestamp: Date = Date()) {
        self.id = UUID()
        self.boxName = boxName
        self.content = content
        self.timestamp = timestamp
    }
}
