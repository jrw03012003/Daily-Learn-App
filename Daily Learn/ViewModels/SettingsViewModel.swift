//
//  SettingsViewModel.swift
//  Daily Learn
//
//  Created by Jack white on 21/10/2024.
//

import SwiftUI

class SettingsViewModel: ObservableObject {
    @AppStorage("username") var username: String = ""
    @AppStorage("notificationTimeInterval") private var notificationTimeInterval: Double = Date().timeIntervalSince1970
    @AppStorage("themePreference") var themePreference: AppTheme = .system


    var notificationTime: Date {
        get { Date(timeIntervalSince1970: notificationTimeInterval) }
        set { notificationTimeInterval = newValue.timeIntervalSince1970 }
    }
}

