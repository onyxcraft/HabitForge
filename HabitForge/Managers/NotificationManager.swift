import Foundation
import UserNotifications
import SwiftData

@MainActor
class NotificationManager: ObservableObject {
    static let shared = NotificationManager()

    private init() {}

    func requestAuthorization() async -> Bool {
        do {
            let granted = try await UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge])
            return granted
        } catch {
            print("Error requesting notification authorization: \(error)")
            return false
        }
    }

    func scheduleNotification(for habit: Habit) async {
        guard habit.reminderEnabled, let reminderTime = habit.reminderTime else { return }

        let content = UNMutableNotificationContent()
        content.title = "Time for \(habit.name)!"
        content.body = "Don't break your streak"
        content.sound = .default

        var dateComponents = Calendar.current.dateComponents([.hour, .minute], from: reminderTime)

        if habit.frequency == .custom {
            for day in habit.customDays {
                dateComponents.weekday = day
                let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
                let request = UNNotificationRequest(
                    identifier: "\(habit.id.uuidString)-\(day)",
                    content: content,
                    trigger: trigger
                )

                do {
                    try await UNUserNotificationCenter.current().add(request)
                } catch {
                    print("Error scheduling notification: \(error)")
                }
            }
        } else {
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
            let request = UNNotificationRequest(
                identifier: habit.id.uuidString,
                content: content,
                trigger: trigger
            )

            do {
                try await UNUserNotificationCenter.current().add(request)
            } catch {
                print("Error scheduling notification: \(error)")
            }
        }
    }

    func cancelNotification(for habit: Habit) {
        if habit.frequency == .custom {
            let identifiers = habit.customDays.map { "\(habit.id.uuidString)-\($0)" }
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: identifiers)
        } else {
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [habit.id.uuidString])
        }
    }

    func updateNotification(for habit: Habit) async {
        cancelNotification(for: habit)
        if habit.reminderEnabled {
            await scheduleNotification(for: habit)
        }
    }
}
