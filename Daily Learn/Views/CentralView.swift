//
//  CentralView.swift
//  Daily Learn
//
//  Created by Jack white on 21/10/2024.
//

import SwiftUI

struct CentralView: View {
    @StateObject private var viewModel = CentralViewModel()
    @EnvironmentObject var preferences: PreferencesManager
    @State private var showShareSheet = false
    @State private var shareContent: String = ""
    @Environment(\.appBackgroundColor) var appBackgroundColor

    var body: some View {
        ZStack {
            appBackgroundColor
                .edgesIgnoringSafeArea(.all) // Extend the background color to cover the entire screen

            VStack {
                Text(Constants.appName)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding()

                Text("Good \(getGreeting()), \(preferences.username)")
                    .font(.headline)
                    .padding(.bottom)

                Text(getFormattedDate())
                    .font(.title2)
                    .padding(.bottom)

                ScrollView {
                    if viewModel.hasMeaningfulContent() {
                        if let dailyLearn = viewModel.dailyLearn {
                            VStack(alignment: .leading, spacing: 10) {
                                if let quote = dailyLearn.quote {
                                    Text("Quote (\(quote.category)):")
                                        .font(.headline)
                                    Text("\"\(quote.content)\"")
                                        .italic()
                                    if let author = quote.author {
                                        Text("- \(author)")
                                    }
                                    Spacer().frame(height: 10)
                                }

                                if let tip = dailyLearn.tip {
                                    Text("Tip (\(tip.category)):")
                                        .font(.headline)
                                    Text(tip.content)
                                    Spacer().frame(height: 10)
                                }

                                if let fact = dailyLearn.fact {
                                    Text("Fact (\(fact.category)):")
                                        .font(.headline)
                                    Text(fact.content)
                                }
                            }
                            .padding()
                        }
                    } else {
                        VStack(alignment: .leading, spacing: 10) {
                            Text("""
                            Your Daily Learn will be ready tomorrow!

                            For now, go to Settings to set your content preferences and the time you'd like to receive your notification.

                            Then explore all the Learns under 'More'.

                            Also check out the Burn Boxes to get some stuff off your chest...

                            If you have lots to do today but don't know where to start, check out the super useful prioritization matrix!
                            """)
                                .padding(.top)
                        }
                        .padding()
                        .font(.body)
                    }
                }

                Button(action: {
                    shareLearn()
                }) {
                    Image(systemName: "square.and.arrow.up")
                        .font(.title)
                        .foregroundColor(.primary)
                }
                .disabled(!viewModel.hasMeaningfulContent())
                .padding()
            }
            .frame(maxWidth: .infinity) // Make VStack fill the available width
        }
        .onAppear {
            viewModel.loadDailyLearn()
        }
        .sheet(isPresented: $showShareSheet) {
            ActivityView(activityItems: [shareContent])
        }
    }

    // Helper functions for greeting and formatted date
    func getGreeting() -> String {
        let hour = Calendar.current.component(.hour, from: Date())
        switch hour {
        case 5..<12:
            return "morning"
        case 12..<18:
            return "afternoon"
        default:
            return "evening"
        }
    }

    func getFormattedDate() -> String {
        let date = Date()
        let calendar = Calendar.current

        let day = calendar.component(.day, from: date)
        let weekday = calendar.weekdaySymbols[calendar.component(.weekday, from:    date) - 1]
        let month = calendar.monthSymbols[calendar.component(.month, from: date) - 1]

        let daySuffix: String
        switch day {
        case 11, 12, 13:
            daySuffix = "th"
        default:
            switch day % 10 {
            case 1:
                daySuffix = "st"
            case 2:
                daySuffix = "nd"
            case 3:
                daySuffix = "rd"
            default:
                daySuffix = "th"
            }
        }

        return "\(weekday) \(day)\(daySuffix) \(month)'s Learn"
    }

    func shareLearn() {
        viewModel.loadDailyLearn()
        if let dailyLearn = viewModel.dailyLearn {
            shareContent = prepareShareContent(from: dailyLearn)
            DispatchQueue.main.async {
                self.showShareSheet = true
            }
        } else {
            print("Content is loading. Please try again in a moment.")
        }
    }

    func prepareShareContent(from learn: DailyLearn) -> String {
        var components: [String] = []
        components.append("Check out my Daily Learn!")

        if let quote = learn.quote {
            components.append("Quote (\(quote.category)): \"\(quote.content)\"")
            if let author = quote.author {
                components.append("- \(author)")
            }
        }

        if let tip = learn.tip {
            components.append("Tip (\(tip.category)): \(tip.content)")
        }

        if let fact = learn.fact {
            components.append("Fact (\(fact.category)): \(fact.content)")
        }

        components.append("\nDownload the app here: [https://apps.apple.com/gb/app/daily-learn/id6737246609]")
        return components.joined(separator: "\n\n")
    }
}

