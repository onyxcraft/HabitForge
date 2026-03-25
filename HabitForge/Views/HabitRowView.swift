import SwiftUI

struct HabitRowView: View {
    let habit: Habit
    let onToggle: () -> Void

    @State private var showAnimation = false

    var body: some View {
        HStack(spacing: 16) {
            Button {
                if !habit.isCompletedToday() {
                    showAnimation = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                        showAnimation = false
                    }
                }
                onToggle()
            } label: {
                ZStack {
                    Circle()
                        .stroke(habit.color, lineWidth: 2)
                        .frame(width: 50, height: 50)

                    if habit.isCompletedToday() {
                        Circle()
                            .fill(habit.color)
                            .frame(width: 50, height: 50)

                        Image(systemName: "checkmark")
                            .foregroundStyle(.white)
                            .font(.title3)
                            .fontWeight(.bold)
                    }
                }
            }
            .buttonStyle(.plain)
            .overlay {
                if showAnimation {
                    CompletionAnimationView(color: habit.color)
                }
            }

            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Image(systemName: habit.iconName)
                        .foregroundStyle(habit.color)
                        .font(.title3)

                    Text(habit.name)
                        .font(.headline)
                        .foregroundStyle(.primary)
                }

                if habit.currentStreak > 0 {
                    StreakFireView(streak: habit.currentStreak, color: habit.color)
                }
            }

            Spacer()

            if habit.currentStreak > 0 {
                VStack(alignment: .trailing, spacing: 2) {
                    Text("\(habit.currentStreak)")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundStyle(habit.color)

                    Text("day streak")
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                }
            }
        }
        .padding(.vertical, 8)
        .contentShape(Rectangle())
    }
}
