//
//  OnboardingView.swift
//  Daily Learn
//
//  Created by Jack white on 21/10/2024.
//

import SwiftUI

struct OnboardingView: View {
    @StateObject private var viewModel = OnboardingViewModel()
    @State private var username: String = ""
    @State private var notificationTime: Date = Date()
    @EnvironmentObject var preferences: PreferencesManager  // Use PreferencesManager
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Welcome to Daily Learn!")
                .font(.largeTitle)
                .padding(.top)
            
            TextField("Enter your name", text: $username)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)
            
            DatePicker("Set Notification Time", selection: $notificationTime, displayedComponents: .hourAndMinute)
                .labelsHidden()
                .padding(.horizontal)
            
            Text("Daily Learn aims to bring a small dose of positivity, advice, and learning into your every day life.")
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            Text("“Each day acquire something that will fortify you against poverty, against death, indeed against other misfortunes...”\n-Seneca")
                .italic()
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            Text("A quote can change things—helping you ditch the excuses, escape your comfort zone, and take action.")
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            Text("Please allow notifications when prompted for intended functionaliy.")
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            Button(action: {
                viewModel.saveUserDetails(name: username, time: notificationTime)
                NotificationManager.shared.requestNotificationAuthorization()
                preferences.hasCompletedOnboarding = true // Set the flag to true
            }) {
                Text("Next")
                    .applyPrimaryButtonStyle()
            }
            .padding(.bottom)
        }
        .applyTheme(preferences.appTheme) // Apply theme if needed
    }
}
