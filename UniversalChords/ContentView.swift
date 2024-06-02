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
    @State private var isSixth = false
    @State private var seventhType: ChordSeventhType? = nil
    @State private var suspendedType: ChordSuspendedType? = nil
    
    let instruments = [
        Instrument(name: "Guitar", strings: [
            Pitch("E2"),
            Pitch("A2"),
            Pitch("D3"),
            Pitch("G3"),
            Pitch("B3"),
            Pitch("E4"),
        ]),
        Instrument(name: "Soprano Ukulele", strings: [
            Pitch("G4"),
            Pitch("C4"),
            Pitch("E4"),
            Pitch("A5"),
        ]),
        Instrument(name: "Banjo", strings: [
            Pitch("D3"),
            Pitch("G3"),
            Pitch("B4"),
            Pitch("D4"),
        ]),
        Instrument(name: "Mandolin", strings: [
            Pitch("G3"),
            Pitch("D4"),
            Pitch("A5"),
            Pitch("E5"),
        ]),
        Instrument(name: "Bass", strings: [
            Pitch("E1"),
            Pitch("A1"),
            Pitch("D2"),
            Pitch("G2"),
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
            sixth: isSixth ? ChordSixthType() : nil,
            seventh: seventhType,
            suspended: suspendedType
        )
    }
    private var chord: Chord {
        return Chord(type: chordType, key: note)
    }
    
    var body: some View {
        VStack {
            Text(chord.notation).font(.title)
                .onTapGesture(count: 2) {
                    thirdType = .major
                    fifthType = .perfect
                    isSixth = false
                    seventhType = nil
                    suspendedType = nil
                }
            HStack {
                Picker("Chord Third Type", selection: $thirdType) {
                    ForEach(ChordThirdType.all) { chordType in
                        Text(chordType.label).tag(chordType)
                    }
                }.pickerStyle(.segmented)
                
                Picker("Chord Fifth Type", selection: $fifthType) {
                    ForEach(ChordFifthType.all) { chordType in
                        Text(chordType.label).tag(chordType)
                    }
                }.pickerStyle(.segmented)
                
                Picker(selection: $isSixth) {
                    Text("⊘").tag(false)
                    Text("6").tag(true)
                } label: {
                    Text("6th")
                }.pickerStyle(.segmented)
                    .containerRelativeFrame(.horizontal) { size, axis in
                        return size * 0.2
                    }
            }
            HStack {
                Picker("7th", selection: $seventhType) {
                    ForEach(ChordSeventhType.optionalAll, id: \.?.rawValue) { chordType in
                        Text(chordType?.label ?? "⊘").tag(chordType)
                    }
                }.pickerStyle(.segmented)
                
                Picker("Sus", selection: $suspendedType) {
                    ForEach(ChordSuspendedType.optionalAll, id: \.?.rawValue) { chordType in
                        Text(chordType?.label ?? "⊘").tag(chordType as ChordSuspendedType?)
                    }
                }
                .pickerStyle(.segmented)

            }
            HStack {
                FretBoardView(instrument: instrument, chord: chord)
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
