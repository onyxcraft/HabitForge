import SwiftUI

extension Color {
    static let habitColors: [Color] = [
        .red, .orange, .yellow, .green, .mint, .teal,
        .cyan, .blue, .indigo, .purple, .pink, .brown
    ]

    static func habitColor(from hex: String) -> Color {
        Color(hex: hex) ?? .blue
    }
}
