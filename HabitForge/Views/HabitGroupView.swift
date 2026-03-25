import SwiftUI

struct HabitGroupView: View {
    @ObservedObject var viewModel: HabitViewModel
    @Environment(\.dismiss) private var dismiss

    @State private var showingAddGroup = false
    @State private var newGroupName = ""
    @State private var newGroupIcon = "folder.fill"
    @State private var newGroupColor = Color.orange

    var body: some View {
        NavigationStack {
            List {
                ForEach(viewModel.groups) { group in
                    HStack {
                        Image(systemName: group.iconName)
                            .foregroundStyle(group.color)

                        Text(group.name)

                        Spacer()

                        Text("\(group.habits.count)")
                            .foregroundStyle(.secondary)
                            .font(.caption)
                    }
                }
                .onDelete { indexSet in
                    indexSet.forEach { index in
                        viewModel.deleteGroup(viewModel.groups[index])
                    }
                }
            }
            .navigationTitle("Groups")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Close") {
                        dismiss()
                    }
                }

                ToolbarItem(placement: .primaryAction) {
                    Button {
                        showingAddGroup = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAddGroup) {
                NavigationStack {
                    Form {
                        TextField("Group Name", text: $newGroupName)
                        ColorPicker("Color", selection: $newGroupColor)
                    }
                    .navigationTitle("New Group")
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .cancellationAction) {
                            Button("Cancel") {
                                showingAddGroup = false
                                newGroupName = ""
                            }
                        }

                        ToolbarItem(placement: .confirmationAction) {
                            Button("Save") {
                                let group = HabitGroup(
                                    name: newGroupName,
                                    colorHex: newGroupColor.toHex() ?? "#FF9500"
                                )
                                viewModel.addGroup(group)
                                showingAddGroup = false
                                newGroupName = ""
                            }
                            .disabled(newGroupName.isEmpty)
                        }
                    }
                }
            }
        }
    }
}
