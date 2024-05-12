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
    
    let instruments = [
        Instrument(name: "Guitar", strings: [
            Pitch("E2"),
            Pitch("A2"),
            Pitch("D3"),
            Pitch("G3"),
            Pitch("B3"),
            Pitch("E4"),
        ]),
        Instrument(name: "Ukulele", strings: [
            Pitch("G4"),
            Pitch("C4"),
            Pitch("E4"),
            Pitch("A5"),
        ]),
    ]
    @State private var instrument: Instrument
    
    init() {
        instrument = instruments[0]
    }
    
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
                ChordPickerView(note: $note)
            }.frame(maxHeight: .infinity)
            
            Picker("Instruments", selection: $instrument) {
                ForEach(instruments) { choice in
                    Text(choice.name).tag(choice)
                }
            }
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
