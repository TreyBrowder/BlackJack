import SwiftUI

struct GameControlsView: View {
    let state: GameState
    let hit: () -> Void
    let stand: () -> Void
    let playAgain: () -> Void

    var body: some View {
        switch state {
        case .playerTurn:
            HStack(spacing: 16) {
                actionButton("Hit", action: hit)
                actionButton("Stand", action: stand)
            }
        case .finished:
            actionButton("Play Again", action: playAgain)
        case .notStarted:
            actionButton("Deal", action: playAgain)
        case .dealerTurn:
            ProgressView("Dealer is playing")
        }
    }

    private func actionButton(_ title: String, action: @escaping () -> Void) -> some View {
        Button(title, action: action)
            .font(.headline)
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
    }
}
