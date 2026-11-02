struct HitUseCase {
    private let standUseCase: StandUseCase

    init(standUseCase: StandUseCase = StandUseCase()) {
        self.standUseCase = standUseCase
    }

    func execute(on session: inout GameSession) {
        guard session.state == .playerTurn, let card = session.deck.draw() else { return }
        session.playerHand.add(card)

        if session.playerHand.isBust {
            session.state = .finished(.playerBust)
        } else if session.playerHand.value == 21 {
            standUseCase.execute(on: &session)
        }
    }
}
