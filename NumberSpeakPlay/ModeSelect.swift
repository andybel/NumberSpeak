//
//  ModeSelect.swift
//  NumberSpeakPlay
//
//  Created by Andy Bell on 05.12.19.
//  Copyright © 2019 bellovic. All rights reserved.
//

import SwiftUI

enum TestMode: String {
    case numbers
    case dates
    case time

    static var allModes: [TestMode] {
        [.numbers, .dates, .time]
    }
}

struct ModeSelect: View {

    @Environment(\.presentationMode) var presentationMode

    @Binding var selectedMode: TestMode

    var body: some View {

        NavigationView {
            List(TestMode.allModes, id: \.self) { mode in
                Button(mode.rawValue.capitalized) {
                    self.selectedMode = mode
                    self.presentationMode.wrappedValue.dismiss()
                }
            }
        }
    }
}
