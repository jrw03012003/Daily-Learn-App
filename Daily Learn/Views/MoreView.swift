//
//  MoreView.swift
//  Daily Learn
//
//  Created by Jack white on 21/10/2024.
//

import SwiftUI

struct MoreView: View {
    @StateObject private var viewModel = MoreViewModel()
    @EnvironmentObject var preferences: PreferencesManager
    @Environment(\.appBackgroundColor) var appBackgroundColor


    var body: some View {
        VStack {
            Text("Explore More")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding()

            ScrollView {
                if let learn = viewModel.currentLearn {
                    VStack(alignment: .leading, spacing: 10) {
                        if let quote = learn.quote {
                            Text("Quote (\(quote.category)):")
                                .font(.headline)
                            Text("\"\(quote.content)\"")
                                .italic()
                            if let author = quote.author {
                                Text("- \(author)")
                            }
                            Spacer().frame(height: 10)
                        }

                        if let tip = learn.tip {
                            Text("Tip (\(tip.category)):")
                                .font(.headline)
                            Text(tip.content)
                            Spacer().frame(height: 10)
                        }

                        if let fact = learn.fact {
                            Text("Fact (\(fact.category)):")
                                .font(.headline)
                            Text(fact.content)
                        }
                    }
                    .padding()
                } else {
                    Text("Tap 'New Message' to explore more content.")
                        .padding()
                }
            }

            Button(action: {
                viewModel.fetchNewLearn()
            }) {
                Text("New Message")
                    .applyPrimaryButtonStyle()
            }
            .padding()
        }
        .background(appBackgroundColor)
        .onAppear {
            viewModel.fetchNewLearn()
        }
    }
}
