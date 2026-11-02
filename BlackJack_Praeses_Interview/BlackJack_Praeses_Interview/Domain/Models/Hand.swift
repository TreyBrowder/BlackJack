struct Hand: Equatable {
    private(set) var cards: [Card]

    init(cards: [Card] = []) {
        self.cards = cards
    }

    mutating func add(_ card: Card) {
        cards.append(card)
    }

    var value: Int { HandEvaluator.evaluate(cards) }
    var isBust: Bool { value > 21 }
    var isBlackjack: Bool { cards.count == 2 && value == 21 }
}
