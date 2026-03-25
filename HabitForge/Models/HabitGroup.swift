import Foundation
import SwiftData
import SwiftUI

@Model
final class HabitGroup {
    var id: UUID
    var name: String
    var iconName: String
    var colorHex: String
    var order: Int

    @Relationship(deleteRule: .nullify)
    var habits: [Habit]

    init(
        id: UUID = UUID(),
        name: String,
        iconName: String = "folder.fill",
        colorHex: String = "#FF9500",
        order: Int = 0
    ) {
        self.id = id
        self.name = name
        self.iconName = iconName
        self.colorHex = colorHex
        self.order = order
        self.habits = []
    }

    var color: Color {
        Color(hex: colorHex) ?? .orange
    }
}
