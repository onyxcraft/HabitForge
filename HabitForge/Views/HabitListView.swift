import SwiftUI
import SwiftData

struct HabitListView: View {
    @Environment(\.modelContext) private var modelContext
    @StateObject private var viewModel: HabitViewModel
    @State private var showingAddHabit = false
    @State private var selectedHabit: Habit?

    init(modelContext: ModelContext) {
        _viewModel = StateObject(wrappedValue: HabitViewModel(modelContext: modelContext))
    }

    var body: some View {
        NavigationStack {
            ZStack {
                if viewModel.filteredHabits().isEmpty {
                    VStack(spacing: 16) {
                        Image(systemName: "checkmark.circle")
                            .font(.system(size: 64))
                            .foregroundStyle(.secondary)

                        Text("No Habits Yet")
                            .font(.title2)
                            .fontWeight(.semibold)

                        Text("Tap + to create your first habit")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                } else {
                    List {
                        if !viewModel.groups.isEmpty {
                            Picker("Group", selection: $viewModel.selectedGroup) {
                                Text("All Habits").tag(nil as HabitGroup?)
                                ForEach(viewModel.groups) { group in
                                    HStack {
                                        Image(systemName: group.iconName)
                                        Text(group.name)
                                    }
                                    .tag(group as HabitGroup?)
                                }
                            }
                            .pickerStyle(.menu)
                        }

                        ForEach(viewModel.filteredHabits()) { habit in
                            HabitRowView(habit: habit) {
                                viewModel.toggleCompletion(for: habit)
                            }
                            .onTapGesture {
                                selectedHabit = habit
                            }
                            .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                                Button(role: .destructive) {
                                    viewModel.deleteHabit(habit)
                                } label: {
                                    Label("Delete", systemImage: "trash")
                                }
                            }
                        }
                        .onMove { from, to in
                            var habits = viewModel.filteredHabits()
                            habits.move(fromOffsets: from, toOffset: to)
                            for (index, habit) in habits.enumerated() {
                                habit.order = index
                            }
                            viewModel.updateHabit(habits[0])
                        }
                    }
                    .listStyle(.insetGrouped)
                }
            }
            .navigationTitle("HabitForge")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    if !viewModel.filteredHabits().isEmpty {
                        EditButton()
                    }
                }

                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showingAddHabit = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAddHabit) {
                HabitFormView(viewModel: viewModel)
            }
            .sheet(item: $selectedHabit) { habit in
                HabitDetailView(habit: habit, viewModel: viewModel)
            }
        }
    }
}
