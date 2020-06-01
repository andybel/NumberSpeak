//
//  CustomKeyboard.swift
//  NumberSpeakPlay
//
//  Created by Andy Bell on 05.12.19.
//  Copyright © 2019 bellovic. All rights reserved.
//

import SwiftUI

struct CustomKeyboard: View {

    @Binding var inputNumbersArray: [Int]

    enum KeyIndex {
        case num(Int)
        case clear
        case delete

        var title: String {
            switch self {
            case .clear:
                return "clear"
            case .delete:
                return "delete"
            case .num(let numIdx):
                return "\(numIdx)"
            }
        }

        var intValue: Int {
            switch self {
            case .clear:
                return 10
            case .delete:
                return 11
            case .num(let numIdx):
                return numIdx
            }
        }
    }

    struct Key: ViewModifier {
        func body(content: Content) -> some View {
            content
                .font(.largeTitle)
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .foregroundColor(Color.black)
        }
    }

    var body: some View {
        ZStack {
            GeometryReader { geo in
                VStack {
                    ForEach(0..<4) { row in
                        self.KeyboardRow(for: row, geo: geo)
                    }
                }
            }
        }
    }

    fileprivate func KeyBtn(_ keyIdx: KeyIndex, geo: GeometryProxy) -> some View {

        return Button(action: {

            switch keyIdx {
            case .num(let idx):
                self.inputNumbersArray.append(idx)
            case .delete:
                _ = self.inputNumbersArray.popLast()
            case .clear:
                self.inputNumbersArray.removeAll()
            }
        }) {
            Text(keyIdx.title)
                .frame(width: geo.size.width * 0.3,
                       height: geo.size.height * 0.25)
                .modifier(Key())
        }
    }

    private func KeyboardRow(for rowIdx: Int, geo: GeometryProxy) -> some View {

        return HStack {
            if rowIdx < 3 {
                ForEach(1..<4) { col in
                    self.KeyBtn(.num((rowIdx * 3) + col), geo: geo)
                }
            } else {
                self.KeyBtn(.clear, geo: geo)
                self.KeyBtn(.num(0), geo: geo)
                self.KeyBtn(.delete, geo: geo)
            }
        }
    }
}
