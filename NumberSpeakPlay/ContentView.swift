//
//  ContentView.swift
//  NumberSpeakPlay
//
//  Created by Andy Bell on 17.11.19.
//  Copyright © 2019 bellovic. All rights reserved.
//

import SwiftUI

struct Key: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.largeTitle)
            .background(Color.white)
            .foregroundColor(Color.black)
    }
}

struct ContentView: View {

    let topGradCol = Color(red: 235.0 / 255.0, green: 199.0 / 255.0, blue: 204.0 / 255.0)
    let bottomGradCol = Color(red: 74.0 / 255.0, green: 199.0 / 255.0, blue: 226.0 / 255.0)

    let titleFont = Font.system(size: 42, weight: .bold)
    let inputFont = Font.system(size: 85, weight: .bold)

    @State private var loopIsActive = false
    @State private var numberOfPeople = false

    fileprivate func KeyText(_ idx: Int, geo: GeometryProxy) -> some View {

        return Button(action: {
            print("shaba: \(idx)")
        }) {
            Text("\(idx)")
                .frame(width: geo.size.width * 0.3, height: geo.size.height * 0.25)
                .modifier(Key())
        }
    }

    var body: some View {

        ZStack {
            LinearGradient(gradient: Gradient(colors: [topGradCol, bottomGradCol]),
                           startPoint: .top,
                           endPoint: .bottom)
                .edgesIgnoringSafeArea(Edge.Set.all)

            GeometryReader { geo in

                VStack {

                    // Title
                    HStack {
                        Text("NumberSpeak")
                            .foregroundColor(.white)
                            .font(self.titleFont)
                            .frame(width: geo.size.width * 0.75,
                               alignment: .leading)

                        Image("Germany")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: geo.size.width * 0.1)
                    }
                    .frame(height: geo.size.height * 0.2)

                    ZStack {
                        //Color(.blue)
                        //Text("<Main Button, Timer and Input go here>")

                        VStack {

                            Color(.white)
                                .frame(width: geo.size.width * 0.4,
                                                height: geo.size.width * 0.4,
                                                alignment: .center)
                            Text("245")
                                .foregroundColor(.white)
                                .font(self.inputFont)
                        }
                    }
                    .frame(height: geo.size.height * 0.4)


                    ZStack {

                        Color(.white).clipShape(RoundedRectangle(cornerRadius: 8))

                        HStack {

                            Toggle(isOn: self.$loopIsActive) {

                                Image(systemName: "arrow.2.circlepath").renderingMode(.original)

                            }.frame(width: geo.size.width * 0.3)

                            HStack {
                                Text("Mode:").foregroundColor(.black)
                                Text("1 2 3").foregroundColor(.blue)
                            }.frame(width: geo.size.width * 0.3)

                            HStack {
                                Text("< 1,000").foregroundColor(.black)
                            }.frame(width: geo.size.width * 0.3)
                        }
                    }
                    .frame(height: geo.size.height * 0.05)


                    ZStack {
                        //Color(.green)
                        //Text("<Keyboard goes here>")

                        GeometryReader { geo in

                            VStack {

                                HStack {
                                    ForEach(1..<4) {
                                        self.KeyText($0, geo: geo)
                                    }
                                }

                                HStack {
                                    ForEach(4..<7) {
                                        self.KeyText($0, geo: geo)
                                    }
                                }

                                HStack {
                                    ForEach(7..<10) {
                                        self.KeyText($0, geo: geo)
                                    }
                                }

                                HStack {

                                    self.KeyText(666, geo: geo)
                                    self.KeyText(0, geo: geo)
                                    self.KeyText(999, geo: geo)
                                }

                            }

                        }

                    }
                    .frame(height: geo.size.height * 0.35)
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
