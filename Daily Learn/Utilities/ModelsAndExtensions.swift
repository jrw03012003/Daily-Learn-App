//
//  Extensions.swift
//  Daily Learn
//
//  Created by Jack white on 21/10/2024.
//

import SwiftUI
import Foundation


extension View {
    func applyPrimaryButtonStyle() -> some View {
        self.modifier(PrimaryButtonStyle())
    }
}

struct PrimaryButtonStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .font(.headline)  // Makes the text bold and prominent
            .cornerRadius(10)
            .padding(.horizontal)
            .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 2)  // Adds a subtle shadow for depth
    }
}


extension UserDefaults {
    func setArray<T: Codable>(_ array: [T], forKey key: String) {
        if let data = try? JSONEncoder().encode(array) {
            set(data, forKey: key)
        }
    }
    
    func getArray<T: Codable>(forKey key: String) -> [T] {
        if let data = data(forKey: key), let array = try? JSONDecoder().decode([T].self, from: data) {
            return array
        }
        return []
    }
}


extension View {
    func applyTheme(_ theme: AppTheme) -> some View {
        modifier(ThemeModifier(theme: theme))
    }
}

struct ThemeModifier: ViewModifier {
    let theme: AppTheme

    func body(content: Content) -> some View {
        content
            .preferredColorScheme(theme.colorScheme)
    }
}

extension AppTheme {
    var colorScheme: ColorScheme? {
        switch self {
        case .system:
            return nil // Use system appearance
        case .light:
            return .light
        case .dark:
            return .dark
        }
    }
}

// MARK: - Custom Environment Key for App Background Color
private struct AppBackgroundColorKey: EnvironmentKey {
    static let defaultValue: Color = Color("WhiteBackground")
}

extension EnvironmentValues {
    var appBackgroundColor: Color {
        get { self[AppBackgroundColorKey.self] }
        set { self[AppBackgroundColorKey.self] = newValue }
    }
}


struct TaskItem: Identifiable, Equatable {
    let id = UUID()
    var description: String = ""
    var isCompleted: Bool = false
}

enum Quadrant: Int, CaseIterable, Identifiable {
    case doFirst = 1
    case schedule
    case delegate
    case eliminate

    var id: Int { self.rawValue }

    var title: String {
        switch self {
        case .doFirst: return "Do First"
        case .schedule: return "Schedule"
        case .delegate: return "Delegate"
        case .eliminate: return "Eliminate"
        }
    }

    var description: String {
        switch self {
        case .doFirst: return "Urgent and important tasks. Do them immediately."
        case .schedule: return "Important but not urgent tasks. Schedule them."
        case .delegate: return "Urgent but less important tasks. Delegate if possible."
        case .eliminate: return "Neither urgent nor important tasks. Eliminate them."
        }
    }
}
