//
//  QuotesView.swift
//  Daily Learn
//
//  Created by Jack White on 21/10/2024.
//

import SwiftUI

struct QuotesView: View {
    @EnvironmentObject var preferences: PreferencesManager // Use EnvironmentObject
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.appBackgroundColor) var appBackgroundColor // Access the app background color

    let categories = [
        "Buddhism", "David Goggins", "Epicureanism", "Existentialism",
        "Generic", "Hedonism", "Marcus Aurelius - Meditations", "Machiavelli",
        "Michel de Montaigne", "Michel Foucault", "Nihilism", "Politics",
        "Stoicism", "Taoism"
    ]

    var body: some View {
        ZStack {
            appBackgroundColor.edgesIgnoringSafeArea(.all) // Apply background color to entire view

            VStack {
                Form {
                    Toggle("Include Quotes", isOn: $preferences.includeQuotes)
                        .listRowBackground(appBackgroundColor) // Apply background to toggle row

                    Section(header: Text("Select Categories")) {
                        ForEach(categories, id: \.self) { category in
                            MultipleSelectionRow(
                                title: category,
                                isSelected: preferences.selectedQuoteCategories.contains(category),
                                action: {
                                    if preferences.selectedQuoteCategories.contains(category) {
                                        preferences.selectedQuoteCategories.removeAll { $0 == category }
                                    } else {
                                        preferences.selectedQuoteCategories.append(category)
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
                    presentationMode.wrappedValue.dismiss() // Dismiss only on Save
                }) {
                    Text("Save")
                        .applyPrimaryButtonStyle()
                        .frame(maxWidth: .infinity, alignment: .center)
                }
                .padding()
            }
        }
        .navigationBarTitle("Quote Preferences", displayMode: .inline)
    }
}

struct MultipleSelectionRow: View {
    var title: String
    var isSelected: Bool
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack {
                Text(title)
                Spacer()
                if isSelected {
                    Image(systemName: "checkmark")
                }
            }
        }
        .listRowBackground(appBackgroundColor) // Ensure background color is applied
    }

    @Environment(\.appBackgroundColor) var appBackgroundColor // Access background color
}
