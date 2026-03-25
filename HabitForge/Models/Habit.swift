import Foundation
import SwiftData
import SwiftUI

@Model
final class Habit {
    var id: UUID
    var name: String
    var iconName: String
    var colorHex: String
    var frequency: HabitFrequency
    var customDays: [Int]
    var reminderTime: Date?
    var reminderEnabled: Bool
    var createdDate: Date
    var order: Int

    @Relationship(deleteRule: .cascade, inverse: \HabitCompletion.habit)
    var completions: [HabitCompletion]

    @Relationship(inverse: \HabitGroup.habits)
    var group: HabitGroup?

    init(
        id: UUID = UUID(),
        name: String,
        iconName: String = "checkmark.circle.fill",
        colorHex: String = "#007AFF",
        frequency: HabitFrequency = .daily,
        customDays: [Int] = [],
        reminderTime: Date? = nil,
        reminderEnabled: Bool = false,
        createdDate: Date = Date(),
        order: Int = 0
    ) {
        self.id = id
        self.name = name
        self.iconName = iconName
        self.colorHex = colorHex
        self.frequency = frequency
        self.customDays = customDays
        self.reminderTime = reminderTime
        self.reminderEnabled = reminderEnabled
        self.createdDate = createdDate
        self.order = order
        self.completions = []
    }

    var color: Color {
        Color(hex: colorHex) ?? .blue
    }

    var currentStreak: Int {
        guard !completions.isEmpty else { return 0 }

        let sortedCompletions = completions
            .sorted { $0.date > $1.date }

        var streak = 0
        var currentDate = Calendar.current.startOfDay(for: Date())

        for completion in sortedCompletions {
            let completionDate = Calendar.current.startOfDay(for: completion.date)

            if completionDate == currentDate || completionDate == Calendar.current.date(byAdding: .day, value: -1, to: currentDate) {
                streak += 1
                currentDate = Calendar.current.date(byAdding: .day, value: -1, to: completionDate)!
            } else {
                break
            }
        }

        return streak
    }

    var longestStreak: Int {
        guard !completions.isEmpty else { return 0 }

        let sortedCompletions = completions
            .sorted { $0.date < $1.date }

        var maxStreak = 0
        var currentStreak = 0
        var lastDate: Date?

        for completion in sortedCompletions {
            let completionDate = Calendar.current.startOfDay(for: completion.date)

            if let last = lastDate {
                let daysDiff = Calendar.current.dateComponents([.day], from: last, to: completionDate).day ?? 0
                if daysDiff == 1 {
                    currentStreak += 1
                } else {
                    maxStreak = max(maxStreak, currentStreak)
                    currentStreak = 1
                }
            } else {
                currentStreak = 1
            }

            lastDate = completionDate
        }

        return max(maxStreak, currentStreak)
    }

    var totalCompletions: Int {
        completions.count
    }

    var completionRate: Double {
        let daysSinceCreation = Calendar.current.dateComponents([.day], from: createdDate, to: Date()).day ?? 0
        guard daysSinceCreation > 0 else { return 0 }
        return Double(totalCompletions) / Double(daysSinceCreation + 1)
    }

    func isCompletedToday() -> Bool {
        let today = Calendar.current.startOfDay(for: Date())
        return completions.contains { Calendar.current.isDate($0.date, inSameDayAs: today) }
    }

    func isScheduledFor(date: Date) -> Bool {
        switch frequency {
        case .daily:
            return true
        case .weekly:
            return true
        case .custom:
            let weekday = Calendar.current.component(.weekday, from: date)
            return customDays.contains(weekday)
        }
    }
}

enum HabitFrequency: String, Codable {
    case daily = "Daily"
    case weekly = "Weekly"
    case custom = "Custom"
}

extension Color {
    init?(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")

        var rgb: UInt64 = 0

        guard Scanner(string: hexSanitized).scanHexInt64(&rgb) else {
            return nil
        }

        let r = Double((rgb & 0xFF0000) >> 16) / 255.0
        let g = Double((rgb & 0x00FF00) >> 8) / 255.0
        let b = Double(rgb & 0x0000FF) / 255.0

        self.init(red: r, green: g, blue: b)
    }

    func toHex() -> String? {
        guard let components = UIColor(self).cgColor.components, components.count >= 3 else {
            return nil
        }

        let r = Int(components[0] * 255.0)
        let g = Int(components[1] * 255.0)
        let b = Int(components[2] * 255.0)

        return String(format: "#%02X%02X%02X", r, g, b)
    }
}
