struct Card: Identifiable, Hashable {
    let rank: Rank
    let suit: Suit

    var id: String { "\(rank.rawValue)\(suit.rawValue)" }
}
