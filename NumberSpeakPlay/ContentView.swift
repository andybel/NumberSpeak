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
    @Published var langId = UserDefaults.standard.string(forKey: "SelectedLang") ?? "en-GB"
}

class InputChecker: ObservableObject {
    var testValue: Int = -1
    var maxValue = 100
    @Published var inputValue = 0
    @Published var inputNumbersArray = [Int]() {
        didSet {
            self.inputValue = Int(inputNumbersArray.compactMap({ "\($0)" }).joined()) ?? 0
            self.matchesTestValue = self.inputValue == self.testValue
        }
    }
    @Published var matchesTestValue = false

    func randomiseTestVal() {
        testValue = Int.random(in: 1..<maxValue)
    }

    func clear() {
        testValue = -1
        inputNumbersArray.removeAll()
        inputValue = 0
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
    @State private var isShowingModePicker = false
    @State private var isShowingRangePicker = false
    @State private var maxNumberRange: Double = 100

    @State private var testMode = TestMode.numbers

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


            VStack {
                
                HStack {
                    Text("NumberSpeak")
                        .foregroundColor(.white)
                        .font(self.titleFont)

                    Button(action: {
                        self.isShowingLangPicker.toggle()
                    }) {
                        Image(self.selectedLang.langId)
                            .renderingMode(.original)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(height: 30)
                    }
                }

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
                            .minimumScaleFactor(0.01)
                            .frame(height: 90)
                            .animation(.easeIn)
                    }
                }


                ZStack {

                    Color(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 8))

                    HStack {

                        HStack {
                            Toggle(isOn: self.$loopIsActive) {
                                Image(systemName: "arrow.2.circlepath")
                                    .renderingMode(.original)
                            }

                        }
                        .frame(width: 70)
                        .padding(.horizontal, /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
                        
                        Divider()
                        
                        HStack {
                            Text("Mode:").foregroundColor(.black)
                            Button("\(self.testMode.rawValue.capitalized)") {
                                self.isShowingModePicker.toggle()
                            }
                        }
                        .padding(.horizontal, /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
                        
                        Divider()
                        
                        HStack {
                            if self.testMode == .numbers {
                                Button("< \(Int(self.maxNumberRange))") {
                                    self.isShowingRangePicker.toggle()
                                }
                                .foregroundColor(.black)
                                .animation(.easeIn)
                            }
                        }
                        .padding(.horizontal, /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
                    }
                }
                .frame(height: 40)
                .padding(.horizontal, /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)

                if self.isShowingRangePicker {

                    HStack {
                        Slider(value: self.$maxNumberRange, in: 1...1000, step: 0.1)
                        Button("done") {
                            self.inputChecker.maxValue = Int(self.maxNumberRange)
                            self.isShowingRangePicker.toggle()
                        }
                    }
                    .padding(.horizontal, /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
                }

                CustomKeyboard(inputNumbersArray: self.$inputChecker.inputNumbersArray)
            }
        }
        .sheet(isPresented: $isShowingLangPicker) {
            LangPicker(selectedVoiceId: self.$selectedLang.langId)
        }
//        .sheet(isPresented: $isShowingModePicker) {
//            ModeSelect(selectedMode: self.$testMode)
//        }
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
