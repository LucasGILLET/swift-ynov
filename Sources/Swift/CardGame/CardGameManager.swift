// TP2 - Card Game System
// Card Game Manager with Singleton Pattern

import Foundation

// Game Manager avec singleton pattern
final class CardGameManager {
    @MainActor static let shared = CardGameManager()

    private init() {}

    // TODO: 3->7. Implémenter les autres composants
    // - Class Deck (3 pts)
    // - Protocol Player (2 pts)
    // - Classes HumanPlayer/AIPlayer (2 pts)
    // - Class Game (7 pts)
    // - Extensions Array<Card> (2 pts)

    class Deck {
        var cards = [Card]()

        init() {
            for suit in Suit.allCases {
                for rank in Rank.allCases {
                    cards.append(Card(rank: rank, suit: suit))
                }
            }
        }

        func shuffle() {
            cards.shuffle()
        }

        func draw() -> Card? {
            return cards.popLast()
        }

        func reset() {
            cards.removeAll()
            for suit in Suit.allCases {
                for rank in Rank.allCases {
                    cards.append(Card(rank: rank, suit: suit))
                }
            }
        }
    }

    protocol Player: AnyObject {
        var name: String { get }
        var hand: [Card] { get set }
        var score : Int { get set }
        func playCard() -> Card?
        func receiveCard(_ card: Card)
    }

    class HumanPlayer: Player {
        let name: String
        var hand: [Card] = []
        var score: Int = 0

        init(name: String) {
            self.name = name
        }

        func playCard() -> Card? {
            return hand.popLast()
        }

        func receiveCard(_ card: Card) {
            hand.append(card)
        }
    }

    class AIPlayer: Player {
        let name: String
        var hand: [Card] = []
        var score: Int = 0

        init(name: String) {
            self.name = name
        }

        func playCard() -> Card? {
            return hand.popLast()
        }

        func receiveCard(_ card: Card) {
            hand.append(card)
        }
    }

    class Game {
        var player1: Player
        var player2: Player
        var deck: Deck

        init(player1: Player, player2: Player) {
            self.player1 = player1
            self.player2 = player2
            self.deck = Deck()
        }

        func dealCards() {
            deck.shuffle()
            for _ in 0..<26 {
                if let card1 = deck.draw() {
                    player1.receiveCard(card1)
                }
                if let card2 = deck.draw() {
                    player2.receiveCard(card2)
                }
            }
        }

        func playRound() {
            guard let card1 = player1.playCard(), let card2 = player2.playCard() else {
                return
            }

            print("==== Round \(player1.score + player2.score + 1) ====")
            print("\(player1.name) plays \(card1.description)")
            print("\(player2.name) plays \(card2.description)")

            if card1 > card2 {
                player1.score += 1
                print("---- \(player1.name) wins the round ----\n")
            } else if card2 > card1 {
                player2.score += 1
                print("---- \(player2.name) wins the round ----\n")
            } else {
                print("//// War! \\\\\\\\")
                print("Each player places 3 cards face down and 1 card face up...")
                var warCards1: [Card] = []
                var warCards2: [Card] = []

                for _ in 0..<3 {
                    if let card = player1.playCard() {
                        warCards1.append(card)
                    }
                    if let card = player2.playCard() {
                        warCards2.append(card)
                    }
                }

                guard let warCard1 = player1.playCard(), let warCard2 = player2.playCard() else {
                    if player1.hand.isEmpty {
                        player2.score += 1
                        print("---- \(player2.name) wins the war by default! ----\n")
                    } else {
                        player1.score += 1
                        print("---- \(player1.name) wins the war by default! ----\n")
                    }
                    return
                }

                print("\(player1.name) plays \(warCard1.description) for war")
                print("\(player2.name) plays \(warCard2.description) for war")

                if warCard1 > warCard2 {
                    player1.score += 1
                    print("---- \(player1.name) wins the war ----\n")
                } else if warCard2 > warCard1 {
                    player2.score += 1
                    print("---- \(player2.name) wins the war ----\n")
                } else {
                    playRound()
                }
            }
            print("Current Scores: \(player1.name): \(player1.score), \(player2.name): \(player2.score)\n")
        }

        func play() {
            dealCards()
            while !player1.hand.isEmpty && !player2.hand.isEmpty {
                playRound()
            }

            print("Final Scores:")
            print("\(player1.name): \(player1.score)")
            print("\(player2.name): \(player2.score)")

            if player1.score > player2.score {
                print("\(player1.name) wins the game!")
            } else if player2.score > player1.score {
                print("\(player2.name) wins the game!")
            } else {
                print("The game is a tie!")
            }
        }
    }

    func run() {
        print("Card Game: War")
        print("=================\n")

        // TODO: Créer deux joueurs
        let player1 = HumanPlayer(name: "Alice")
        let player2 = AIPlayer(name: "Bob")

        // TODO: Créer et lancer une partie
        let game = Game(player1: player1, player2: player2)
        game.play()
    }
}

extension Array where Element == Card {
    func highestCard() -> Card? {
        return self.max()
    }
    var description: String {
        return self.map { $0.description }.joined(separator: ", ")
    }
}
