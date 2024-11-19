//
//  TipsView.swift
//  Daily Learn
//
//  Created by Jack White on 21/10/2024.
//

import SwiftUI

struct TipsView: View {
    @EnvironmentObject var preferences: PreferencesManager // Use EnvironmentObject
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.appBackgroundColor) var appBackgroundColor // Access the app background color

    let categories = [
        "Communication", "Cleaning", "Cooking", "Finance", "Fitness", "Health",
        "Leadership", "Leil Lowends 'How To Talk To Anyone' Tips", "The 5 AM Club", "The 48 Laws Of Power"
    ]

    var body: some View {
        ZStack {
            appBackgroundColor.edgesIgnoringSafeArea(.all) // Apply background color to entire view

            VStack {
                Form {
                    Toggle("Include Tips", isOn: $preferences.includeTips)
                        .listRowBackground(appBackgroundColor) // Apply background to toggle row

                    Section(header: Text("Select Categories")) {
                        ForEach(categories, id: \.self) { category in
                            MultipleSelectionRow(
                                title: category,
                                isSelected: preferences.selectedTipCategories.contains(category),
                                action: {
                                    if preferences.selectedTipCategories.contains(category) {
                                        preferences.selectedTipCategories.removeAll { $0 == category }
                                    } else {
                                        preferences.selectedTipCategories.append(category)
                                    }
                                }
                            )
                        }
                    }
                    .listRowBackground(appBackgroundColor) // Apply background to section
                }
                .background(appBackgroundColor) // Apply background to form
                .padding(.bottom, 10) // Add padding to prevent content from going under the navigation bar

                Button(action: {
                    presentationMode.wrappedValue.dismiss() // Dismiss the view on Save
                }) {
                    Text("Save")
                        .applyPrimaryButtonStyle()
                        .frame(maxWidth: .infinity, alignment: .center)
                }
                .padding()
            }
        }
        .navigationBarTitle("Tip Preferences", displayMode: .inline)
    }
}
