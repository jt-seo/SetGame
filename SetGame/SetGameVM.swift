//
//  SetGameVM.swift
//  SetGame
//
//  Created by JT3 on 2020/08/20.
//  Copyright © 2020 JT. All rights reserved.
//

import Foundation

struct SetGameVM {
    enum Color: Equatable, CaseIterable {
        case red, yellow, blue
    }
    enum Symbol: Equatable, CaseIterable {
        case rectangle, diamond, circle
    }
    enum Number: Equatable, CaseIterable {
        case one, two, three
    }
    enum Shading: Equatable, CaseIterable {
        case solid, stripped, outlined
    }
    
    // MARK - Access to Model.
    typealias SetGameType = SetGameModel<Color, Symbol, Number, Shading>
    private var setGame = SetGameVM.createGame()
    
    private static let numberOfInitialDealtCards = 12
    private static func createGame() -> SetGameType {
        var model = SetGameType() {
            var deck = [SetGameType.Card]()
            var id = 0
            for color in Color.allCases {
                for symbol in Symbol.allCases {
                    for number in Number.allCases {
                        for shading in Shading.allCases {
                            deck.append(SetGameType.Card(
                                id: id, color: color, symbol: symbol, number: number, shading: shading)
                            )
                            id += 1
                        }
                    }
                }
            }
            return deck
        }
        model.dealCards(for: SetGameVM.numberOfInitialDealtCards)
        return model
    }
    
    mutating func selectCard(card: SetGameType.Card) { // TODO: - Why this selectCard must be mutating?
        setGame.selectCard(card: card)
    }
}
