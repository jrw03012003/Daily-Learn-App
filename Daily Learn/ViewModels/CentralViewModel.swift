//
//  CentralViewModel.swift
//  Daily Learn
//
//  Created by Jack white on 21/10/2024.
//

import SwiftUI
import Foundation


class CentralViewModel: ObservableObject {
    @Published var dailyLearn: DailyLearn?
    private let dataLoader = DataLoader.shared
    private let preferences = PreferencesManager.shared

    // Store the last updated date to know when to refresh the learn content
    @AppStorage("lastUpdatedLearnDate") private var lastUpdatedLearnDate: String = ""

    init() {
        loadDailyLearn()  // Load the learn on initialization
    }

    // Load the learn, but only update if it's a new day (after 2:30 AM)
    func loadDailyLearn() {
        let currentDate = getCurrentDateForLearnUpdate()

        if currentDate != lastUpdatedLearnDate {
            fetchNewLearn()
        } else {
            dailyLearn = loadCachedLearn()
        }
    }



    // Fetch a new learn and cache it for the day
    private func fetchNewLearn() {
        dataLoader.loadContentIfNeeded()
        
        let quote = preferences.includeQuotes ? dataLoader.getRandomContent(ofType: .quote) : nil
        let tip = preferences.includeTips ? dataLoader.getRandomContent(ofType: .tip) : nil
        let fact = preferences.includeFacts ? dataLoader.getRandomContent(ofType: .fact) : nil

        // Create the new daily learn
        dailyLearn = DailyLearn(quote: quote, tip: tip, fact: fact)

        // Cache the learn and update the last updated date
        cacheLearn(dailyLearn)
        lastUpdatedLearnDate = getCurrentDateForLearnUpdate()

        // Reschedule the notification with the new learn
        NotificationManager.shared.scheduleDailyNotification(at: preferences.notificationTime)
    }
    
    // Cache the learn content for the day
    private func cacheLearn(_ learn: DailyLearn?) {
        if let learn = learn, let encoded = try? JSONEncoder().encode(learn) {
            UserDefaults.standard.set(encoded, forKey: "cachedDailyLearn")
        }
    }

    // Load the cached learn content from storage
    private func loadCachedLearn() -> DailyLearn? {
        if let savedLearn = UserDefaults.standard.object(forKey: "cachedDailyLearn") as? Data {
            if let decodedLearn = try? JSONDecoder().decode(DailyLearn.self, from: savedLearn) {
                return decodedLearn
            }
        }
        return nil
    }
    
    // Check if the current time is after 2:30 AM
    private func isAfterLearnUpdateTime() -> Bool {
        let now = Date()
        let calendar = Calendar.current
        let currentHour = calendar.component(.hour, from: now)
        let currentMinute = calendar.component(.minute, from: now)
        return currentHour > 2 || (currentHour == 2 && currentMinute >= 30)
    }

    // Utility function to get the current date adjusted for 2:30 AM
    private func getCurrentDateForLearnUpdate() -> String {
        let date = Date()
        let calendar = Calendar.current

        // Get the current date components
        var components = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: date)

        // If current time is before 2:30 AM, subtract one day to get the previous date
        if let hour = components.hour, let minute = components.minute, (hour, minute) < (2, 30) {
            if let previousDate = calendar.date(byAdding: .day, value: -1, to: date) {
                components = calendar.dateComponents([.year, .month, .day], from: previousDate)
            }
        }

        // Convert the date components back to a date and format it
        if let adjustedDate = calendar.date(from: components) {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            return formatter.string(from: adjustedDate)
        }

        // Fallback to current date if conversion fails
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: date)
    }
    
    // New helper method to check if dailyLearn has meaningful content
    func hasMeaningfulContent() -> Bool {
        guard let learn = dailyLearn else { return false }

        // Check if any of the fields have meaningful content
        if let quote = learn.quote, !quote.content.trimmingCharacters(in: .whitespaces).isEmpty {
            return true
        }
        if let tip = learn.tip, !tip.content.trimmingCharacters(in: .whitespaces).isEmpty {
            return true
        }
        if let fact = learn.fact, !fact.content.trimmingCharacters(in: .whitespaces).isEmpty {
            return true
        }
        return false
    }
}



struct DailyLearn: Codable {
    let quote: LearnContent?
    let tip: LearnContent?
    let fact: LearnContent?
}
