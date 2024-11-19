//
//  OnboardingViewModel.swift
//  Daily Learn
//
//  Created by Jack white on 21/10/2024.
//

import SwiftUI

class OnboardingViewModel: ObservableObject {
    @AppStorage("username") var username: String = ""
    private let preferences = PreferencesManager.shared
    @AppStorage("notificationTimeInterval") private var notificationTimeInterval: Double = Date().timeIntervalSince1970

    var notificationTime: Date {
        get { Date(timeIntervalSince1970: notificationTimeInterval) }
        set { notificationTimeInterval = newValue.timeIntervalSince1970 }
    }
    
    func saveUserDetails(name: String, time: Date) {
            username = name
            notificationTimeInterval = time.timeIntervalSince1970
            // Schedule the notification with the updated time
        NotificationManager.shared.scheduleDailyNotification(at: preferences.notificationTime)
    }
    }
