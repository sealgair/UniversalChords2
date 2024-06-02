//
//  SettingsView.swift
//  UniversalChords
//
//  Created by Chase Caster on 6/1/24.
//

import SwiftUI

enum Handedness: Int, Codable, CaseIterable {
    case left
    case right
}

struct SettingsView: View {
    @AppStorage("handedness") private var handedness: Handedness = .right
    
    var body: some View {
        VStack {
            HStack {
                Text("Handedness:")
                Picker("Handednesss", selection: $handedness) {
                    Text("left").tag(Handedness.left)
                    Text("right").tag(Handedness.right)
                }.pickerStyle(.segmented)
            }
        }.padding()
    }
}

#Preview {
    SettingsView()
}
