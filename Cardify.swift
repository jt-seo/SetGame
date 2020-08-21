//
//  Cardify.swift
//  SetGame
//
//  Created by JT3 on 2020/08/21.
//  Copyright © 2020 JT. All rights reserved.
//

import SwiftUI

struct Cardify: ViewModifier {
    var isFaceUp: Bool
    var isSelect: Bool
    var isMatch: Bool?
    
    func body(content: Content) -> some View {
        ZStack {
            if (isFaceUp) {
                Group {
                    RoundedRectangle(cornerRadius: 10.0).fill(Color.white)
                    Group {
                        if (isMatch == true) {
                            RoundedRectangle(cornerRadius: 10.0).stroke(lineWidth: 5).foregroundColor(.green)
                        }
                        else if (isMatch == false) {
                            RoundedRectangle(cornerRadius: 10.0).stroke(lineWidth: 5).foregroundColor(.red)
                        }
                        else if (isSelect) {
                            RoundedRectangle(cornerRadius: 10.0).stroke(lineWidth: 3).foregroundColor(.blue)
                        }
                        else {
                            RoundedRectangle(cornerRadius: 10.0).stroke(lineWidth: 1)
                        }
                    }.transition(AnyTransition.opacity.animation(Animation.easeOut(duration: 0.5)))
                    content
                }
            }
            else {
                RoundedRectangle(cornerRadius: 10.0).fill()
            }
        }
        .rotation3DEffect(Angle(degrees: isFaceUp ? 180 : 0), axis: (x: 0, y: 1, z: 0))
    }
}

extension View {
    func cardify(isFaceUp: Bool, isSelect: Bool, isMatch: Bool?) -> some View {
        modifier(Cardify(isFaceUp: isFaceUp, isSelect: isSelect, isMatch: isMatch))
    }
}
