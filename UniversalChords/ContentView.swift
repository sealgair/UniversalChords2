//
//  ContentView.swift
//  UniversalChords
//
//  Created by Chase Caster on 5/4/24.
//

import SwiftUI
import MusicTheory

struct ContentView: View {
    @State private var note = Key("c")
    @State private var thirdType = ChordThirdType.major
    @State private var fifthType = ChordFifthType.perfect
    @State private var sixthType = false
    private var chordType: ChordType {
        ChordType(
            third: thirdType,
            fifth: fifthType,
            sixth: sixthType ? ChordSixthType() : nil
        )
    }
    private var chord: Chord {
        return Chord(type: chordType, key: note)
    }
    
    var body: some View {
        VStack {
            Text(chord.description)
            Picker("Chord Third Type", selection: $thirdType) {
                ForEach(ChordThirdType.all) { chordType in
                    Text(chordType.description).tag(chordType)
                }
            }.pickerStyle(.segmented)
            Picker("Chord Fifth Type", selection: $fifthType) {
                ForEach(ChordFifthType.all) { chordType in
                    Text(chordType.description).tag(chordType)
                }
            }.pickerStyle(.segmented)
            HStack {
                HStack {
                    ForEach(chord.keys) { key in
                        Text(key.description)
                    }
                }.frame(maxWidth: .infinity)
                Picker("Note", selection: $note) {
                    ForEach(0...3, id: \.self) { i in
                        ForEach(Key.keysWithSharps) { note in
                            Text(note.description).tag(note)
                        }
                    }
                }
                .pickerStyle(.wheel)
                .frame(maxWidth: 80, maxHeight: .infinity)
            }.frame(maxHeight: .infinity)
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
