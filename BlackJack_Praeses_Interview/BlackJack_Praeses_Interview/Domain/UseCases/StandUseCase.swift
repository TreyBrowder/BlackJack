struct StandUseCase {
    func execute(on session: inout GameSession) {
        guard session.state == .playerTurn else { return }
        session.state = .dealerTurn

        while session.dealerHand.value < 17, let card = session.deck.draw() {
            session.dealerHand.add(card)
        }

        session.state = .finished(result(
            player: session.playerHand,
            dealer: session.dealerHand
        ))
    }

    func result(player: Hand, dealer: Hand) -> GameResult {
        if player.isBust { return .playerBust }
        if dealer.isBust { return .dealerBust }
        if player.value > dealer.value { return .playerWin }
        if dealer.value > player.value { return .dealerWin }
        return .push
    }
}
