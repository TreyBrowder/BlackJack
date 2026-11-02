enum GameState: Equatable {
    case notStarted
    case playerTurn
    case dealerTurn
    case finished(GameResult)
}
