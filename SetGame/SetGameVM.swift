//
//  SetGameVM.swift
//  SetGame
//
//  Created by JT3 on 2020/08/20.
//  Copyright © 2020 JT. All rights reserved.
//

import Foundation

class SetGameVM: ObservableObject {
    @Published private var setGame = createGame()

    enum Color: Equatable, CaseIterable {
        case red, green, blue
        var name: String {
            switch self {
                case .red: return "red"
                case .green: return "green"
                case .blue: return "blue"
            }
        }
    }
    enum Symbol: Equatable, CaseIterable {
        case rectangle, diamond, circle
        var name: String {
            switch self {
                case .rectangle: return "rectangle"
                case .diamond: return "diamond"
                case .circle: return "circle"
            }
        }
    }
    enum Number: Int, Equatable, CaseIterable {
        case one = 1, two, three
    }
    enum Shading: Equatable, CaseIterable {
        case solid, stripped, outlined
        var name: String {
            switch self {
                case .solid: return "solid"
                case .stripped: return "stripped"
                case .outlined: return "outlined"
            }
        }
    }
    
    // MARK - Access to Model.
    typealias SetGameType = SetGameModel<Color, Symbol, Number, Shading>
    typealias Card = SetGameType.Card

    var dealtCards: [Card] {
        setGame.dealtCards
    }
    var cardDeck: [Card] {
        setGame.deck
    }
    var numOfCardsInDeck: Int {
        cardDeck.count
    }
    
    private static let numberOfInitialDealtCards = 12
    static func createGame() -> SetGameType {
        var model = SetGameType() {
            var deck = [Card]()
            var id = 0
            for color in Color.allCases {
                for symbol in Symbol.allCases {
                    for number in Number.allCases {
                        for shading in Shading.allCases {
                            deck.append(Card(
                                id: id, color: color, symbol: symbol, number: number, shading: shading)
                            )
                            id += 1
                        }
                    }
                }
            }
            return deck
        }
        model.dealCards(for: numberOfInitialDealtCards)
        return model
    }
    
    func initialDealCards() {
        setGame.dealCards(for: SetGameVM.numberOfInitialDealtCards)
    }
    
    func dealMoreCards() {
        setGame.dealCards(for: 3)
    }
    
    func selectCard(card: Card) {
        print("Select Card[\(card.id): (\(card.isSelected))\(card.color.name), \(card.symbol.name), \(card.number.rawValue), \(card.shading.name)")
        setGame.selectCard(card: card)
    }
    
    func resetGame() {
        setGame = SetGameVM.createGame()
    }
    
    func selectMatchingCard() {
        setGame.selectMatchingCard()
    }
    
    var numOfCardsMatched: Int {
        setGame.numOfCardMatched
    }
}
