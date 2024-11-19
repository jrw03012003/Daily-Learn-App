//
//  RootView.swift
//  test 2 app
//
//  Created by Jack white on 28/10/2024.
//

import SwiftUI

struct RootView: View {
    @EnvironmentObject var preferences: PreferencesManager
    @AppStorage("useCreamBackground") private var useCreamBackground: Bool = false
    @Environment(\.colorScheme) var colorScheme // Detect the system color scheme

    var body: some View {
        TabView {
            CentralView()
                .tabItem {
                    Image(systemName: "house")
                    Text("Home")
                }

            MoreView()
                .tabItem {
                    Image(systemName: "brain")
                    Text("More")
                }

            BurnBoxesView()
                .tabItem {
                    Image(systemName: "flame")
                    Text("Burn Boxes")
                }
            
            EisenhowerMatrixView()
                .tabItem {
                    Image(systemName: "square.grid.2x2")
                    Text("Matrix")
                }

            SettingsView()
                .tabItem {
                    Image(systemName: "gearshape")
                    Text("Settings")
                }
        }
        .applyTheme(preferences.appTheme)
        .background(appBackgroundColor.edgesIgnoringSafeArea(.all))
        .onAppear {
            updateTabBarAppearance()
        }
        .onChange(of: preferences.appTheme) { _ in
            updateTabBarAppearance()
        }
        .onChange(of: colorScheme) { _ in
            updateTabBarAppearance()
        }
    }

    
    var appBackgroundColor: Color {
            useCreamBackground ? Color("CreamBackground") : Color("WhiteBackground")
    }
    
    
    func updateTabBarAppearance() {
        let appearance = UITabBarAppearance()
        
        // Set the default (unselected) item appearance
        appearance.configureWithTransparentBackground()
        
        // In light mode, unselected tab items should be darkGray; in dark mode, they should be lightGray
        appearance.stackedLayoutAppearance.normal.iconColor = colorScheme == .dark ? .lightGray : .darkGray
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [
            .foregroundColor: colorScheme == .dark ? UIColor.lightGray : UIColor.darkGray
        ]
        
        // Set selected item tint color to blue
        appearance.stackedLayoutAppearance.selected.iconColor = UIColor.systemBlue
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [.foregroundColor: UIColor.systemBlue]
        
        // Apply this appearance to the tab bar
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }
}


extension Color {
    static func appBackground(useCream: Bool) -> Color {
        if useCream {
            return Color("CreamBackground")
        } else {
            return Color("WhiteBackground")
        }
    }
}
