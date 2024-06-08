//
//  KeyboardView.swift
//  UniversalChords
//
//  Created by Chase Caster on 6/6/24.
//

import SwiftUI
import MusicTheory

struct KeyboardView: View {
    @State var position: Int? = 0
    @Environment(\.colorScheme) var colorScheme
    @AppStorage(kStoredHandedness) private var handedness: Handedness = .right
    @AppStorage(kStoredAccidentals) private var accidentals: Accidental = .sharp
    
    var chord: Chord
    
    var whiteKeyHeight: CGFloat = 70
    var blackKeyHeight: CGFloat = 50
    let fingerSize: CGFloat = 40
    
    let baseNote = Pitch(stringLiteral:"A0")
    var notes: Array<Pitch> {
        return (0..<88).map({Pitch(rawValue: baseNote.rawValue + $0)!})
    }
    
    var notesView: some View {
        GeometryReader() { geometry in
            ZStack() {
                let foreground = Color.white
                let background = Color.black
                ForEach(chord.keys, id: \.self) { key in
                    let natural = key.accidental == .natural
                    let d = baseNote.key.wholeDistance(to: key)
                    let ox = natural ? 0 : -geometry.size.width/3
                    let oy = natural ? -2 : key.accidental == .flat ? -(whiteKeyHeight/2): (whiteKeyHeight/2)
                    Text(key.to(accidental: accidentals).description)
                        .foregroundStyle(natural ? foreground : background)
                        .font(.title)
                        .background(alignment: .center) {
                            Circle()
                            .fill(natural ? background : foreground)
                            .frame(width: fingerSize, height: fingerSize)
                        }
                        .position(x: geometry.size.width - fingerSize,
                                  y: CGFloat(d) * (whiteKeyHeight-4))
                        .offset(x: ox, y: oy)
                }
            }
        }.offset(y: whiteKeyHeight/2+4)
    }
    
    var body: some View {
        ScrollView() {
            GeometryReader () { geometry in
                ZStack() {
                    VStack(spacing: -4) {
                        // White keys
                        ForEach(notes) { note in
                            if (note.key.accidental == .natural) {
                                Rectangle()
                                    .fill(.white)
                                    .frame(width: geometry.size.width, height: whiteKeyHeight)
                                    .border(.black, width: 4)
                                    .overlay() {
                                        HStack() {
                                            Spacer()
                                            Text(note.key.description)
                                                .frame(width: fingerSize)
                                        }.padding(fingerSize/2)
                                    }
                            }
                        }
                        Spacer()
                    }
                    VStack(spacing: whiteKeyHeight - blackKeyHeight - 4) {
                        // Black keys
                        ForEach(notes) { note in
                            if (note.key.accidental != .natural) {
                                Rectangle()
                                    .fill(.black)
                                    .frame(width: geometry.size.width*2/3, height: blackKeyHeight)
                                    .overlay() {
                                        HStack() {
                                            Spacer()
                                            Text(note.key.to(accidental: accidentals).description)
                                            .foregroundColor(.white)
                                            .frame(width: fingerSize)
                                        }.padding(fingerSize/2)
                                    }
                            } else {
                                if ([Key("E"), Key("B")].contains(note.key)) {
                                    Spacer().frame(height: blackKeyHeight)
                                }
                            }
                        }
                        Spacer()
                    }
                    .frame(width: geometry.size.width, alignment: self.handedness == .right ?  .leading : .trailing)
                    .offset(y: whiteKeyHeight-(blackKeyHeight/2)-2)
                    notesView
                }
            }.frame(height: whiteKeyHeight * 52)
        }
    }
}

#Preview {
    KeyboardView(chord: Chord(type: ChordType(third: .minor), key: Key("C")))
}
