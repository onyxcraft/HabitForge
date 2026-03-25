import SwiftUI

struct HabitDetailView: View {
    let habit: Habit
    @ObservedObject var viewModel: HabitViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var showingEditSheet = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    VStack(spacing: 16) {
                        ZStack {
                            Circle()
                                .fill(habit.color.opacity(0.2))
                                .frame(width: 100, height: 100)

                            Image(systemName: habit.iconName)
                                .font(.system(size: 50))
                                .foregroundStyle(habit.color)
                        }

                        Text(habit.name)
                            .font(.title)
                            .fontWeight(.bold)

                        if habit.currentStreak > 0 {
                            StreakFireView(streak: habit.currentStreak, color: habit.color)
                                .font(.title2)
                        }
                    }
                    .padding(.top)

                    StatsView(habit: habit)

                    VStack(alignment: .leading, spacing: 12) {
                        Text("Activity")
                            .font(.headline)
                            .padding(.horizontal)

                        CalendarHeatmapView(habit: habit)
                    }
                }
                .padding(.bottom)
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Close") {
                        dismiss()
                    }
                }

                ToolbarItem(placement: .primaryAction) {
                    Button {
                        showingEditSheet = true
                    } label: {
                        Text("Edit")
                    }
                }
            }
            .sheet(isPresented: $showingEditSheet) {
                HabitFormView(viewModel: viewModel, habit: habit)
            }
        }
    }
}
