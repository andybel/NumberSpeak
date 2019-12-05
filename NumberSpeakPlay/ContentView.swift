//
//  ContentView.swift
//  NumberSpeakPlay
//
//  Created by Andy Bell on 17.11.19.
//  Copyright © 2019 bellovic. All rights reserved.
//

import SwiftUI
import AVFoundation

class LangVoice: ObservableObject {
    @Published var langId = "en-GB"
}

class InputChecker: ObservableObject {
    var testValue: Int = -1
    @Published var inputValue = 0
    @Published var inputNumbersArray = [Int]() {
        didSet {
            self.inputValue = Int(inputNumbersArray.compactMap({ "\($0)" }).joined()) ?? 0
            self.matchesTestValue = self.inputValue == self.testValue
        }
    }
    @Published var matchesTestValue = false

    func randomiseTestVal() {
        testValue = Int.random(in: 1..<100)
    }

    func clear() {
        testValue = -1
        inputNumbersArray.removeAll()
        inputValue = 0
    }
}

struct CustomKeyboard: View {

//    @Binding var inputValue: Int
//    @State private var inputNumbersArray = [Int]() {
//        didSet {
//            self.inputValue = Int(inputNumbersArray.compactMap({ "\($0)" }).joined()) ?? 0
//        }
//    }

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

struct ContentView: View {

    // MARK: styles
    private let topGradCol = Color(red: 235.0 / 255.0, green: 199.0 / 255.0, blue: 204.0 / 255.0)
    private let bottomGradCol = Color(red: 74.0 / 255.0, green: 199.0 / 255.0, blue: 226.0 / 255.0)
    private let titleFont = Font.system(size: 42, weight: .bold)
    private let inputFont = Font.system(size: 85, weight: .bold)

    // MARK: State vars
    @State private var loopIsActive = false
    @State private var numberOfPeople = false
    @State private var isShowingLangPicker = false
    //@State private var numberForTest = -1
    //@State private var keyboardInput: Int = 0

    @ObservedObject var selectedLang = LangVoice()
    @ObservedObject var inputChecker = InputChecker()

    private func speakString(stringToSpeak: String){

        let utterance = AVSpeechUtterance(string: stringToSpeak)
        utterance.voice = AVSpeechSynthesisVoice(language: selectedLang.langId)

        if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_8_3)
        {
            print("setting default speech rate")
            utterance.rate = AVSpeechUtteranceDefaultSpeechRate
        }else{
            utterance.rate = 0.1;
        }

        let synthesizer = AVSpeechSynthesizer()
        synthesizer.speak(utterance)
    }

    private func startTestWithRandomNumber() {
        self.inputChecker.randomiseTestVal()
        speakString(stringToSpeak: "\(self.inputChecker.testValue)")
    }

    var body: some View {

        ZStack {
            LinearGradient(gradient: Gradient(colors: [topGradCol, bottomGradCol]),
                           startPoint: .top,
                           endPoint: .bottom)
                .edgesIgnoringSafeArea(Edge.Set.all)

            GeometryReader { geo in

                VStack {
                    HStack {
                        Text("NumberSpeak")
                            .foregroundColor(.white)
                            .font(self.titleFont)
                            .frame(width: geo.size.width * 0.75,
                               alignment: .leading)

                        Button(action: {
                            self.isShowingLangPicker.toggle()
                        }) {
                            Image(self.selectedLang.langId)
                                .renderingMode(.original)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: geo.size.width * 0.1)
                        }
                    }
                    .frame(height: geo.size.height * 0.2)

                    ZStack {
                        VStack {

                            Button(action: {
                                self.startTestWithRandomNumber()
                            }) {
                                Image("playBtn").renderingMode(.original)
                            }

                            Text("\(self.inputChecker.inputValue)")
                                .foregroundColor(.white)
                                .font(self.inputFont)
                                .frame(height: 90)
                        }
                    }
                    .frame(height: geo.size.height * 0.4)


                    ZStack {

                        Color(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 8))

                        HStack {

                            Toggle(isOn: self.$loopIsActive) {
                                Image(systemName: "arrow.2.circlepath")
                                    .renderingMode(.original)
                            }
                            .frame(width: geo.size.width * 0.3, alignment: .leading)

                            HStack {
                                Text("Mode:").foregroundColor(.black)
                                Button("1 2 3") {
                                    print("select mode!")
                                }
                            }
                            .frame(width: geo.size.width * 0.3)

                            Button("< 1,000") {
                                print("select mode range")
                            }
                            .foregroundColor(.black)
                            .frame(width: geo.size.width * 0.3)
                        }
                    }
                    .frame(height: geo.size.height * 0.05)

                    CustomKeyboard(inputNumbersArray: self.$inputChecker.inputNumbersArray)
                        .frame(height: geo.size.height * 0.3)
                }
            }
        }
        .sheet(isPresented: $isShowingLangPicker) {
            LangPicker(selectedVoiceId: self.$selectedLang.langId)
        }
        .alert(isPresented: $inputChecker.matchesTestValue) { () -> Alert in
            Alert(title: Text("Win"), message: Text("Correct!!"), dismissButton: .default(Text("Continue"), action: {

                self.inputChecker.clear()
            }))
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
