//
//  BurnBoxesView.swift
//  test 2 app
//
//  Created by Jack white on 12/11/2024.
//

import SwiftUI
import LocalAuthentication

struct BurnBoxesView: View {
    @StateObject private var viewModel = BurnBoxesViewModel()
    @State private var showInfoAlert = false
    @State private var isAuthenticationRequired: Bool = false
    @State private var authenticationSuccess: Bool = false // Tracks if user authenticated successfully
    @Environment(\.appBackgroundColor) var appBackgroundColor

    // Define the burn boxes
    let burnBoxes = [
        "Gratitudes", "Resentments", "Learnings", "Ambitions",
        "Achievements", "General log", "Goals/\nIntentions", "Emotional\nState"
    ]

    // Define the grid layout
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    var body: some View {
        NavigationView {
            VStack {
                ZStack {
                    // Centered Title
                    Text("Burn Boxes")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding()
                                
                    // Info Button aligned to the right
                    HStack {
                        Spacer()
                        Button(action: {
                            showInfoAlert = true
                        }) {
                            Image(systemName: "info.circle")
                                .font(.title2)
                        }
                        .padding()
                        .alert(isPresented: $showInfoAlert) {
                            Alert(
                                title: Text("About Burn Boxes"),
                                message: Text("Burn Boxes allow you to express and release your thoughts, feelings, and emotions. Write anything that's on your mind and symbolically burn it to help come to terms with your internal experiences."),
                                dismissButton: .default(Text("Got it!"))
                            )
                        }
                    }
                }
                
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 20) {
                        ForEach(burnBoxes, id: \.self) { boxName in
                            NavigationLink(destination: BurnPageView(boxName: boxName)) {
                                Text(boxName)
                                    .font(.title3)
                                    .fontWeight(.bold)
                                    .foregroundColor(.blue)
                                    .multilineTextAlignment(.center)
                                    .lineLimit(nil)
                                    .fixedSize(horizontal: true, vertical: true)
                                    .padding()
                                    .frame(maxWidth: .infinity, minHeight: 100)
                                    .background(Color.gray.opacity(0.2))
                                    .cornerRadius(15)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 15)
                                            .stroke(Color.gray, lineWidth: 1)
                                    )
                                    .padding([.leading, .trailing], 5)
                            }
                        }
                    }
                    .padding()
                }
                
                // Saved Pages button at the bottom
                Button(action: {
                    authenticateUser()
                }) {
                    Text("Saved Pages")
                        .applyPrimaryButtonStyle()
                }
                .padding()
                
                // Conditional navigation to SavedPagesView if authenticated successfully
                NavigationLink(destination: SavedPagesView(), isActive: $authenticationSuccess) {
                    EmptyView()
                }
            }
            .background(appBackgroundColor)
            .navigationBarHidden(true)
        }
        .navigationViewStyle(StackNavigationViewStyle()) // Enforce stack navigation style
        .background(appBackgroundColor)
    }

    // MARK: - Authentication

    func authenticateUser() {
        let context = LAContext()
        var error: NSError?

        // Check if device supports biometric/passcode authentication
        if context.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error) {
            let reason = "Authenticate to view your saved pages."
            context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: reason) { success, authenticationError in
                DispatchQueue.main.async {
                    if success {
                        // Authentication succeeded, navigate to SavedPagesView
                        self.authenticationSuccess = true
                    } else {
                        // Authentication failed or canceled, remain on BurnBoxesView
                        self.authenticationSuccess = false
                    }
                }
            }
        } else {
            // If device doesn't support authentication
            // Option: We could allow access or show an alert
            // For simplicity, let's just allow access:
            self.authenticationSuccess = true
        }
    }
}
