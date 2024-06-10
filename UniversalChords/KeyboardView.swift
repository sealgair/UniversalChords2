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
    
    let whiteKeyHeight: CGFloat = 60
    let blackKeyHeight: CGFloat = 50
    let fingerSize: CGFloat = 40
    let keyCount = 88
    
    @State var position: Pitch?
    let lowestNote = Pitch(stringLiteral:"A0")
    var highestNote: Pitch {
        Pitch(rawValue: lowestNote.rawValue + keyCount-1)!
    }
    var baseNote: Pitch {
        handedness == .left ? lowestNote : highestNote
    }
    var topNote: Pitch {
        return position ?? Pitch(rawValue: Pitch(stringLiteral: "C4").rawValue + ((handedness == .right) ? 8 : -4))!
    }
    var notes: Array<Pitch> {
        let notes = (0..<keyCount).map({Pitch(rawValue: lowestNote.rawValue + $0)!})
        if handedness == .right {
            return notes.reversed()
        } else {
            return notes
        }
    }
    var wholeNotes: Array<Pitch> {
        notes.filter({ $0.key.isNatural })
    }
    var halfNotes: Array<Pitch> {
        notes.filter({ !$0.key.isNatural })
    }
    
    func notePosition(key: Key, width: Double) -> CGPoint {
        var position = CGPoint(x: width, y: 0)
        
        if let nextNote = handedness == .right ? topNote.previousPitch(inKey: key) : topNote.nextPitch(inKey: key) {
            position.y = CGFloat(baseNote.wholeDistance(to: nextNote)) * (whiteKeyHeight-4)
        } else {
            // some kind of error state?
        }
        
        if !key.isNatural {
            position.x = width*2/3
            var yoff = whiteKeyHeight/2
            if key.accidental == .flat {
                yoff *= -1
            }
            position.y -= yoff + 2
        }
        if handedness == .left {
            position.x = 0
            if !key.isNatural {
                position.x = width/3
            }
            position.x += fingerSize
        } else {
            position.x -= fingerSize
        }
        return position
    }
    
    var notesView: some View {
        GeometryReader() { geometry in
            ZStack() {
                let foreground = Color.white
                let background = Color.black
                ForEach(chord.keys, id: \.self) { key in
                    Text(key.to(accidental: accidentals).description)
                        .frame(alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                        .foregroundStyle(key.isNatural ? foreground : background)
                        .font(.title)
                        .background(alignment: .center) {
                            Circle()
                            .fill(key.isNatural ? background : foreground)
                            .frame(width: fingerSize, height: fingerSize)
                        }
                        .position(notePosition(key: key, width: geometry.size.width))
                }
            }
        }.offset(y: whiteKeyHeight/2)
    }
    
    var body: some View {
//        Text(topNote.description)
//        HStack() {
//            ForEach(chord.keys) { k in
//                Text(k.description)
//            }
//        }
        if #available(iOS 17.0, *) {
            keyboardView
                .scrollPosition(id: $position, anchor: .top)
                .defaultScrollAnchor(.center)
                .scrollTargetBehavior(.viewAligned)
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
                            Spacer()
                            if (note == Pitch("C4")) {
                                // middle C
                                Text("-C-")
                                    .font(.title2).fontWeight(.bold)
                                    .foregroundColor(.black)
                                    .frame(width: fingerSize, alignment: .center)
                            } else {
                                Text(note.key.description)
                                    .foregroundColor(.black)
                                    .frame(width: fingerSize, alignment: .center)
                            }
                        }.padding(fingerSize/2)
                            .environment(\.layoutDirection, (handedness == .right) ? .leftToRight : .rightToLeft)
                    }
            }
            Spacer()
        }
    }
    
    var blackKeysView: some View {
        VStack(spacing: whiteKeyHeight - blackKeyHeight - 4) {
            // Black keys
            ForEach(notes) { note in
                if (!note.key.isNatural) {
                    Rectangle()
                        .fill(.black)
                        .frame(height: blackKeyHeight)
                        .overlay() {
                            HStack() {
                                Spacer()
                                Text(note.key.to(accidental: accidentals).description)
                                    .foregroundColor(.white)
                                    .frame(width: fingerSize)
                            }.padding(fingerSize/2)
                                .environment(\.layoutDirection, (handedness == .right) ? .leftToRight : .rightToLeft)
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
        .offset(y: whiteKeyHeight-(blackKeyHeight/2)-6)
    }
    
    var keyboardView: some View {
        ScrollView() {
            if #available(iOS 17.0, *) {
                scrollContent
            } else {
                // old style position tracking
                scrollContent
                    .background(GeometryReader { geometry in
                        Color.clear
                            .preference(key: ScrollOffsetPreferenceKey.self, value: geometry.frame(in: .named("keyboardScroll")).origin)
                    })
                    .onPreferenceChange(ScrollOffsetPreferenceKey.self) { value in
                        self.position = wholeNotes[max(Int(-value.y/whiteKeyHeight)+1, 0)]
                    }
            }
        }.coordinateSpace(name: "keyboardScroll")
    }
    
    var scrollContent: some View {
        GeometryReader() { geometry in
            ZStack() {
                if #available(iOS 17.0, *) {
                    whiteKeysView
                        .scrollTargetLayout()
                } else {
                    whiteKeysView
                }
                HStack() {
                    blackKeysView.frame(
                        width: geometry.size.width * 2/3
                    )
                    Spacer()
                }.environment(\.layoutDirection, (handedness == .right) ? .leftToRight : .rightToLeft)
                notesView
            }
        }.frame(height: (whiteKeyHeight-4) * CGFloat(wholeNotes.count))
    }
}

#Preview {
    return KeyboardView(
        handedness: .left,
        chord: Chord(type: ChordType(third: .major), key: Key("A"))
    )
}
