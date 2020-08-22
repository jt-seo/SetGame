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
            Text("Card in deck: \(setGame.numOfCardsInDeck)").padding()
            ZStack {
                Grid(setGame.dealtCards) { card in
                    CardView(card: card)
                        .onTapGesture {
                            withAnimation(.linear(duration: 0.5)) {
                                self.setGame.selectCard(card: card)
                            }
                    }
                    .foregroundColor(.gray).shadow(radius: 3)
                        .transition(.offset(x: CGFloat.random(in: -500...500), y: CGFloat.random(in: -500...500)))
                        .padding(5)
                }
            }
            HStack {
                Button("Deal more") {
                    withAnimation(.easeOut(duration: 0.5)) {
                        self.setGame.dealMoreCards()
                    }
                }.padding()
                Button("Help..") {
                    withAnimation(.easeOut(duration: 0.5)) {
                        self.setGame.selectMatchingCard()
                    }
                }.padding()
                Button("New Game") {
                    withAnimation(.easeOut(duration: 0.5)) {
                        self.setGame.resetGame()
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
    @State var isMatched = true
    @State private var timer: Timer?

    var body: some View {
        GeometryReader { geometry in
            self.body(card: self.card, size: geometry.size)
        }
    }
    
    private func body(card: SetGameVM.Card, size: CGSize) -> some View {
        let contentSize = calcContentSize(for: size)
        return ZStack {
            HStack {
                    ForEach(0..<card.number.rawValue) { _ in
                        self.cardContent(card: card, for: size)
                            .frame(width: contentSize.width, height: contentSize.height, alignment: .center)
                }
            }.cardify(isFaceUp: isFlipped, isSelect: card.isSelected, isMatch: card.isMatched)
                .onAppear {
                    withAnimation(.easeOut(duration: 0.5)) {
                        self.isFlipped = true
                    }
                }
            
            if (card.isMatched == true && isMatched) {
                Text("Nice!")
                    .font(.headline).foregroundColor(.blue)
                    .bold()
                    .transition(.opacity)
//                    .onAppear {
//                        self.timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false) { _ in
//                            withAnimation(.easeInOut(duration: 0.5)) {
//                                self.isMatched = false
//                            }
//                        }
//                    }
//                    .onDisappear {
//                        self.isMatched = true
//                    }
            }
            else if (card.isMatched == false && isMatched) {
                Text("Oops!")
                    .font(.headline).foregroundColor(.red)
                    .bold()
                    .transition(.opacity)
//                    .onAppear {
//                        self.timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false) { _ in
//                            withAnimation(.easeInOut(duration: 0.5)) {
//                                self.isMatched = false
//                            }
//                        }
//                    }
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
        let width = size.width / 3 * 0.65
        let height = size.height * 0.65
        return CGSize(width: CGFloat(width), height: CGFloat(height))
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
            content = AnyShape(Ellipse())
        }
        if (card.shading == SetGameVM.Shading.outlined) {
            content = AnyShape(content.stroke())
        }
        
        return content.foregroundColor(cardColor(card.color))
            .opacity(card.shading == SetGameVM.Shading.stripped ? 0.25 : 1)
    }
}
