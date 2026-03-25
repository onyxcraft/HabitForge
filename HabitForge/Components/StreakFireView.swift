import SwiftUI

struct StreakFireView: View {
    let streak: Int
    let color: Color

    @State private var isAnimating = false

    private var isMilestone: Bool {
        streak == 7 || streak == 30 || streak == 100 || streak % 100 == 0
    }

    private var flameScale: CGFloat {
        switch streak {
        case 0..<7: return 1.0
        case 7..<30: return 1.2
        case 30..<100: return 1.4
        default: return 1.6
        }
    }

    var body: some View {
        HStack(spacing: 4) {
            ZStack {
                if isMilestone {
                    Image(systemName: "flame.fill")
                        .foregroundStyle(.orange)
                        .scaleEffect(isAnimating ? flameScale * 1.2 : flameScale)
                        .opacity(isAnimating ? 0.5 : 1.0)
                }

                Image(systemName: "flame.fill")
                    .foregroundStyle(
                        LinearGradient(
                            colors: [.orange, .red],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .scaleEffect(flameScale)
            }
            .onAppear {
                if isMilestone {
                    withAnimation(.easeInOut(duration: 1.0).repeatForever(autoreverses: true)) {
                        isAnimating = true
                    }
                }
            }

            Text("\(streak)")
                .font(.headline)
                .fontWeight(.bold)
                .foregroundStyle(color)
        }
    }
}
