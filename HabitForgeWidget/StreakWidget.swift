import WidgetKit
import SwiftUI
import SwiftData

struct StreakEntry: TimelineEntry {
    let date: Date
    let topStreak: TopStreakData?
}

struct TopStreakData {
    let name: String
    let iconName: String
    let colorHex: String
    let streak: Int
}

struct StreakProvider: TimelineProvider {
    func placeholder(in context: Context) -> StreakEntry {
        StreakEntry(date: Date(), topStreak: nil)
    }

    func getSnapshot(in context: Context, completion: @escaping (StreakEntry) -> Void) {
        let entry = StreakEntry(date: Date(), topStreak: nil)
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<StreakEntry>) -> Void) {
        Task {
            let topStreak = await fetchTopStreak()
            let entry = StreakEntry(date: Date(), topStreak: topStreak)

            let nextUpdate = Calendar.current.date(byAdding: .hour, value: 1, to: Date())!
            let timeline = Timeline(entries: [entry], policy: .after(nextUpdate))

            completion(timeline)
        }
    }

    private func fetchTopStreak() async -> TopStreakData? {
        do {
            let container = try ModelContainer(
                for: Habit.self, HabitCompletion.self, HabitGroup.self
            )

            let context = ModelContext(container)
            let descriptor = FetchDescriptor<Habit>()
            let habits = try context.fetch(descriptor)

            guard let topHabit = habits.max(by: { $0.currentStreak < $1.currentStreak }),
                  topHabit.currentStreak > 0 else {
                return nil
            }

            return TopStreakData(
                name: topHabit.name,
                iconName: topHabit.iconName,
                colorHex: topHabit.colorHex,
                streak: topHabit.currentStreak
            )
        } catch {
            return nil
        }
    }
}

struct StreakWidgetView: View {
    var entry: StreakEntry

    var body: some View {
        if let streak = entry.topStreak {
            VStack(spacing: 8) {
                Image(systemName: streak.iconName)
                    .font(.system(size: 32))
                    .foregroundStyle(Color(hex: streak.colorHex) ?? .blue)

                Text(streak.name)
                    .font(.caption)
                    .fontWeight(.semibold)
                    .lineLimit(1)

                HStack(spacing: 4) {
                    Image(systemName: "flame.fill")
                        .foregroundStyle(.orange)
                        .font(.title2)

                    Text("\(streak.streak)")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundStyle(Color(hex: streak.colorHex) ?? .blue)
                }

                Text("day streak")
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }
            .padding()
            .containerBackground(for: .widget) {
                Color(uiColor: .systemBackground)
            }
        } else {
            VStack(spacing: 8) {
                Image(systemName: "flame")
                    .font(.system(size: 32))
                    .foregroundStyle(.gray)

                Text("No active streaks")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            .padding()
            .containerBackground(for: .widget) {
                Color(uiColor: .systemBackground)
            }
        }
    }
}

struct StreakWidget: Widget {
    let kind: String = "StreakWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: StreakProvider()) { entry in
            StreakWidgetView(entry: entry)
        }
        .configurationDisplayName("Top Streak")
        .description("Display your highest current streak")
        .supportedFamilies([.systemSmall])
    }
}
