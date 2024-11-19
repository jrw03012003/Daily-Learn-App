//
//  BurnPageView.swift
//  test 2 app
//
//  Created by Jack white on 12/11/2024.
//

import SwiftUI

struct BurnPageView: View {
    let boxName: String
    @State private var userInput: String = ""
    @State private var showInfoAlert: Bool = false
    @State private var showBurnAnimation: Bool = false
    @State private var didSaveContent: Bool = false // Tracks if content was saved
    @EnvironmentObject var preferences: PreferencesManager
    @Environment(\.appBackgroundColor) var appBackgroundColor

    var body: some View {
        VStack {
            headerView

            ZStack(alignment: .topLeading) {
                if showBurnAnimation {
                    FireAnimationView()
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                // Reset after animation
                                showBurnAnimation = false
                                userInput = ""
                            }
                        }
                } else {
                    // Main text editor
                    CustomTextEditor(
                        text: $userInput,
                        backgroundColor: UIColor(appBackgroundColor),
                        font: preferences.useOpenDyslexicFont
                            ? UIFont(name: "OpenDyslexic3-Regular", size: 17) ?? UIFont.systemFont(ofSize: 17)
                            : UIFont.systemFont(ofSize: 17)
                    )
                    .padding()
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.gray, lineWidth: 1)
                    )
                    .cornerRadius(10)
                    .padding()
                }

                // Placeholder text
                if userInput.isEmpty && !showBurnAnimation {
                    Text(placeholderText(for: boxName))
                        .foregroundColor(.gray)
                        .padding(.vertical, 70)
                        .padding(.horizontal, 24)
                        .fixedSize(horizontal: false, vertical: true)
                        .multilineTextAlignment(.leading)
                }
            }
            .animation(.easeInOut(duration: 0.5), value: showBurnAnimation)

            Spacer()

            HStack {
                saveButton
                Spacer() // Space between buttons
                burnButton
            }
            .padding()
        }
        .background(appBackgroundColor)
        .navigationBarHidden(true)
        .alert(isPresented: $showInfoAlert) {
            Alert(
                title: Text("About \(boxName)"),
                message: Text("This page allows you to write about your \(boxName.lowercased()). Express your thoughts freely and burn them to symbolically release your feelings."),
                dismissButton: .default(Text("Understood"))
            )
        }
        .onAppear {
            didSaveContent = false
        }
    }

    // MARK: - Views

    private var headerView: some View {
        HStack {
            Button(action: {
                // Custom back action
                presentationMode.wrappedValue.dismiss()
            }) {
                Image(systemName: "arrow.left")
                    .font(.title2)
            }
            .padding()

            Spacer()

            Text(boxName)
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding()

            Spacer()

            Button(action: {
                showInfoAlert = true
            }) {
                Image(systemName: "info.circle")
                    .font(.title2)
            }
            .padding()
        }
        .background(appBackgroundColor)
    }

    private var burnButton: some View {
        Button(action: {
            if !userInput.isEmpty {
                // Trigger burn animation
                showBurnAnimation = true
                hideKeyboard()
            }
        }) {
            Text("Burn")
                .applyPrimaryButtonStyle()
        }
    }

    private var saveButton: some View {
        Button(action: {
            if !userInput.isEmpty {
                preferences.addSavedPage(boxName: boxName, content: userInput)
                didSaveContent = true
                hideKeyboard()
            }
        }) {
            if didSaveContent {
                Image(systemName: "checkmark.circle")
                    .font(.title2)
            } else {
                Image(systemName: "square.and.arrow.down")
                    .font(.title2)
            }
        }
        .padding(.trailing)
        .disabled(userInput.isEmpty)
    }

    @Environment(\.presentationMode) var presentationMode

    // Hide keyboard utility
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }

    // Placeholder text logic
    func placeholderText(for boxName: String) -> String {
        switch boxName.lowercased() {
        case "gratitudes":
            return "Write down what's making you feel grateful. Even the simplest of things can bring great joy..."
        case "resentments":
            return "Write down what's making you feel resentful. Name them to let go of them..."
        case "learnings":
            return "Insights gained from experiences or challenges to internalize lessons and avoid repeating mistakes..."
        case "ambitions":
            return "Who do you want to be? What do you want to do? How do you want to do it?..."
        case "achievements":
            return "Reflect on recent accomplishments—no matter how small—to reinforce motivation and self-confidence..."
        case "general log":
            return "Reflect on what's been going on recently. Today, this week, this month, or this year!..."
        case "goals/\nintentions":
            return "Short, medium, and long-term goals. Think about the steps you might need to take to get there and what it will look like when you do..."
        case "emotional\nstate":
            return "Express your current feelings and emotions to better understand and regulate yourself. Create an emotional landscape..."
        default:
            return "Express your thoughts and feelings here..."
        }
    }
}
