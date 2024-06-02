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
        Instrument(name: String(localized:"instrument-guitar"), strings: [
            Pitch("E2"),
            Pitch("A2"),
            Pitch("D3"),
            Pitch("G3"),
            Pitch("B3"),
            Pitch("E4"),
        ]),
        Instrument(name: String(localized:"instrument-uke"), strings: [
            Pitch("G4"),
            Pitch("C4"),
            Pitch("E4"),
            Pitch("A5"),
        ]),
        Instrument(name: String(localized:"instrument-bari-uke"), strings: [
            Pitch("D3"),
            Pitch("G3"),
            Pitch("B3"),
            Pitch("E4"),
        ]),
        Instrument(name: String(localized:"instrument-banjo"), strings: [
            Pitch("D3"),
            Pitch("G3"),
            Pitch("B4"),
            Pitch("D4"),
        ]),
        Instrument(name: String(localized:"instrument-mando"), strings: [
            Pitch("G3"),
            Pitch("D4"),
            Pitch("A5"),
            Pitch("E5"),
        ]),
        Instrument(name: String(localized:"instrument-bass"), strings: [
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
        NavigationStack {
            mainstuff
        }
    }
    
    var mainstuff: some View {
        VStack {
            let none = String(localized: "chord-none")
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
                    Text("chord-none").tag(false)
                    Text("chord-6").tag(true)
                } label: {
                    Text("chord-6")
                }.pickerStyle(.segmented)
                    .containerRelativeFrame(.horizontal) { size, axis in
                        return size * 0.2
                    }
            }
            HStack {
                Picker("7th", selection: $seventhType) {
                    ForEach(ChordSeventhType.optionalAll, id: \.?.rawValue) { chordType in
                        Text(chordType?.label ?? none).tag(chordType)
                    }
                }.pickerStyle(.segmented)
                
                Picker("Sus", selection: $suspendedType) {
                    ForEach(ChordSuspendedType.optionalAll, id: \.?.rawValue) { chordType in
                        Text(chordType?.label ?? none).tag(chordType as ChordSuspendedType?)
                    }
                }
                .pickerStyle(.segmented)

            }
            HStack {
                FretBoardView(instrument: instrument, chord: chord)
                ChordPickerView(note: $note)
            }.frame(maxHeight: .infinity)
            
            HStack {
                Spacer()
                Picker("Instruments", selection: $instrument) {
                    ForEach(instruments) { choice in
                        Text(choice.name).tag(choice)
                    }
                }
                Spacer()
                NavigationLink {
                    SettingsView().navigationTitle("set-title")
                } label: {
                    Image(systemName:"gearshape.fill").foregroundColor(Color(UIColor.systemGray))
                }
            }
        }
        .padding()
    }
}

#Preview {
    ContentView().environment(\.locale, .init(identifier: "es"))
}
