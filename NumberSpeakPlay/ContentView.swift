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

struct Key: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.largeTitle)
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .foregroundColor(Color.black)
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
    @State private var inputNumbers = [Int]() {
        didSet {

            if let inputJoined = Int(inputNumbers.compactMap({ "\($0)" }).joined()) {

                if inputJoined == numberForTest {
                    isShowingForTestSuccess = true
                }
            }
        }
    }
    @State private var isShowingForTestSuccess = false
    @State private var isShowingLangPicker = false
    @State private var numberForTest = -1

    @ObservedObject var selectedLang = LangVoice()

    enum KeyUtilIndex: Int {
        case clear = 10
        case delete = 12
    }

    private func keyText(for idx: Int) -> String {
        switch idx {
        case KeyUtilIndex.clear.rawValue:
            return "clear"
        case KeyUtilIndex.delete.rawValue:
            return "delete"
        default:
            return "\(idx)"
        }
    }

    fileprivate func KeyBtn(_ idx: Int, geo: GeometryProxy) -> some View {

        return Button(action: {
            switch idx {
            case KeyUtilIndex.clear.rawValue:
                self.inputNumbers.removeAll()
            case KeyUtilIndex.delete.rawValue:
                guard self.inputNumbers.count > 0 else { return }
                self.inputNumbers.removeLast()
            default:
                self.inputNumbers.append(idx)
            }

        }) {
            Text(keyText(for: idx))
                .frame(width: geo.size.width * 0.3,
                       height: geo.size.height * 0.25)
                .modifier(Key())
        }
    }

    private func KeyboardRow(for rowIdx: Int, geo: GeometryProxy) -> some View {

        return HStack {
            if rowIdx < 3 {
                ForEach(1..<4) { col in
                    self.KeyBtn(((rowIdx * 3) + col), geo: geo)
                }
            } else {
                self.KeyBtn(KeyUtilIndex.clear.rawValue, geo: geo)
                self.KeyBtn(0, geo: geo)
                self.KeyBtn(KeyUtilIndex.delete.rawValue, geo: geo)
            }
        }
    }

    fileprivate func KeyboardView() -> some View {
        return ZStack {
            GeometryReader { geo in
                VStack {
                    ForEach(0..<4) { row in
                        self.KeyboardRow(for: row, geo: geo)
                    }
                }
            }
        }
    }

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

        numberForTest = Int.random(in: 1..<100)
        speakString(stringToSpeak: "\(numberForTest)")
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

                            Text(self.inputNumbers.compactMap({ "\($0)" }).joined())
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

                    self.KeyboardView()
                        .frame(height: geo.size.height * 0.3)
                }
            }
        }
        .sheet(isPresented: $isShowingLangPicker) {
            LangPicker(selectedVoiceId: self.$selectedLang.langId)
        }
        .alert(isPresented: $isShowingForTestSuccess) { () -> Alert in
            Alert(title: Text("\(numberForTest)"), message: Text("Correct!!"), dismissButton: .default(Text("Continue"), action: {
                self.inputNumbers.removeAll()
                self.numberForTest = -1
            }))
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
