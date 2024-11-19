//
//  UserPreferences.swift
//  Daily Learn
//
//  Created by Jack white on 21/10/2024.
//

import Foundation

struct UserPreferences: Codable {
    var username: String = ""
    var notificationTime: Date = Date()
    var includeQuotes: Bool = true
    var includeTips: Bool = true
    var includeFacts: Bool = true
    var selectedQuoteCategories: [String] = []
    var selectedTipCategories: [String] = []
    var selectedFactCategories: [String] = []
    var themePreference: AppTheme = .system
}

enum AppTheme: String, CaseIterable, Identifiable, Codable {
    case system
    case light
    case dark
    
    var id: String { rawValue }
    
    var description: String {
        switch self {
        case .system:
            return "System"
        case .light:
            return "Light"
        case .dark:
            return "Dark"
        }
    }
}
