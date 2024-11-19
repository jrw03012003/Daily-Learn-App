//
//  PreferencesManager.swift
//  Daily Learn
//
//  Created by Jack white on 21/10/2024.
//


    
    
import SwiftUI


class PreferencesManager: ObservableObject {
    // Store user preferences using @AppStorage
    static let shared = PreferencesManager()  // Add this line to make it a singleton
    
    @AppStorage("username") var username: String = ""
    @AppStorage("hasCompletedOnboarding") var hasCompletedOnboarding: Bool = false
    @AppStorage("useOpenDyslexicFont") var useOpenDyslexicFont: Bool = false
    @AppStorage("savedPages") private var savedPagesData: Data = Data()

   
    @Published var useCreamBackground: Bool = UserDefaults.standard.bool(forKey: "useCreamBackground") {
        didSet {
            UserDefaults.standard.set(self.useCreamBackground, forKey: "useCreamBackground")
        }
    }

    
    //MARK: -
    // Storing notification time as a Double (TimeInterval) for compatibility with iOS 15.6
    @AppStorage("notificationTimeInterval") private var notificationTimeInterval: Double = Date().timeIntervalSince1970
    
    var notificationTime: Date {
        get {
            // Convert stored TimeInterval (Double) back to Date
            Date(timeIntervalSince1970: notificationTimeInterval)
        }
        set {
            // Convert Date to TimeInterval (Double) for storage
            notificationTimeInterval = newValue.timeIntervalSince1970
        }
    }
    
    //MARK: -
    // Store selected categories as JSON-encoded strings for quotes, tips, and facts
    @AppStorage("selectedQuoteCategories") private var selectedQuoteCategoriesData: String = ""
    @AppStorage("selectedTipCategories") private var selectedTipCategoriesData: String = ""
    @AppStorage("selectedFactCategories") private var selectedFactCategoriesData: String = ""
    
    // Computed properties for retrieving and saving arrays of categories
    var selectedQuoteCategories: [String] {
        get {
            // Decode stored JSON string into an array of strings
            decode(selectedQuoteCategoriesData) ?? []
        }
        set {
            // Encode array of strings into a JSON string for storage
            selectedQuoteCategoriesData = encode(newValue)
        }
    }
    
    var selectedTipCategories: [String] {
        get {
            decode(selectedTipCategoriesData) ?? []
        }
        set {
            selectedTipCategoriesData = encode(newValue)
        }
    }
    
    var selectedFactCategories: [String] {
        get {
            decode(selectedFactCategoriesData) ?? []
        }
        set {
            selectedFactCategoriesData = encode(newValue)
        }
    }
    
    @AppStorage("includeQuotes") var includeQuotes: Bool = true
    @AppStorage("includeTips") var includeTips: Bool = true
    @AppStorage("includeFacts") var includeFacts: Bool = true
    
    
    //MARK: -
    @AppStorage("appThemeRaw") var appThemeRaw: String = AppTheme.system.rawValue
    var appTheme: AppTheme {
        get { AppTheme(rawValue: appThemeRaw) ?? .system }
        set { appThemeRaw = newValue.rawValue }
    }
        
    
    //MARK: - Saved Pages
    @Published var savedPages: [SavedPage] = [] {
        didSet {
            saveSavedPages()
        }
    }
    
    init() {
        loadSavedPages()
    }
        
    private func loadSavedPages() {
        if let decoded = try? JSONDecoder().decode([SavedPage].self, from: savedPagesData) {
            savedPages = decoded
        } else {
            savedPages = []
        }
    }
        
    private func saveSavedPages() {
        if let encoded = try? JSONEncoder().encode(savedPages) {
            savedPagesData = encoded
        }
    }
        
    func addSavedPage(boxName: String, content: String) {
        let newPage = SavedPage(boxName: boxName, content: content)
        savedPages.append(newPage)
    }
        
    func removeSavedPage(with id: UUID) {
        if let index = savedPages.firstIndex(where: { $0.id == id }) {
            savedPages.remove(at: index)
        }
    }
    
    //MARK: - Helper functions to encode and decode arrays of strings using JSONEncoder and JSONDecoder
    private func encode(_ array: [String]) -> String {
        if let data = try? JSONEncoder().encode(array),
           let string = String(data: data, encoding: .utf8) {
            return string
        }
        return ""
    }
    
    private func decode(_ string: String) -> [String]? {
        if let data = string.data(using: .utf8) {
            return try? JSONDecoder().decode([String].self, from: data)
        }
        return nil
    }
}
