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
                .font(.title)
                //.background(Color.white)
                //.clipShape(RoundedRectangle(cornerRadius: 8))
                .foregroundColor(Color.white)
        }
    }

    var body: some View {
        VStack {
            ForEach(0..<4) { row in
                self.KeyboardRow(for: row)
                if row != 3 {
                    Divider()
                }
            }
        }
        //.padding()
    }

    fileprivate func KeyBtn(_ keyIdx: KeyIndex) -> some View {

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
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                //.padding()
                .modifier(Key())
        }
    }

    private func KeyboardRow(for rowIdx: Int) -> some View {

        return HStack {
            if rowIdx < 3 {
                ForEach(1..<4) { col in
                    self.KeyBtn(.num((rowIdx * 3) + col))
                    if col != 3 {
                        Divider()
                    }
                }
            } else {
                self.KeyBtn(.clear)
                Divider()
                self.KeyBtn(.num(0))
                Divider()
                self.KeyBtn(.delete)
            }
        }
    }
}

struct CustomKeyboard_Previews: PreviewProvider {
    
    static var previews: some View {
        ZStack {
            Color(.gray)
            CustomKeyboard(inputNumbersArray: .constant([Int]()))
        }
    }
}
