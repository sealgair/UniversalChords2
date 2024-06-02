//
//  SettingsView.swift
//  UniversalChords
//
//  Created by Chase Caster on 6/1/24.
//

import SwiftUI

struct SettingsView: View {
    @State private var lefty = false
    
    var body: some View {
        VStack {
            HStack {
                Text("Handedness:")
                Picker("Handednesss", selection: $lefty) {
                    Text("left").tag(true)
                    Text("right").tag(false)
                }.pickerStyle(.segmented)
            }
        }.padding()
    }
}

#Preview {
    SettingsView()
}
