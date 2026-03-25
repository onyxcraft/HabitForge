import SwiftUI

struct HabitFormView: View {
    @ObservedObject var viewModel: HabitViewModel
    @Environment(\.dismiss) private var dismiss

    @State private var name = ""
    @State private var selectedIcon = "checkmark.circle.fill"
    @State private var selectedColor = Color.blue
    @State private var frequency = HabitFrequency.daily
    @State private var customDays: Set<Int> = []
    @State private var reminderEnabled = false
    @State private var reminderTime = Date()
    @State private var selectedGroup: HabitGroup?
    @State private var showingIconPicker = false

    let habit: Habit?

    init(viewModel: HabitViewModel, habit: Habit? = nil) {
        self.viewModel = viewModel
        self.habit = habit

        if let habit = habit {
            _name = State(initialValue: habit.name)
            _selectedIcon = State(initialValue: habit.iconName)
            _selectedColor = State(initialValue: habit.color)
            _frequency = State(initialValue: habit.frequency)
            _customDays = State(initialValue: Set(habit.customDays))
            _reminderEnabled = State(initialValue: habit.reminderEnabled)
            _reminderTime = State(initialValue: habit.reminderTime ?? Date())
            _selectedGroup = State(initialValue: habit.group)
        }
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("Basic Info") {
                    TextField("Habit Name", text: $name)

                    Button {
                        showingIconPicker = true
                    } label: {
                        HStack {
                            Text("Icon")
                            Spacer()
                            Image(systemName: selectedIcon)
                                .foregroundStyle(selectedColor)
                                .font(.title2)
                        }
                    }

                    ColorPicker("Color", selection: $selectedColor, supportsOpacity: false)
                }

                Section("Frequency") {
                    Picker("Frequency", selection: $frequency) {
                        Text("Daily").tag(HabitFrequency.daily)
                        Text("Weekly").tag(HabitFrequency.weekly)
                        Text("Custom").tag(HabitFrequency.custom)
                    }
                    .pickerStyle(.segmented)

                    if frequency == .custom {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Select Days")
                                .font(.caption)
                                .foregroundStyle(.secondary)

                            HStack {
                                ForEach(1...7, id: \.self) { day in
                                    let daySymbol = Calendar.current.shortWeekdaySymbols[day == 1 ? 0 : day - 1]
                                    Button {
                                        if customDays.contains(day) {
                                            customDays.remove(day)
                                        } else {
                                            customDays.insert(day)
                                        }
                                    } label: {
                                        Text(String(daySymbol.prefix(1)))
                                            .font(.caption)
                                            .fontWeight(.semibold)
                                            .frame(width: 36, height: 36)
                                            .background(
                                                Circle()
                                                    .fill(customDays.contains(day) ? selectedColor : Color.gray.opacity(0.2))
                                            )
                                            .foregroundStyle(customDays.contains(day) ? .white : .primary)
                                    }
                                    .buttonStyle(.plain)
                                }
                            }
                        }
                    }
                }

                if !viewModel.groups.isEmpty {
                    Section("Group") {
                        Picker("Group", selection: $selectedGroup) {
                            Text("None").tag(nil as HabitGroup?)
                            ForEach(viewModel.groups) { group in
                                HStack {
                                    Image(systemName: group.iconName)
                                    Text(group.name)
                                }
                                .tag(group as HabitGroup?)
                            }
                        }
                    }
                }

                Section("Reminder") {
                    Toggle("Enable Reminder", isOn: $reminderEnabled)

                    if reminderEnabled {
                        DatePicker("Time", selection: $reminderTime, displayedComponents: .hourAndMinute)
                    }
                }
            }
            .navigationTitle(habit == nil ? "New Habit" : "Edit Habit")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }

                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        saveHabit()
                    }
                    .disabled(name.isEmpty || (frequency == .custom && customDays.isEmpty))
                }
            }
            .sheet(isPresented: $showingIconPicker) {
                SFSymbolPicker(selectedSymbol: $selectedIcon)
            }
        }
    }

    private func saveHabit() {
        if let habit = habit {
            habit.name = name
            habit.iconName = selectedIcon
            habit.colorHex = selectedColor.toHex() ?? "#007AFF"
            habit.frequency = frequency
            habit.customDays = Array(customDays)
            habit.reminderEnabled = reminderEnabled
            habit.reminderTime = reminderEnabled ? reminderTime : nil
            habit.group = selectedGroup

            viewModel.updateHabit(habit)
        } else {
            let newHabit = Habit(
                name: name,
                iconName: selectedIcon,
                colorHex: selectedColor.toHex() ?? "#007AFF",
                frequency: frequency,
                customDays: Array(customDays),
                reminderTime: reminderEnabled ? reminderTime : nil,
                reminderEnabled: reminderEnabled
            )
            newHabit.group = selectedGroup

            viewModel.addHabit(newHabit)
        }

        dismiss()
    }
}
