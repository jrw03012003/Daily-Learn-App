//
//  DataLoader.swift
//  Daily Learn
//
//  Created by Jack white on 21/10/2024.
//

import Foundation

class DataLoader {
    static let shared = DataLoader()
    
    private(set) var quotes: [LearnContent] = []
    private(set) var tips: [LearnContent] = []
    private(set) var facts: [LearnContent] = []
    
    private var isContentLoaded = false
    
    private init() {
        // loadContent() - Do not load content here
    }
    
    func loadContentIfNeeded() {
        if !isContentLoaded {
            loadContent()
            isContentLoaded = true
        }
    }

    
    private func loadContent() {
        quotes = loadJSON(filename: "quotes.json")
        tips = loadJSON(filename: "tips.json")
        facts = loadJSON(filename: "facts.json")
    }
    
    private func loadJSON(filename: String) -> [LearnContent] {
        guard let url = Bundle.main.url(forResource: filename, withExtension: nil) else {
            print("Failed to locate \(filename) in bundle.")
            return []
        }
        
        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            let content = try decoder.decode([LearnContent].self, from: data)
            return content
        } catch {
            print("Failed to decode \(filename): \(error)")
            return []
        }
    }
    
    func getRandomContent(ofType type: ContentType) -> LearnContent? {
        let preferences = PreferencesManager.shared
        let contentPool: [LearnContent]
        let selectedCategories: [String]
        
        switch type {
        case .quote:
            contentPool = quotes
            selectedCategories = preferences.selectedQuoteCategories
        case .tip:
            contentPool = tips
            selectedCategories = preferences.selectedTipCategories
        case .fact:
            contentPool = facts
            selectedCategories = preferences.selectedFactCategories
        }
        
        let filteredContent = contentPool.filter { selectedCategories.contains($0.category) }
        return filteredContent.randomElement()
    }
}
