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

    // MARK: State vars
    @State private var loopIsActive = false
    @State private var isShowingLangPicker = false
    @State private var isShowingModePicker = false
    @State private var isShowingRangePicker = false
    @State private var maxNumberRange: Double = 100
    
    @State private var timerFromVal: CGFloat = 0.0

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
        self.timerFromVal = 0.99
        self.inputChecker.randomiseTestVal()
        speakString(stringToSpeak: "\(self.inputChecker.testValue)")
    }

    var body: some View {

        ZStack {
            LinearGradient(gradient: Gradient(colors: [Styles.topGradCol, Styles.bottomGradCol]),
                           startPoint: .top,
                           endPoint: .bottom)
                .edgesIgnoringSafeArea(Edge.Set.all)


            VStack {
                
                HStack {
                    Text("NumberSpeak")
                        .foregroundColor(.white)
                        .font(Styles.titleFont)

                    Button(action: {
                        self.isShowingLangPicker.toggle()
                    }) {
                        Image(self.selectedLang.langId)
                            .renderingMode(.original)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(height: 30)
                    }
                    .sheet(isPresented: $isShowingLangPicker) {
                        LangPicker(selectedVoiceId: self.$selectedLang.langId)
                    }
                }

                ZStack {
                    VStack {

                        ZStack {
                            
                            Button(action: {
                                self.startTestWithRandomNumber()
                            }) {
                                Image("playBtn").renderingMode(.original)
                            }
                            
                            if loopIsActive {
                                withAnimation {
                                    AnimatedRing(fromVal: $timerFromVal, col: .purple)
                                }
                            }
                        }
                        .frame(width: 180, height: 180, alignment: .center)
                        
                        
                        Text("\(self.inputChecker.inputValue)")
                            .foregroundColor(.white)
                            .font(Styles.inputFont)
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
                            .sheet(isPresented: $isShowingModePicker) {
                                ModeSelect(selectedMode: self.$testMode)
                            }
                        }
                        .padding(.horizontal, /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
                        
                        Divider()
                        
                        HStack {
                            if self.testMode == .numbers {
                                Button("< \(Int(self.maxNumberRange))") {
                                    withAnimation {
                                        self.isShowingRangePicker.toggle()
                                    }
                                }
                                .frame(width: 60)
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
                            withAnimation {
                                self.isShowingRangePicker.toggle()
                            }
                        }
                    }
                    .padding(.horizontal, /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
                }

                CustomKeyboard(inputNumbersArray: self.$inputChecker.inputNumbersArray)
            }
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
