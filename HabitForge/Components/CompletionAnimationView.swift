import SwiftUI

struct CompletionAnimationView: View {
    let color: Color
    @State private var scale: CGFloat = 0.5
    @State private var opacity: Double = 1.0
    @State private var rotation: Double = 0

    var body: some View {
        ZStack {
            Circle()
                .fill(color.opacity(0.3))
                .scaleEffect(scale)
                .opacity(opacity)

            Image(systemName: "checkmark")
                .font(.system(size: 40, weight: .bold))
                .foregroundStyle(.white)
                .rotationEffect(.degrees(rotation))
        }
        .frame(width: 100, height: 100)
        .onAppear {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.6)) {
                scale = 1.5
                rotation = 360
            }

            withAnimation(.easeOut(duration: 0.5).delay(0.2)) {
                opacity = 0
            }
        }
    }
}
