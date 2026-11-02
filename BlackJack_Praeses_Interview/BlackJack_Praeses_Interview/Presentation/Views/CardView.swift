import SwiftUI

struct CardView: View {
    let card: Card
    let isHidden: Bool

    init(card: Card, isHidden: Bool = false) {
        self.card = card
        self.isHidden = isHidden
    }

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .fill(isHidden ? Color.indigo : Color.white)
            RoundedRectangle(cornerRadius: 10)
                .stroke(isHidden ? Color.white.opacity(0.7) : Color.gray, lineWidth: 2)

            if isHidden {
                Image(systemName: "circle.grid.3x3.fill")
                    .font(.title)
                    .foregroundStyle(.white.opacity(0.9))
            } else {
                VStack(spacing: 2) {
                    Text(card.rank.rawValue)
                    Text(card.suit.rawValue)
                }
                .font(.title2.bold())
                .foregroundStyle(color(for: card.suit))
            }
        }
        .frame(width: 68, height: 96)
        .accessibilityLabel(accessibilityLabel)
    }

    private func color(for suit: Suit) -> Color {
        suit == .hearts || suit == .diamonds ? .red : .black
    }

    private var accessibilityLabel: String {
        if isHidden { return "Hidden card" }
        return "\(card.rank.rawValue) of \(card.suit.rawValue)"
    }
}
