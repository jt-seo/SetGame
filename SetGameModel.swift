//
//  SetGameModel.swift
//  SetGame
//
//  Created by JT3 on 2020/08/20.
//  Copyright © 2020 JT. All rights reserved.
//

import Foundation

struct SetGameModel<Color, Symbol, Number, Shading> where Color: Equatable, Symbol: Equatable, Number: Equatable, Shading: Equatable {
    private(set) var deck: [Card]
    private(set) var matchedCards = [Card]()
    private(set) var dealtCards = [Card]()
    
    init (deckFactory: () -> [Card]) {
        deck = deckFactory()
        deck.shuffle()
    }
    
    struct Card: Identifiable {
        var id: Int
        var color: Color
        var symbol: Symbol
        var number: Number
        var shading: Shading
        
        var isSelected = false
        var isMatched: Bool?    // true: matched, false: not-matched.
    }
    
    // Deal 1 card. (Get 1 card from the deck and move it to the board.)
    mutating func dealCards(for numOfCards: Int) {
        for _ in 1...numOfCards {
            if let card = deck.popLast() {
                dealtCards.append(card)
            }
            else {
                break
            }
        }
    }
    
    var numOfSelectedCards: Int {
        get {
            dealtCards.filter{ $0.isSelected }.count
        }
        set {
            if newValue == 3 {  // Check if selected cards conform to a set.
                let selectedCards = dealtCards.filter { $0.isSelected }
                if selectedCards.count == 3 {
                    let isMatched = isSetMatching(selectedCards[0], selectedCards[1], selectedCards[2])
                    for card in selectedCards {
                        if let index = dealtCards.firstIndex(of: card) {
                            dealtCards[index].isMatched = isMatched
                        }
                    }
                }
                else {
                    print("Invalid selected card count! \(selectedCards.count)")
                }
            }
            else if newValue > 3 {
                let numOfMatchingCards = dealtCards.filter { $0.isMatched == true }.count
                if (numOfMatchingCards > 0) {
                    dealtCards.removeAll { $0.isMatched == true }
                    dealCards(for: 3)
                }
                else {
                    for index in dealtCards.indices {
                        if (dealtCards[index].isMatched == false) {
                            dealtCards[index].isMatched = nil
                            dealtCards[index].isSelected = false
                        }
                    }
                }
            }
        }
    }
    
    private func isSetMatching<T> (_ attr1: T, _ attr2: T, _ attr3: T) -> Bool where T: Equatable {
        if (attr1 == attr2 && attr2 == attr3)
            || (attr1 != attr2 && attr2 != attr3 && attr1 != attr3) {
            return true
        }
        return false
    }
    private func isSetMatching(_ card1: Card, _ card2: Card, _ card3: Card) -> Bool {
        return isSetMatching(card1.color, card2.color, card3.color)
                && isSetMatching(card1.symbol, card2.symbol, card3.symbol)
                && isSetMatching(card1.number, card2.number, card3.number)
                && isSetMatching(card1.shading, card2.shading, card3.shading)
    }
    
    private func checkCardMatching() {
        
    }
    
    // Select a card from the dealt cards
    mutating func selectCard(card: Card) {
        if let index = dealtCards.firstIndex(of: card) {
            if (!dealtCards[index].isSelected || dealtCards[index].isMatched == true) {
                dealtCards[index].isSelected = true
                numOfSelectedCards += 1
            }
            else if (numOfSelectedCards < 3) {  // Deselect this card.
                dealtCards[index].isSelected = false
            }
        }
    }
    
    
    
}
