import Foundation
import SwiftData
import SwiftUI

@MainActor
@Observable
class HabitViewModel {
    var modelContext: ModelContext
    var habits: [Habit] = []
    var groups: [HabitGroup] = []
    var selectedGroup: HabitGroup?

    init(modelContext: ModelContext) {
        self.modelContext = modelContext
        fetchHabits()
        fetchGroups()
    }

    func fetchHabits() {
        let descriptor = FetchDescriptor<Habit>(sortBy: [SortDescriptor(\.order)])
        do {
            habits = try modelContext.fetch(descriptor)
        } catch {
            print("Error fetching habits: \(error)")
        }
    }

    func fetchGroups() {
        let descriptor = FetchDescriptor<HabitGroup>(sortBy: [SortDescriptor(\.order)])
        do {
            groups = try modelContext.fetch(descriptor)
        } catch {
            print("Error fetching groups: \(error)")
        }
    }

    func addHabit(_ habit: Habit) {
        habit.order = habits.count
        modelContext.insert(habit)
        saveContext()
        fetchHabits()

        if habit.reminderEnabled {
            Task {
                await NotificationManager.shared.scheduleNotification(for: habit)
            }
        }
    }

    func updateHabit(_ habit: Habit) {
        saveContext()
        fetchHabits()

        Task {
            await NotificationManager.shared.updateNotification(for: habit)
        }
    }

    func deleteHabit(_ habit: Habit) {
        NotificationManager.shared.cancelNotification(for: habit)
        modelContext.delete(habit)
        saveContext()
        fetchHabits()
    }

    func toggleCompletion(for habit: Habit, on date: Date = Date()) {
        let startOfDay = Calendar.current.startOfDay(for: date)

        if let existingCompletion = habit.completions.first(where: {
            Calendar.current.isDate($0.date, inSameDayAs: startOfDay)
        }) {
            modelContext.delete(existingCompletion)
        } else {
            let completion = HabitCompletion(date: startOfDay)
            completion.habit = habit
            habit.completions.append(completion)
            modelContext.insert(completion)
        }

        saveContext()
        fetchHabits()
    }

    func addGroup(_ group: HabitGroup) {
        group.order = groups.count
        modelContext.insert(group)
        saveContext()
        fetchGroups()
    }

    func updateGroup(_ group: HabitGroup) {
        saveContext()
        fetchGroups()
    }

    func deleteGroup(_ group: HabitGroup) {
        modelContext.delete(group)
        saveContext()
        fetchGroups()
    }

    func filteredHabits() -> [Habit] {
        if let selectedGroup = selectedGroup {
            return habits.filter { $0.group?.id == selectedGroup.id }
        }
        return habits
    }

    private func saveContext() {
        do {
            try modelContext.save()
        } catch {
            print("Error saving context: \(error)")
        }
    }
}
