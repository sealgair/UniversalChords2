//
//  ContentView.swift
//  UniversalChords
//
//  Created by Chase Caster on 5/4/24.
//

import SwiftUI
import MusicTheory

let kStoredHandedness = "handedness"
let kStoredAccidentals = "accidentals"
let kStoredInstrument = "instrument"

struct ContentView: View {
    @Environment(\.colorScheme) var colorScheme
    @AppStorage(kStoredHandedness) private var handedness: Handedness = .right
    @AppStorage(kStoredAccidentals) private var accidentals: Accidental = .sharp
    
    @State private var note = Key("c")
    @State private var thirdType = ChordThirdType.major
    @State private var fifthType = ChordFifthType.perfect
    @State private var isSixth = false
    @State private var seventhType: ChordSeventhType? = nil
    @State private var suspendedType: ChordSuspendedType? = nil
    
    @AppStorage(kStoredInstrument) private var instrumentName: String = String(localized:"instrument-guitar")
    
    private var foregroundColor: Color {
        return colorScheme == .light ? .white : .black
    }
    
    private var backgroudColor: Color {
        return colorScheme == .light ? .black : .white
    }
    
    let instruments: Array<Instrument> = [
        StringedInstrument(name: String(localized:"instrument-guitar"), strings: [
            Pitch("E2"),
            Pitch("A2"),
            Pitch("D3"),
            Pitch("G3"),
            Pitch("B3"),
            Pitch("E4"),
        ]),
        StringedInstrument(name: String(localized:"instrument-uke"), strings: [
            Pitch("G4"),
            Pitch("C4"),
            Pitch("E4"),
            Pitch("A5"),
        ]),
        StringedInstrument(name: String(localized:"instrument-bari-uke"), strings: [
            Pitch("D3"),
            Pitch("G3"),
            Pitch("B3"),
            Pitch("E4"),
        ]),
        StringedInstrument(name: String(localized:"instrument-banjo"), strings: [
            Pitch("D3"),
            Pitch("G3"),
            Pitch("B4"),
            Pitch("D4"),
        ]),
        StringedInstrument(name: String(localized:"instrument-mando"), strings: [
            Pitch("G3"),
            Pitch("D4"),
            Pitch("A5"),
            Pitch("E5"),
        ]),
        StringedInstrument(name: String(localized:"instrument-bass"), strings: [
            Pitch("E1"),
            Pitch("A1"),
            Pitch("D2"),
            Pitch("G2"),
        ]),
        StringedInstrument(name: String(localized:"instrument-violin"), strings: [
            Pitch("G3"),
            Pitch("D4"),
            Pitch("A5"),
            Pitch("E5"),
        ]),
        StringedInstrument(name: String(localized:"instrument-viola"), strings: [
            Pitch("C3"),
            Pitch("G3"),
            Pitch("D4"),
            Pitch("A5"),
        ]),
        StringedInstrument(name: String(localized:"instrument-cello"), strings: [
            Pitch("C2"),
            Pitch("G2"),
            Pitch("D3"),
            Pitch("A4"),
        ]),
        StringedInstrument(name: String(localized:"instrument-dulcimer-daa"), strings: [
            Pitch("A4"),
            Pitch("A4"),
            Pitch("D3"),
        ]),
        StringedInstrument(name: String(localized:"instrument-dulcimer-dad"), strings: [
            Pitch("D4"),
            Pitch("A4"),
            Pitch("D3"),
        ]),
        StringedInstrument(name: String(localized:"instrument-lute"), strings: [
            Pitch("E2"),
            Pitch("A2"),
            Pitch("D3"),
            Pitch("F#3"),
            Pitch("B3"),
            Pitch("E4"),
        ]),
        StringedInstrument(name: String(localized:"instrument-balalaika"), strings: [
            Pitch("E4"),
            Pitch("E4"),
            Pitch("A4"),
        ]),
        Piano(name: String(localized: "instrument-piano")),
    ]
    public var instrument: Instrument {
        get {
            instruments.first { i in
                i.name == instrumentName
            } ?? instruments[0]
        }
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
    private var noteCount: Int {
        chord.keys.count
    }
    private var stringCount: Int {
        instrument.stringCount
    }
    
    var body: some View {
        NavigationStack {
            navigationRoot
        }
    }
    
    var sixPicker: some View {
        Picker(selection: $isSixth) {
            Text("chord-none").tag(false)
            Text("chord-6").tag(true)
        } label: {
            Text("chord-6")
        }.pickerStyle(.segmented)
            .disabled(!isSixth && noteCount >= stringCount)
    }
    
    var navigationRoot: some View {
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
                ForEach(chord.keys) { key in
                    Text(key.description)
                        .font(.system(size: 10, weight: .bold))
                        .foregroundStyle(foregroundColor)
                        .background(alignment: .center) {
                            Circle()
                            .fill(backgroudColor)
                            .frame(width: 18, height: 18)
                        }.frame(width: 18)
                }
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
                
                if #available(iOS 17.0, *) {
                    sixPicker
                        .containerRelativeFrame(.horizontal) { size, axis in
                            return size * 0.2
                        }
                } else {
                    sixPicker
                }
            }
            HStack {
                Picker("7th", selection: $seventhType) {
                    ForEach(ChordSeventhType.optionalAll, id: \.?.rawValue) { chordType in
                        Text(chordType?.label ?? none).tag(chordType)
                    }
                }.pickerStyle(.segmented)
                    .disabled(seventhType == nil && noteCount >= stringCount)
                
                Picker("Sus", selection: $suspendedType) {
                    ForEach(ChordSuspendedType.optionalAll, id: \.?.rawValue) { chordType in
                        Text(chordType?.label ?? none).tag(chordType as ChordSuspendedType?)
                    }
                }
                .pickerStyle(.segmented)
                .disabled(suspendedType == nil && noteCount >= stringCount)

            }
            HStack {
                if let instrument = instrument as? StringedInstrument {
                    FretBoardView(
                        handedness: handedness,
                        accidentals: accidentals,
                        instrument: instrument, 
                        chord: chord
                    ).frame(maxWidth: 400)
                } else {
                    KeyboardView(
                        handedness: handedness,
                        accidentals: accidentals,
                        chord: chord
                    ).frame(maxWidth: 500)
                }
                ChordPickerView(note: $note)
            }.frame(maxHeight: .infinity)
            
            HStack {
                Spacer()
                Picker("Instruments", selection: $instrumentName) {
                    ForEach(instruments) { choice in
                        Text(choice.name).tag(choice.name)
                    }
                }.onChange(of: instrumentName) { val in
                    if(noteCount > stringCount) {
                        isSixth = false
                        seventhType = nil
                        suspendedType = nil
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
