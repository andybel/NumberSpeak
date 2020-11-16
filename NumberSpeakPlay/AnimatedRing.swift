//
//  AnimatedRing.swift
//  NumberSpeakPlay
//
//  Created by Andy Bell on 16.11.20.
//  Copyright © 2020 bellovic. All rights reserved.
//

import SwiftUI

struct AnimatedRing: View {
    @Binding var fromVal: CGFloat
    var showBgRing = false
    let col: Color
    
    var body: some View {
        ZStack {
            if showBgRing {
                Circle()
                    .stroke(Color.gray, style: StrokeStyle(lineWidth: 10,
                                                           lineCap: .round,
                                                           lineJoin: .round))
                    .opacity(0.4)
            }
            Circle()
                .trim(from: fromVal, to: 1.0)
                .stroke(col, style: StrokeStyle(lineWidth: 10,
                                                       lineCap: .round,
                                                       lineJoin: .round))
                .rotationEffect(.degrees(90))
                .rotation3DEffect(
                    Angle(degrees: 180),
                    axis: (x: 1.0, y: 0.0, z: 0.0))
                .animation(.easeOut(duration: 5))
        }
    }
}

struct AnimatedRing_Previews: PreviewProvider {
    static var previews: some View {
        AnimatedRing(fromVal: .constant(0.5), col: .orange)
    }
}
