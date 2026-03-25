import WidgetKit
import SwiftUI
import SwiftData

struct HabitChecklistEntry: TimelineEntry {
    let date: Date
    let habits: [HabitWidgetData]
}

struct HabitWidgetData: Identifiable {
    let id: UUID
    let name: String
    let iconName: String
    let colorHex: String
    let isCompleted: Bool
}

struct HabitChecklistProvider: TimelineProvider {
    func placeholder(in context: Context) -> HabitChecklistEntry {
        HabitChecklistEntry(date: Date(), habits: [])
    }

    func getSnapshot(in context: Context, completion: @escaping (HabitChecklistEntry) -> Void) {
        let entry = HabitChecklistEntry(date: Date(), habits: [])
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<HabitChecklistEntry>) -> Void) {
        Task {
            let habits = await fetchHabits()
            let entry = HabitChecklistEntry(date: Date(), habits: habits)

            let nextUpdate = Calendar.current.date(byAdding: .minute, value: 15, to: Date())!
            let timeline = Timeline(entries: [entry], policy: .after(nextUpdate))

            completion(timeline)
        }
    }

    private func fetchHabits() async -> [HabitWidgetData] {
        do {
            let container = try ModelContainer(
                for: Habit.self, HabitCompletion.self, HabitGroup.self
            )

            let context = ModelContext(container)
            let descriptor = FetchDescriptor<Habit>(sortBy: [SortDescriptor(\.order)])
            let habits = try context.fetch(descriptor)

            return habits.prefix(5).map { habit in
                HabitWidgetData(
                    id: habit.id,
                    name: habit.name,
                    iconName: habit.iconName,
                    colorHex: habit.colorHex,
                    isCompleted: habit.isCompletedToday()
                )
            }
        } catch {
            return []
        }
    }
}

struct HabitChecklistWidgetView: View {
    var entry: HabitChecklistEntry
    @Environment(\.widgetFamily) var widgetFamily

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundStyle(.blue)
                Text("Today's Habits")
                    .font(.headline)
            }

            if entry.habits.isEmpty {
                Text("No habits yet")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            } else {
                ForEach(entry.habits.prefix(widgetFamily == .systemSmall ? 3 : 5)) { habit in
                    HStack(spacing: 8) {
                        Image(systemName: habit.isCompleted ? "checkmark.circle.fill" : "circle")
                            .foregroundStyle(Color(hex: habit.colorHex) ?? .blue)

                        Text(habit.name)
                            .font(.caption)
                            .lineLimit(1)

                        Spacer()

                        Image(systemName: habit.iconName)
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                    }
                }
            }

            Spacer()
        }
        .padding()
        .containerBackground(for: .widget) {
            Color(uiColor: .systemBackground)
        }
    }
}

struct HabitChecklistWidget: Widget {
    let kind: String = "HabitChecklistWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: HabitChecklistProvider()) { entry in
            HabitChecklistWidgetView(entry: entry)
        }
        .configurationDisplayName("Habit Checklist")
        .description("View and track your daily habits")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}
