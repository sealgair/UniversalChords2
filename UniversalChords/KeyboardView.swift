//
//  KeyboardView.swift
//  UniversalChords
//
//  Created by Chase Caster on 6/6/24.
//

import SwiftUI
import MusicTheory

struct KeyboardView: View {
    var handedness: Handedness = .right
    var accidentals: Accidental = .sharp
    
    var chord: Chord
    
    var whiteKeyHeight: CGFloat = 70
    var blackKeyHeight: CGFloat = 55
    let fingerSize: CGFloat = 40
    
    @State var position: Pitch? = Pitch(stringLiteral:"A0")
    let baseNote = Pitch(stringLiteral:"A0")
    var topNote: Pitch {
        return position ?? baseNote
    }
    var notes: Array<Pitch> {
        return (0..<88).map({Pitch(rawValue: baseNote.rawValue + $0)!})
    }
    var wholeNotes: Array<Pitch> {
        notes.filter({ $0.key.accidental == .natural })
    }
    var halfNotes: Array<Pitch> {
        notes.filter({ $0.key.accidental != .natural })
    }
    
    func noteOffset(key: Key, width: Double) -> CGSize {
        var offset = CGSize(width: width, height: 0)
        if key.accidental != .natural {
            offset.width = width*2/3
            offset.height = whiteKeyHeight/2
            if key.accidental == .flat {
                offset.height *= -1
            }
            offset.height -= 2
        }
        if handedness == .left {
            offset.width = 0
            if key.accidental != .natural {
                offset.width = width/3
            }
            offset.width += fingerSize
        } else {
            offset.width -= fingerSize
        }
        offset.height -= 4
        return offset
    }
    
    var notesView: some View {
        GeometryReader() { geometry in
            ZStack() {
                let foreground = Color.white
                let background = Color.black
                ForEach(chord.keys, id: \.self) { key in
                    let natural = key.accidental == .natural
                    if let targetNote = topNote.nextPitch(inKey: key) {
                        let d = baseNote.wholeDistance(to: targetNote)
                        let off = noteOffset(key: key, width: geometry.size.width)
                        Text(key.to(accidental: accidentals).description)
                            .foregroundStyle(natural ? foreground : background)
                            .font(.title)
                            .background(alignment: .center) {
                                Circle()
                                .fill(natural ? background : foreground)
                                .frame(width: fingerSize, height: fingerSize)
                            }
                            .position(y: CGFloat(d) * (whiteKeyHeight-4))
                            .offset(off)
                    }
                }
            }
        }.offset(y: whiteKeyHeight/2+4)
    }
    
    var body: some View {
//        Text(topNote.description)
        if #available(iOS 17.0, *) {
            keyboardView
                .scrollPosition(id: $position, anchor: .top)
                .scrollTargetBehavior(.viewAligned)
                .safeAreaPadding(.vertical, 40)
        } else {
            keyboardView
        }
    }
    
    var whiteKeysView: some View {
        VStack(spacing: -4) {
            // White keys
            ForEach(wholeNotes, id: \.self) { note in
                Rectangle()
                    .fill(.white)
                    .frame(height: whiteKeyHeight)
                    .border(.black, width: 4)
                    .overlay() {
                        HStack() {
                            if (handedness == .right) {
                                Spacer()
                            }
                            Text(note.key.description)
                                .frame(width: fingerSize)
                            if (handedness == .left) {
                                Spacer()
                            }
                        }.padding(fingerSize/2)
                    }
            }
            Spacer()
        }
    }
    
    var blackKeysView: some View {
        VStack(spacing: whiteKeyHeight - blackKeyHeight - 4) {
            // Black keys
            ForEach(notes) { note in
                if (note.key.accidental != .natural) {
                    Rectangle()
                        .fill(.black)
                        .frame(height: blackKeyHeight)
                        .overlay() {
                            HStack() {
                                if (handedness == .right) {
                                    Spacer()
                                }
                                Text(note.key.to(accidental: accidentals).description)
                                    .foregroundColor(.white)
                                    .frame(width: fingerSize)
                                if (handedness == .left) {
                                    Spacer()
                                }
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
        .frame(alignment: self.handedness == .right ?  .leading : .trailing)
        .offset(y: whiteKeyHeight-(blackKeyHeight/2)-2)
    }
    
    var keyboardView: some View {
        ScrollView() {
            GeometryReader() { geometry in
                ZStack() {
                    if #available(iOS 17.0, *) {
                        whiteKeysView.scrollTargetLayout()
                    } else {
                        whiteKeysView
                    }
                    HStack() {
                        if (handedness == .left) {
                            Spacer()
                        }
                        blackKeysView.frame(
                            width: geometry.size.width * 2/3
                        )
                        if (handedness == .right) {
                            Spacer()
                        }
                    }
                    notesView
                }
            }.frame(height: (whiteKeyHeight-4) * 52)
        }
    }
}

#Preview {
    return KeyboardView(
        handedness: .right,
        chord: Chord(type: ChordType(third: .major), key: Key("A"))
    )
}
