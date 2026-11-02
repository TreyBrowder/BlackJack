import SwiftUI

struct BlackjackView: View {
    @State private var viewModel: BlackjackViewModel

    init(viewModel: BlackjackViewModel = BlackjackViewModel()) {
        _viewModel = State(initialValue: viewModel)
    }

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Color(red: 0.04, green: 0.28, blue: 0.17), .black],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            ScrollView {
                VStack(spacing: 24) {
                    Text("BLACKJACK")
                        .font(.largeTitle.bold())
                        .tracking(3)

                    resultBanner

                    HandView(
                        title: "Dealer",
                        hand: viewModel.dealerHand,
                        hidesFirstCard: viewModel.isDealerCardHidden
                    )

                    Divider().overlay(.white.opacity(0.5))

                    HandView(title: "Your Hand", hand: viewModel.playerHand, hidesFirstCard: false)

                    GameControlsView(
                        state: viewModel.gameState,
                        hit: viewModel.hit,
                        stand: viewModel.stand,
                        playAgain: viewModel.startGame
                    )
                }
                .foregroundStyle(.white)
                .padding(24)
            }
        }
        .onAppear {
            if viewModel.gameState == .notStarted { viewModel.startGame() }
        }
    }

    @ViewBuilder
    private var resultBanner: some View {
        if case let .finished(result) = viewModel.gameState {
            Text(result.title)
                .font(.title.bold())
                .foregroundStyle(result.isPlayerSuccess ? .yellow : .red)
        }
    }
}

private extension GameResult {
    var title: String {
        switch self {
        case .playerBlackjack: "BLACKJACK — YOU WIN"
        case .dealerBlackjack: "DEALER BLACKJACK"
        case .playerWin: "YOU WIN"
        case .dealerWin: "DEALER WINS"
        case .push: "PUSH"
        case .playerBust: "BUST — DEALER WINS"
        case .dealerBust: "DEALER BUSTS — YOU WIN"
        }
    }

    var isPlayerSuccess: Bool {
        self == .playerBlackjack || self == .playerWin || self == .dealerBust
    }
}
