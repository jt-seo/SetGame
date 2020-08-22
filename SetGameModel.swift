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

        var isSelected: Bool = false
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
        checkCardMatched(selected: Int.max)
    }
    
    var threeCardSelected = false
    var numOfSelectedCards = 0
    var numOfCardMatched = 0
    
    private mutating func checkCardMatched(selected: Int) {
        if !threeCardSelected {  // Check if selected cards conform to a set.
            let selectedCards = dealtCards.filter { $0.isSelected }
            if selectedCards.count == 3 {
                let isMatched = isSetMatching(selectedCards[0], selectedCards[1], selectedCards[2])
                for card in selectedCards {
                    if let index = dealtCards.firstIndex(of: card) {
                        dealtCards[index].isMatched = isMatched
                    }
                }
                threeCardSelected = true
                if (isMatched) {
                    numOfCardMatched += 1
                    print("Card matched! totalMatch: \(numOfCardMatched)")
                }
                else {
                    print("Card not matched! totalMatch: \(numOfCardMatched)")
                }
            }
        }
        else {
            let numOfMatchingCards = dealtCards.filter { $0.isMatched == true }.count
            if (numOfMatchingCards > 0) {
                removeMatchingCards()
            }
            else {
                print("reset non-matching cards.")
                for index in dealtCards.indices {
                    if (dealtCards[index].isMatched == false) {
                        dealtCards[index].isMatched = nil
                        if (index != selected) {
                            dealtCards[index].isSelected = false
                        }
                    }
                }
            }
            threeCardSelected = false
        }
    }
    
    private mutating func removeMatchingCards() {
        print("removeMatchingCards.")
        dealtCards.removeAll { $0.isMatched == true }
        let count = 12 - dealtCards.count
        if (count > 0) {
            dealCards(for: count)
        }
    }
    
    private mutating func deselectAllCards() {
        removeMatchingCards()
        for card in dealtCards {
            if card.isSelected {
                selectCard(card: card)
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
    
    // Select a card from the dealt cards
    mutating func selectCard(card: Card) {
        if let index = dealtCards.firstIndex(of: card) {
            if dealtCards[index].isMatched != nil || !dealtCards[index].isSelected {
                dealtCards[index].isSelected = true
                checkCardMatched(selected: index)
            }
            else {
                dealtCards[index].isSelected.toggle()
            }
        }
    }
    
    mutating func markMatchingCards(_ idx1: Int, _ idx2: Int, _ idx3: Int) {
        selectCard(card: dealtCards[idx1])
        selectCard(card: dealtCards[idx2])
        selectCard(card: dealtCards[idx3])
    }
    
    mutating func selectMatchingCard() {
        deselectAllCards()
        let count = dealtCards.count
        for (idx1, card) in dealtCards.enumerated() {
            if idx1 + 2 >= count {
                print("No matching cards! count: \(count)")
                return
            }
            for idx2 in idx1 + 1..<count-1 {
                for idx3 in idx1 + 2..<count {
                    if isSetMatching(card, dealtCards[idx2], dealtCards[idx3]) {
                        markMatchingCards(idx1, idx2, idx3)
                        return
                    }
                }
            }
        }
        print("No matching cards! count: \(count)")
    }
}
