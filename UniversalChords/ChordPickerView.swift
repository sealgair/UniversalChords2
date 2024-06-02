//
//  ChordPickerView.swift
//  UniversalChords
//
//  Created by Chase Caster on 5/5/24.
//

import SwiftUI
import MusicTheory

struct ChordPickerView: View {
    @Binding var note: Key
    @Environment(\.colorScheme) var colorScheme
    @AppStorage("accidentals") private var accidentals: Accidental = .sharp
    
    var allKeys: Array<Key> {
        switch (accidentals) {
        case .flat: Key.keysWithFlats
        default: Key.keysWithSharps
        }
    }
    
    var body: some View {
        let background: Color = colorScheme == .dark ? .black : .white
        let foreground: Color = colorScheme == .dark ? .white : .black
        VStack(spacing: -1) {
            ForEach(allKeys) { aNote in
                let selected = aNote == note
                Text(aNote.description)
                    .padding(10)
                    .frame(width: 50)
                    .border(foreground, width: 2)
                    .background(selected ? foreground : background)
                    .foregroundColor(selected ? background : foreground)
                    .onTapGesture {
                        note = aNote
                    }
            }
        }
    }
}

#Preview {
    struct Preview: View {
        @State var note = Key("c")
        var body: some View {
            ChordPickerView(note: $note)
        }
    }
    return Preview()
}
