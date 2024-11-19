//
//  FactsView.swift
//  Daily Learn
//
//  Created by Jack white on 21/10/2024.
//

import SwiftUI

struct FactsView: View {
    @EnvironmentObject var preferences: PreferencesManager
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.appBackgroundColor) var appBackgroundColor

    let categories = [
        "Aeronautical Engineering", "Air Engineering Officer", "Avionics", "Coffee", "Cats", "Dogs",
        "Material Science", "Marine Engineering", "Political History", "Royal Navy History", "REME Corps",
        "The Roman Empire", "The Age Of Surveillance Capitalism", "Watches", "Weapons Engineering"
    ]
    
    var body: some View {
        ZStack {
            appBackgroundColor.edgesIgnoringSafeArea(.all)
            
            VStack {
                Form {
                    Toggle("Include Tips", isOn: $preferences.includeFacts)
                        .listRowBackground(appBackgroundColor)

                    Section(header: Text("Select Categories")) {
                        ForEach(categories, id: \.self) { category in
                            MultipleSelectionRow(
                                title: category,
                                isSelected: preferences.selectedFactCategories.contains(category),
                                action: {
                                    if preferences.selectedFactCategories.contains(category) {
                                        preferences.selectedFactCategories.removeAll { $0 == category }
                                    } else {
                                        preferences.selectedFactCategories.append(category)
                                    }
                                }
                            )
                        }
                    }
                    .listRowBackground(appBackgroundColor)
                }
                .background(appBackgroundColor)
                .padding(.bottom, 7) // Add padding to prevent content from going under the navigation bar

                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Save")
                        .applyPrimaryButtonStyle()
                        .frame(maxWidth: .infinity, alignment: .center)
                }
                .padding()
            }
        }
        .navigationBarTitle("Fact Preferences", displayMode: .inline)
    }
}
