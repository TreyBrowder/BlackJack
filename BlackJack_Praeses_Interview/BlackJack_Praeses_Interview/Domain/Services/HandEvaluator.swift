enum HandEvaluator {
    static func evaluate(_ cards: [Card]) -> Int {
        var total = cards.reduce(0) { $0 + $1.rank.blackjackValue }
        var highAces = cards.count { $0.rank == .ace }

        while total > 21, highAces > 0 {
            total -= 10
            highAces -= 1
        }

        return total
    }
}
