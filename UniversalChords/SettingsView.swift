//
//  SettingsView.swift
//  UniversalChords
//
//  Created by Chase Caster on 6/1/24.
//

import SwiftUI
import MusicTheory

enum Handedness: Int, Codable, CaseIterable {
    case left
    case right
}

struct SettingsView: View {
    @AppStorage("handedness") private var handedness: Handedness = .right
    @AppStorage("accidentals") private var accidentals: Accidental = .sharp
    
    var body: some View {
        Grid {
            GridRow {
                Text("Handedness:")
                Picker("Handednesss", selection: $handedness) {
                    Text("Lefty").tag(Handedness.left)
                    Text("Righty").tag(Handedness.right)
                }.pickerStyle(.segmented)
            }
            GridRow {
                Text("Accidentals:")
                Picker("Accidentals", selection: $accidentals) {
                    Text("Flat").tag(Accidental.flat)
                    Text("Sharp").tag(Accidental.sharp)
                }.pickerStyle(.segmented)
            }
        }.padding()
    }
}

#Preview {
    SettingsView()
}
