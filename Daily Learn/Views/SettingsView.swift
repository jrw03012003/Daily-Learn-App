//
//  SettingsView.swift
//  Daily Learn
//
//  Created by Jack White on 21/10/2024.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var preferences: PreferencesManager
    @Environment(\.appBackgroundColor) var appBackgroundColor
    @StateObject private var viewModel = SettingsViewModel()
    
    var body: some View {
        NavigationView {
            ZStack {
                appBackgroundColor.edgesIgnoringSafeArea(.all)
                
                GeometryReader { geometry in
                    VStack(spacing: 0) {
                        // Custom Header with Title
                        ZStack {
                            // Centered Title
                            Text("Settings")
                                .font(.largeTitle)
                                .fontWeight(.bold)
                                .padding()
                        }
                        
                        // Content
                        VStack(spacing: 10) {
                            // User Section
                            VStack(alignment: .leading, spacing: 5) {
                                Text("User")
                                    .font(.headline)
                                TextField("Username", text: $viewModel.username)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                            }
                            .padding()
                            .background(appBackgroundColor)
                            .cornerRadius(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                            )
                            
                            // Notification Time Section
                            VStack(alignment: .leading, spacing: 5) {
                                HStack {
                                    Text("Notification Time")
                                        .font(.headline)
                                    Spacer()
                                    DatePicker("", selection: $preferences.notificationTime, displayedComponents: .hourAndMinute)
                                        .labelsHidden()
                                        .onChange(of: preferences.notificationTime) { _ in
                                            NotificationManager.shared.scheduleDailyNotification(at: preferences.notificationTime)
                                        }
                                        .frame(maxWidth: geometry.size.width * 0.4)
                                }
                            }
                            .padding()
                            .background(appBackgroundColor)
                            .cornerRadius(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                            )
                            
                            // Content Preferences Section
                            VStack(alignment: .leading, spacing: 5) {
                                Text("Content Preferences")
                                    .font(.headline)
                                
                                VStack(spacing: 0) {
                                    NavigationLink(destination: QuotesView()) {
                                        HStack {
                                            Text("Quotes")
                                                .foregroundColor(.primary)
                                            Spacer()
                                                .frame(width: 238) // Set custom spacing here
                                            Image(systemName: "chevron.right")
                                                .foregroundColor(.gray)
                                        }
                                        .padding(.vertical, 15)
                                    }
                                    Divider()
                                    NavigationLink(destination: TipsView()) {
                                        HStack {
                                            Text("Tips")
                                                .foregroundColor(.primary)
                                            Spacer()
                                                .frame(width: 260)
                                            Image(systemName: "chevron.right")
                                                .foregroundColor(.gray)
                                        }
                                        .padding(.vertical, 15)
                                    }
                                    Divider()
                                    NavigationLink(destination: FactsView()) {
                                        HStack {
                                            Text("Facts")
                                                .foregroundColor(.primary)
                                            Spacer()
                                                .frame(width: 250)
                                            Image(systemName: "chevron.right")
                                                .foregroundColor(.gray)
                                        }
                                        .padding(.vertical, 15)
                                    }
                                }
                                .background(appBackgroundColor)
                                .cornerRadius(10)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                                )
                            }
                            .padding()
                            .background(appBackgroundColor)
                            .cornerRadius(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                            )
                            
                            // App Appearance Section
                            VStack(alignment: .leading, spacing: 5) {
                                Text("App Appearance")
                                        .font(.headline)
                                Picker("Theme", selection: $preferences.appTheme) {
                                    ForEach(AppTheme.allCases) { theme in
                                        Text(theme.description).tag(theme)
                                    }
                                }
                                .pickerStyle(SegmentedPickerStyle())
                                .padding(.horizontal)
                                .padding()
                                
                                Toggle("Dyslexic Friendly Mode", isOn: $preferences.useOpenDyslexicFont)
                                    .toggleStyle(SwitchToggleStyle(tint: .blue))
                                
                                Toggle("Use Cream Background", isOn: $preferences.useCreamBackground)
                                    .toggleStyle(SwitchToggleStyle(tint: .blue))
                            }
                            .padding()
                            .background(appBackgroundColor)
                            .cornerRadius(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                            )
                        }
                        .padding(.horizontal)
                    }
                }
            }
            .navigationBarHidden(true) // Hide the default navigation bar
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}
