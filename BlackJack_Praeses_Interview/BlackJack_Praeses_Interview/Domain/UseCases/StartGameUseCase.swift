struct StartGameUseCase {
    private let makeDeck: () -> Deck

    init(makeDeck: @escaping () -> Deck = { Deck() }) {
        self.makeDeck = makeDeck
    }

    func execute() -> GameSession {
        var session = GameSession(deck: makeDeck())

        // Alternating these calls makes the required deal order explicit.
        deal(to: &session.playerHand, from: &session.deck)
        deal(to: &session.dealerHand, from: &session.deck)
        deal(to: &session.playerHand, from: &session.deck)
        deal(to: &session.dealerHand, from: &session.deck)

        switch (session.playerHand.isBlackjack, session.dealerHand.isBlackjack) {
        case (true, true): session.state = .finished(.push)
        case (true, false): session.state = .finished(.playerBlackjack)
        case (false, true): session.state = .finished(.dealerBlackjack)
        case (false, false): session.state = .playerTurn
        }
        return session
    }

    private func deal(to hand: inout Hand, from deck: inout Deck) {
        if let card = deck.draw() { hand.add(card) }
    }
}
