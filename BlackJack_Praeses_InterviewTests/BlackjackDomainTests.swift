import Testing
@testable import BlackJack_Praeses_Interview

private func card(_ rank: Rank, _ suit: Suit = .spades) -> Card {
    Card(rank: rank, suit: suit)
}

// MARK: Deck
struct DeckTests {
    @Test func standardDeckHas52UniqueCards() {
        let deck = Deck()
        #expect(deck.cards.count == 52)
        #expect(Set(deck.cards).count == 52)
    }

    @Test func drawingRemovesTheCard() {
        var deck = Deck()
        let first = deck.cards.first
        #expect(deck.draw() == first)
        #expect(deck.cards.count == 51)
        if let first {
            #expect(!deck.cards.contains(first))
        }
    }
}

// MARK: Hand
struct HandTests {
    @Test(arguments: [
        ([card(.ten), card(.seven)], 17, false),
        ([card(.king), card(.queen)], 20, false),
        ([card(.ace), card(.seven)], 18, false),
        ([card(.ace), card(.seven), card(.eight)], 16, false),
        ([card(.ace), card(.ace), card(.nine)], 21, false),
        ([card(.ace), card(.ace), card(.nine), card(.nine)], 20, false),
        ([card(.ten), card(.nine), card(.five)], 24, true),
    ])
    func values(cards: [Card], total: Int, bust: Bool) {
        let hand = Hand(cards: cards)
        #expect(hand.value == total)
        #expect(hand.isBust == bust)
    }

    @Test func naturalBlackjackRequiresExactlyTwoCards() {
        #expect(Hand(cards: [card(.ace), card(.king)]).isBlackjack)
        #expect(!Hand(cards: [card(.ace), card(.five), card(.five)]).isBlackjack)
    }
}

// MARK: UseCases
struct GameUseCaseTests {
    @Test func initialDealAlternatesPlayerDealer() {
        let ordered = [card(.two), card(.three), card(.four), card(.five)]
        let game = StartGameUseCase(makeDeck: { Deck(cards: ordered) }).execute()
        
        // test to make sure cards are properly delt
        #expect(game.playerHand.cards == [ordered[0], ordered[2]])
        #expect(game.dealerHand.cards == [ordered[1], ordered[3]])
    }

    @Test(arguments: [
        ([card(.ace), card(.king)], [card(.ten), card(.nine)], GameResult.playerBlackjack),
        ([card(.ten), card(.nine)], [card(.ace), card(.king)], .dealerBlackjack),
        ([card(.ace), card(.king)], [card(.ace), card(.queen)], .push),
    ])
    func initialBlackjacks(player: [Card], dealer: [Card], result: GameResult) {
        let ordered = [player[0], dealer[0], player[1], dealer[1]]
        let game = StartGameUseCase(makeDeck: { Deck(cards: ordered) }).execute()
        #expect(game.state == .finished(result))
    }

    @Test func hitCanBustAndInvalidActionsDoNothing() {
        // make sure hitting does nothing before while game state is set to .notStarted
        var notStarted = GameSession(deck: Deck(cards: [card(.king)]))
        let original = notStarted
        HitUseCase().execute(on: &notStarted)
        #expect(notStarted == original)

        // set up game so its players turn with 5 being next card and a hand of 19
        var game = GameSession(deck: Deck(cards: [card(.five)]))
        game.playerHand = Hand(cards: [card(.ten), card(.nine)])
        game.state = .playerTurn
        HitUseCase().execute(on: &game)
        #expect(game.state == .finished(.playerBust))
        
        // test after game is finished that hitting and standing does nothing
        let finished = game
        HitUseCase().execute(on: &game)
        StandUseCase().execute(on: &game)
        #expect(game == finished)
    }

    @Test func hittingTo21AutomaticallyCompletesDealerTurn() {
        var game = GameSession(deck: Deck(cards: [card(.five), card(.four)]))
        game.playerHand = Hand(cards: [card(.ten), card(.six)])
        game.dealerHand = Hand(cards: [card(.ten), card(.six)])
        game.state = .playerTurn

        HitUseCase().execute(on: &game)

        #expect(game.playerHand.value == 21)
        #expect(game.dealerHand.value == 20)
        #expect(game.state == .finished(.playerWin))
    }

    @Test(arguments: [
        ([card(.ten), card(.eight)], [card(.ten), card(.seven)], GameResult.playerWin),
        ([card(.ten), card(.seven)], [card(.ten), card(.eight)], .dealerWin),
        ([card(.ten), card(.eight)], [card(.nine), card(.nine)], .push),
        ([card(.ten), card(.eight)], [card(.king), card(.six), card(.nine)], .dealerBust),
        ([card(.king), card(.nine), card(.five)], [card(.ten), card(.seven)], .playerBust),
    ])
    func resultComparison(player: [Card], dealer: [Card], result: GameResult) {
        #expect(StandUseCase().result(player: Hand(cards: player), dealer: Hand(cards: dealer)) == result)
    }

    @Test(arguments: [
        ([card(.ten), card(.six)], [card(.two)], 3),
        ([card(.ten), card(.seven)], [card(.two)], 2),
        ([card(.ten), card(.eight)], [card(.two)], 2),
        ([card(.ace), card(.six)], [card(.two)], 2),
        ([card(.two), card(.three)], [card(.four), card(.five), card(.six), card(.ten)], 5),
    ])
    func dealerBehavior(dealer: [Card], remaining: [Card], finalCount: Int) {
        var game = GameSession(deck: Deck(cards: remaining))
        game.playerHand = Hand(cards: [card(.ten), card(.eight)])
        game.dealerHand = Hand(cards: dealer)
        game.state = .playerTurn
        StandUseCase().execute(on: &game)
        #expect(game.dealerHand.cards.count == finalCount)
    }
}
