//
//  SavedPagesView.swift
//  test 2 app
//
//  Created by Jack White on 14/11/2024.
//

import SwiftUI

struct SavedPagesView: View {
    @EnvironmentObject var preferences: PreferencesManager
    @Environment(\.appBackgroundColor) var appBackgroundColor

    var body: some View {
        ZStack {
            appBackgroundColor.edgesIgnoringSafeArea(.all) // Background at the back

            VStack {
                if preferences.savedPages.isEmpty {
                    Spacer()
                    Text("No saved pages.")
                        .foregroundColor(.gray)
                    Spacer()
                } else {
                    List {
                        ForEach(preferences.savedPages) { page in
                            SavedPageRow(page: page, onDelete: {
                                preferences.removeSavedPage(with: page.id)
                            })
                            .listRowBackground(Color.clear) // Make row background transparent
                        }
                    }
                    .listStyle(PlainListStyle()) // Use PlainListStyle for better control
                    .background(Color.clear) // Make List background transparent
                }
            }
            .background(Color.clear) // Ensure VStack has transparent background
        }
        .navigationBarTitle("Saved Pages", displayMode: .inline)
    }
}

struct SavedPageRow: View {
    var page: SavedPage
    var onDelete: () -> Void
    @State private var isExpanded: Bool = false
    @State private var showDeleteAlert: Bool = false

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(page.boxName)
                    .font(.headline)
                Spacer()
                Text(formatDate(page.timestamp))
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            if isExpanded {
                Text(page.content)
                    .font(.body)
                    .foregroundColor(.primary)
            } else {
                Text(page.content)
                    .font(.body)
                    .foregroundColor(.primary)
                    .lineLimit(3) // Limit to 3 lines when not expanded
            }
            HStack {
                Button(action: {
                    isExpanded.toggle()
                }) {
                    Text(isExpanded ? "Show Less" : "Continue Reading")
                        .font(.caption)
                        .foregroundColor(.blue)
                        .padding(.vertical, 4)
                        .padding(.horizontal, 8)
                }
                .buttonStyle(PlainButtonStyle())
                .contentShape(Rectangle())

                Spacer()

                Button(action: {
                    showDeleteAlert = true
                }) {
                    Text("Delete")
                        .font(.caption)
                        .foregroundColor(.red)
                        .padding(.vertical, 4)
                        .padding(.horizontal, 8)
                }
                .buttonStyle(PlainButtonStyle())
                .contentShape(Rectangle())
                .alert(isPresented: $showDeleteAlert) {
                    Alert(
                        title: Text("Delete Saved Page"),
                        message: Text("Are you sure you want to delete this saved page?"),
                        primaryButton: .destructive(Text("Delete")) {
                            onDelete()
                        },
                        secondaryButton: .cancel()
                    )
                }
            }
        }
        .padding(.vertical, 8)
        .contentShape(Rectangle())
    }

    // Helper to format date
    func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}
