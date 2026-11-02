import Observation

@MainActor
@Observable
final class BlackjackViewModel {
    private var session: GameSession

    private let startGameUseCase: StartGameUseCase
    private let hitUseCase: HitUseCase
    private let standUseCase: StandUseCase
    
    var playerHand: Hand { session.playerHand }
    var dealerHand: Hand { session.dealerHand }
    var gameState: GameState { session.state }
    var isDealerCardHidden: Bool { gameState == .playerTurn }

    init(
        startGameUseCase: StartGameUseCase = StartGameUseCase(),
        hitUseCase: HitUseCase = HitUseCase(),
        standUseCase: StandUseCase = StandUseCase()
    ) {
        self.startGameUseCase = startGameUseCase
        self.hitUseCase = hitUseCase
        self.standUseCase = standUseCase
        session = GameSession()
    }

    func startGame() {
        session = startGameUseCase.execute()
    }

    func hit() {
        hitUseCase.execute(on: &session)
    }

    func stand() {
        standUseCase.execute(on: &session)
    }
}
