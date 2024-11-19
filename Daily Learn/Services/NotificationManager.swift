//
//  NotificationManager.swift
//  Daily Learn
//
//  Created by Jack white on 21/10/2024.
//

import UserNotifications

class NotificationManager {
    static let shared = NotificationManager()

    func scheduleDailyNotification(at time: Date) {
        let content = UNMutableNotificationContent()
        content.title = "Your Daily Learn is Ready!"
        content.body = "Open the app to view your new Daily Learn."
        content.sound = .default

        let calendar = Calendar.current
        let dateComponents = calendar.dateComponents([.hour, .minute], from: time)

        var triggerDateComponents = DateComponents()
        triggerDateComponents.hour = dateComponents.hour
        triggerDateComponents.minute = dateComponents.minute

        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDateComponents, repeats: true)

        let request = UNNotificationRequest(identifier: "dailyLearnNotification", content: content, trigger: trigger)

        // Remove existing notifications before adding a new one
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["dailyLearnNotification"])

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling notification: \(error.localizedDescription)")
            } else {
                print("Notification scheduled successfully.")
            }
        }
    }

    func requestNotificationAuthorization() {
        let options: UNAuthorizationOptions = [.alert, .sound]

        UNUserNotificationCenter.current().requestAuthorization(options: options) { granted, error in
            if granted {
                print("Notification permission granted.")
            } else if let error = error {
                print("Error requesting notification permission: \(error.localizedDescription)")
            } else {
                print("Notification permission denied.")
            }
        }
    }

    func cancelAllNotifications() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }
}
