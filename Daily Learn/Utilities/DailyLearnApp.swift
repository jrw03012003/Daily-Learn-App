//
//  DailyLearnApp.swift
//  test 2 app
//
//  Created by Jack white on 21/10/2024.
//

import SwiftUI

@main
struct DailyLearnApp: App {
    @AppStorage("hasCompletedOnboarding") var hasCompletedOnboarding: Bool = false
    @StateObject private var preferences = PreferencesManager.shared

    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(preferences)
                .environment(\.appBackgroundColor, backgroundColor)
                .font(preferences.useOpenDyslexicFont ? Font.custom("OpenDyslexic-Regular", size: 16) : .body)
                .fullScreenCover(isPresented: .constant(!hasCompletedOnboarding)) {
                    OnboardingView()
                        .environmentObject(preferences)
                }
        }
    }
    var backgroundColor: Color {
        preferences.useCreamBackground ? Color("CreamBackground") : Color("WhiteBackground")
    }
}
