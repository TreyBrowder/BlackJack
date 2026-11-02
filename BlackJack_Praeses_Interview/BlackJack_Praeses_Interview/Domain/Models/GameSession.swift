struct GameSession: Equatable {
    var deck: Deck
    var playerHand = Hand()
    var dealerHand = Hand()
    var state: GameState = .notStarted

    init(deck: Deck = Deck()) {
        self.deck = deck
    }
}
