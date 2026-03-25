import Foundation
import SwiftData

@Model
final class HabitCompletion {
    var id: UUID
    var date: Date
    var habit: Habit?

    init(id: UUID = UUID(), date: Date = Date()) {
        self.id = id
        self.date = date
    }
}
