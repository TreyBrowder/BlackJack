import SwiftUI

struct HandView: View {
    let title: String
    let hand: Hand
    let hidesFirstCard: Bool

    var body: some View {
        VStack(spacing: 12) {
            Text(title)
                .font(.title2.bold())

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    ForEach(Array(hand.cards.enumerated()), id: \.element.id) { index, card in
                        CardView(card: card, isHidden: hidesFirstCard && index == 0)
                    }
                }
                .padding(.horizontal, 2)
            }

            Text(hidesFirstCard ? "Total: ?" : "Total: \(hand.value)")
                .font(.headline.monospacedDigit())
        }
    }
}
