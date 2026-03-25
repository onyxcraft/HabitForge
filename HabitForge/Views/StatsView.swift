import SwiftUI

struct StatsView: View {
    let habit: Habit

    var body: some View {
        VStack(spacing: 16) {
            HStack(spacing: 16) {
                StatCard(
                    title: "Current Streak",
                    value: "\(habit.currentStreak)",
                    icon: "flame.fill",
                    color: .orange
                )

                StatCard(
                    title: "Longest Streak",
                    value: "\(habit.longestStreak)",
                    icon: "trophy.fill",
                    color: .yellow
                )
            }

            HStack(spacing: 16) {
                StatCard(
                    title: "Total",
                    value: "\(habit.totalCompletions)",
                    icon: "checkmark.circle.fill",
                    color: .green
                )

                StatCard(
                    title: "Success Rate",
                    value: String(format: "%.0f%%", habit.completionRate * 100),
                    icon: "chart.line.uptrend.xyaxis",
                    color: .blue
                )
            }
        }
        .padding(.horizontal)
    }
}

struct StatCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: icon)
                    .foregroundStyle(color)
                    .font(.title3)

                Spacer()
            }

            Text(value)
                .font(.title2)
                .fontWeight(.bold)

            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(uiColor: .secondarySystemGroupedBackground))
        )
    }
}
