import SwiftUI

struct CalendarHeatmapView: View {
    let habit: Habit
    @State private var currentMonth = Date()

    private var daysInMonth: [Date] {
        guard let range = Calendar.current.range(of: .day, in: .month, for: currentMonth) else {
            return []
        }

        return range.compactMap { day in
            Calendar.current.date(byAdding: .day, value: day - 1, to: currentMonth.startOfMonth())
        }
    }

    private var weekdayHeaders: [String] {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE"
        let weekdays = Calendar.current.shortWeekdaySymbols
        return weekdays
    }

    private var firstWeekdayOffset: Int {
        let firstDay = currentMonth.startOfMonth()
        return Calendar.current.component(.weekday, from: firstDay) - 1
    }

    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Button {
                    currentMonth = currentMonth.adding(months: -1)
                } label: {
                    Image(systemName: "chevron.left")
                        .foregroundStyle(.secondary)
                }

                Spacer()

                Text(currentMonth.monthYearString)
                    .font(.headline)

                Spacer()

                Button {
                    currentMonth = currentMonth.adding(months: 1)
                } label: {
                    Image(systemName: "chevron.right")
                        .foregroundStyle(.secondary)
                }
            }
            .padding(.horizontal)

            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: 8) {
                ForEach(weekdayHeaders, id: \.self) { weekday in
                    Text(String(weekday.prefix(1)))
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                }

                ForEach(0..<firstWeekdayOffset, id: \.self) { _ in
                    Color.clear
                        .frame(height: 40)
                }

                ForEach(daysInMonth, id: \.self) { date in
                    let isCompleted = habit.completions.contains { Calendar.current.isDate($0.date, inSameDayAs: date) }
                    let isToday = Calendar.current.isDate(date, inSameDayAs: Date())

                    ZStack {
                        RoundedRectangle(cornerRadius: 8)
                            .fill(isCompleted ? habit.color.opacity(0.8) : Color.gray.opacity(0.1))
                            .frame(height: 40)

                        if isToday {
                            RoundedRectangle(cornerRadius: 8)
                                .strokeBorder(habit.color, lineWidth: 2)
                                .frame(height: 40)
                        }

                        Text("\(Calendar.current.component(.day, from: date))")
                            .font(.caption)
                            .foregroundStyle(isCompleted ? .white : .primary)
                    }
                }
            }
            .padding(.horizontal)
        }
        .padding(.vertical)
    }
}
