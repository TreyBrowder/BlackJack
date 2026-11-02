struct Deck: Equatable {
    private(set) var cards: [Card]

    init() {
        cards = Suit.allCases.flatMap { suit in
            Rank.allCases.map { Card(rank: $0, suit: suit) }
        }
        cards.shuffle()
    }
    
    // Used for test cases
    init(cards: [Card]) {
        self.cards = cards
    }

    mutating func draw() -> Card? {
        guard !cards.isEmpty else { return nil }
        return cards.removeFirst()
    }
}
