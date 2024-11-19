//
//  MoreViewModel.swift
//  test 2 app
//
//  Created by Jack white on 22/10/2024.
//

import SwiftUI

class MoreViewModel: ObservableObject {
    @Published var currentLearn: DailyLearn?
    private let dataLoader = DataLoader.shared
    private let preferences = PreferencesManager.shared

    func fetchNewLearn() {
        dataLoader.loadContentIfNeeded() // Ensure data is loaded

        let quote = preferences.includeQuotes ? dataLoader.getRandomContent(ofType: .quote) : nil
        let tip = preferences.includeTips ? dataLoader.getRandomContent(ofType: .tip) : nil
        let fact = preferences.includeFacts ? dataLoader.getRandomContent(ofType: .fact) : nil

        currentLearn = DailyLearn(quote: quote, tip: tip, fact: fact)
    }
}
