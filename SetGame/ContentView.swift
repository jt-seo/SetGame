//
//  ContentView.swift
//  SetGame
//
//  Created by JT3 on 2020/08/20.
//  Copyright © 2020 JT. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var setGame: SetGameVM
    var body: some View {
        VStack {
            Grid(setGame.dealtCards) { card in
                CardView(card: card)
                    .onTapGesture {
                        withAnimation(.linear(duration: 2)) {
                            self.setGame.selectCard(card: card)
                        }
                }
                    .foregroundColor(.gray)
                    .transition(.offset(x: CGFloat.random(in: -500...500), y: CGFloat.random(in: -500...500)))
                    .padding(5)
            }
            HStack {
                Button("Start Game") {
                    withAnimation(.easeOut(duration: 1)) {
                        self.setGame.initialDealCards()
                    }
                }.padding()
                Button("Deal more") {
                    withAnimation(.easeOut(duration: 1)) {
                        self.setGame.dealMoreCards()
                    }
                }.padding()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(setGame: SetGameVM())
    }
}

struct CardView: View {
    private(set) var card: SetGameVM.Card
    @State var isFlipped = false

    var body: some View {
        GeometryReader { geometry in
            self.body(card: self.card, size: geometry.size)
        }
    }
    
    private func body(card: SetGameVM.Card, size: CGSize) -> some View {
        let contentSize = calcContentSize(for: size)
        return HStack {
                ForEach(0..<card.number.rawValue) {_ in
                    self.cardContent(card: card, for: size)
                        .frame(width: contentSize.width, height: contentSize.height, alignment: .center)
            }
        }.cardify(isFaceUp: isFlipped, isSelect: card.isSelected, isMatch: card.isMatched)
            .onAppear {
                withAnimation(.easeOut(duration: 1)) {
                    self.isFlipped = true
            }
        }
    }
    
    private func cardColor(_ color: SetGameVM.Color) -> Color {
        switch color {
            case .red: return Color.red
            case .green: return Color.green
            case .blue: return Color.blue
        }
    }
    
    private func calcContentSize(for size: CGSize) -> CGSize {
        let width = Int(min(size.width, size.height) / 3 * 0.65)
        return CGSize(width: CGFloat(width), height: CGFloat(width))
    }
    
    struct AnyShape: Shape {
        init<S: Shape>(_ wrapped: S) {
            _path = { rect in
                let path = wrapped.path(in: rect)
                return path
            }
        }

        func path(in rect: CGRect) -> Path {
            return _path(rect)
        }

        private let _path: (CGRect) -> Path
    }
    
    // return the size of card content which 3 contents can be displayed in the rectangle with CGSize.
    private func cardContent(card: SetGameVM.Card, for size: CGSize) -> some View {
        var content: AnyShape
        if (card.symbol == SetGameVM.Symbol.circle) {
            content = AnyShape(Circle())
        }
        else if card.symbol == SetGameVM.Symbol.rectangle {
            content = AnyShape(Rectangle())
        }
        else {
            content = AnyShape(Capsule())
        }
        if (card.shading == SetGameVM.Shading.outlined) {
            content = AnyShape(content.stroke())
        }
        
        return content.foregroundColor(cardColor(card.color))
            .opacity(card.shading == SetGameVM.Shading.stripped ? 0.25 : 1)
    }
}
