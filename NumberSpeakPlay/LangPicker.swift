//
//  LangPicker.swift
//  NumberSpeakPlay
//
//  Created by Andy Bell on 04.12.19.
//  Copyright © 2019 bellovic. All rights reserved.
//

import SwiftUI
import AVFoundation

extension AVSpeechSynthesisVoice {

    func displayName() -> String {
        return (Locale.current as NSLocale).displayName(forKey: NSLocale.Key.identifier, value: self.language) ?? "n/a"
    }
}

struct LangPicker: View {

    @Environment(\.presentationMode) var presentationMode

    @Binding var selectedVoiceId: String 

    @State private var availableVoices = [AVSpeechSynthesisVoice]()

    func availableLangsContainsVoice(voice: AVSpeechSynthesisVoice) -> Bool {
        for addedVoice in availableVoices {
            if(voice.language == addedVoice.language){
                return true
            }
        }
        return false
    }

    func loadAvailableLangs() -> [AVSpeechSynthesisVoice] {

        let voices = AVSpeechSynthesisVoice.speechVoices()
        var voicesTemp = [AVSpeechSynthesisVoice]()
        for voice in voices {
            if(!availableLangsContainsVoice(voice: voice)){
                voicesTemp.append(voice)
                print("adding: \(voice.language)\n")
            }
        }
        return voicesTemp
    }

    var body: some View {
        NavigationView {
            List {
                ForEach(availableVoices, id: \.self) { lang in

                    HStack {

                        Image(lang.language)
                            .renderingMode(.original)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 99, height: 33)

                        Button(lang.displayName()) {
                            print("SELECTED: \(lang.language)")

                            self.selectedVoiceId = lang.language
                            self.presentationMode.wrappedValue.dismiss()
                        }

//                      Text(lang.displayName())
//
//                    }.onTapGesture {
//                        print("SELECTED: \(lang.language)")
//                       self.selectedVoiceId = lang.language
//                       self.presentationMode.wrappedValue.dismiss()
                    }
                }
            }.onAppear {
                self.availableVoices = self.loadAvailableLangs()
            }
        }
    }
}

//struct LangPicker_Previews: PreviewProvider {
//    static var previews: some View {
//        LangPicker(selectedVoice: LangVoice())
//    }
//}
