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

    func langsArrayContainsVoice(voice: AVSpeechSynthesisVoice, langs: [AVSpeechSynthesisVoice]) -> Bool {

        for addedVoice in langs {
            if(voice.language.contains(addedVoice.language)){
                return true
            }
        }
        return false
    }

    func loadAvailableLangs() -> [AVSpeechSynthesisVoice] {

        let voices = AVSpeechSynthesisVoice.speechVoices()
        var voicesTemp = [AVSpeechSynthesisVoice]()
        for voice in voices {
            if(!langsArrayContainsVoice(voice: voice, langs: voicesTemp)) {
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
                            UserDefaults.standard.set(lang.language, forKey: "SelectedLang")
                            self.selectedVoiceId = lang.language
                            self.presentationMode.wrappedValue.dismiss()
                        }

                        if lang.language == self.selectedVoiceId {
                            Image(systemName: "checkmark.circle.fill")
                                .frame(width: 30, height: 30, alignment: .trailing)
                        }
                    }
                }
            }.onAppear {
                self.availableVoices = self.loadAvailableLangs()
            }.navigationBarTitle("Select Language")
        }
    }
}

//struct LangPicker_Previews: PreviewProvider {
//    static var previews: some View {
//        LangPicker(selectedVoice: LangVoice())
//    }
//}
