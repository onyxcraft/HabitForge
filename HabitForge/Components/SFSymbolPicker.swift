import SwiftUI

struct SFSymbolPicker: View {
    @Binding var selectedSymbol: String
    @Environment(\.dismiss) private var dismiss

    let symbols = [
        "checkmark.circle.fill", "star.fill", "heart.fill", "flame.fill",
        "bolt.fill", "leaf.fill", "drop.fill", "sun.max.fill",
        "moon.fill", "sparkles", "book.fill", "dumbbell.fill",
        "figure.walk", "bicycle", "cup.and.saucer.fill", "fork.knife",
        "bed.double.fill", "brain.head.profile", "pawprint.fill", "tree.fill",
        "car.fill", "house.fill", "briefcase.fill", "graduationcap.fill",
        "music.note", "gamecontroller.fill", "paintbrush.fill", "camera.fill"
    ]

    let columns = [
        GridItem(.adaptive(minimum: 60))
    ]

    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 20) {
                    ForEach(symbols, id: \.self) { symbol in
                        Button {
                            selectedSymbol = symbol
                            dismiss()
                        } label: {
                            VStack {
                                Image(systemName: symbol)
                                    .font(.largeTitle)
                                    .foregroundStyle(selectedSymbol == symbol ? .blue : .primary)
                                    .frame(width: 60, height: 60)
                                    .background(
                                        RoundedRectangle(cornerRadius: 12)
                                            .fill(selectedSymbol == symbol ? Color.blue.opacity(0.2) : Color.clear)
                                    )
                            }
                        }
                    }
                }
                .padding()
            }
            .navigationTitle("Choose Icon")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
}
