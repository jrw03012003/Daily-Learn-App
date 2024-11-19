//
//  LearnContent.swift
//  Daily Learn
//
//  Created by Jack white on 21/10/2024.
//

import Foundation

struct LearnContent: Codable {
    let content: String
    let author: String?
    let category: String
    let type: ContentType
}

