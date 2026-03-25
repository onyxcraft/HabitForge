import WidgetKit
import SwiftUI

@main
struct HabitForgeWidgetBundle: WidgetBundle {
    var body: some Widget {
        HabitChecklistWidget()
        StreakWidget()
    }
}
