# Blackjack iOS App

A native, single-player Blackjack game built with SwiftUI. The player can hit or stand against an automated dealer; the dealer stands on all 17s, including soft 17.

## Build Instructions

1. Open `BlackJack_Praeses_Interview.xcodeproj` in Xcode.
2. Select the `BlackJack_Praeses_Interview` scheme.
3. Select an iOS 18.6 or newer simulator.
4. Press **Run** (`⌘R`) to build and launch the app.
5. Press **Test** (`⌘U`) to run the unit-test target.

From the command line, tests can also be run with:

```sh
xcodebuild \
  -project BlackJack_Praeses_Interview.xcodeproj \
  -scheme BlackJack_Praeses_Interview \
  -destination 'platform=iOS Simulator,name=iPhone 17 Pro' \
  test
```

## Development Environment

- Xcode Version: 26.4.1
- Swift Version: 6.3.1
- Deployment Target: iOS 18.6
- Simulator Tested: iPhone 17 Pro, iOS 26.4

## Dependencies

No third-party dependencies.

## Architecture

The application uses MVVM with Clean Architecture:

- **Domain models and services** own cards, deck state, hands, hand evaluation, and explicit game state.
- **Use cases** start games, process hits, run the dealer turn, and determine results.
- **Presentation** contains the `@Observable`, `@MainActor` ViewModel and reusable SwiftUI views.
- **App** is the composition root and launches the game screen.
- **Note** Data layer was intentionally left out because the game has no external or persistent data source. Dependencies are supplied through initializers, and deterministic decks can be injected into the start-game use case for testing.

## Testing

Swift Testing covers deck composition and drawing, ace evaluation, natural Blackjack, alternating deal order, all result comparisons, dealer behavior (including soft 17), busts, and invalid state transitions.

