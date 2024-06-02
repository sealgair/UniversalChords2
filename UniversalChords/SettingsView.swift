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
                Text("set-hand-label")
                Picker("set-hand-label", selection: $handedness) {
                    Text("set-hand-left").tag(Handedness.left)
                    Text("set-hand-right").tag(Handedness.right)
                }.pickerStyle(.segmented)
            }
            GridRow {
                Text("set-accidentals-label")
                Picker("set-accidentals-label", selection: $accidentals) {
                    Text("set-accidentals-flat").tag(Accidental.flat)
                    Text("set-accidentals-sharp").tag(Accidental.sharp)
                }.pickerStyle(.segmented)
            }
        }.padding()
    }
}

#Preview {
    SettingsView()
}
