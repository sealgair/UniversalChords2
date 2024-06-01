//
//  FretBoardView.swift
//  UniversalChords
//
//  Created by Chase Caster on 5/11/24.
//

import SwiftUI
import MusicTheory

struct FretBoardView: View {
    let nutColor = Color(red: 25/255, green: 45/255, blue: 59/255)
    let fretColor = Color(red: 181/255, green: 166/255, blue: 66/255)
    let boardColor = Color(red: 238/255, green: 232/255, blue: 226/255)
    let stringColor = Color(red: 137/255, green: 148/255, blue: 153/255)
    let fretCount: Int = 14
    let fretHeight: Int = 80
    let fingerSize: CGFloat = 40
    
    var instrument: Instrument
    var strings: Int { instrument.strings.count }
    
    var chord: Chord
    @State var position: Int? = 0
    
    var stringNamesView: some View {
        GeometryReader() { geometry in
            HStack(spacing: 0) {
                let width = (1/CGFloat(strings+1)) * geometry.size.width
                Text("").frame(width: width/2)
                ForEach(instrument.strings, id: \.self) { string in
                    Text(string.key.description)
                    .font(.title2)
                    .frame(width: width)
                }
            }
        }
    }
    
    var stringsView: some View {
        GeometryReader() { geometry in
            Path() { path in
                for string in 1...strings {
                    let s: CGFloat = CGFloat(string)/CGFloat(strings+1)
                    let x: Int = Int(s * geometry.size.width)
                    path.move(to: CGPoint(x:x, y: -10))
                    path.addLine(to: CGPoint(x:x, y: fretHeight*(fretCount*2)))
                }
            }.stroke(stringColor, lineWidth: 3)
        }
    }
    
    var fretNumbersView: some View {
        VStack(spacing: 0) {
            ForEach(0...fretCount, id: \.self) { i in
                Text(String(i))
                .frame(height: CGFloat(fretHeight))
                .font(.title3)
            }
        }.scrollTargetLayout()
    }
    
    var fretsView: some View {
        GeometryReader() { geometry in
            Path() { path in
                path.move(to: CGPoint(x: 0 , y: 0))
                path.addLine(to: CGPoint(x: Int(geometry.size.width), y: 0))
            }.stroke(nutColor, lineWidth: 8)
            
            Path() { path in
                for fret in 1...fretCount {
                    path.move(to: CGPoint(x: 0 , y: fret * fretHeight))
                    path.addLine(to: CGPoint(x: Int(geometry.size.width), y: fret * fretHeight))
                }
            }.stroke(fretColor, lineWidth: 4)
        }
    }
    
    var notesView: some View {
        GeometryReader() { geometry in
            ZStack {
                let width = (1/CGFloat(strings+1)) * geometry.size.width
                ForEach(instrument.fingerings(chord: chord, position: (position ?? 0))) { finger in
                    let s = CGFloat(instrument.strings.firstIndex(of: finger.string) ?? 0) + 1
                    Text(finger.note.key.description)
                        .foregroundStyle(.white)
                        .font(.title)
                        .background(alignment: .center) {
                            Circle()
                            .fill(.black)
                            .frame(width: fingerSize, height: fingerSize)
                        }
                        .position(x: width * s,
                                y: CGFloat(finger.position * fretHeight))
                }
            }
        }
    }
    
    var body: some View {
//        Text(String(position!))
        ScrollView() {
            Grid() {
                GridRow() {
                    Text("")
                    stringNamesView
                }
                GridRow() {
                    fretNumbersView
                    ZStack() {
                        fretsView
                        stringsView
                        notesView
                    }.frame(height: CGFloat(fretCount * fretHeight))
                }
            }
            Spacer().frame(height: CGFloat(fretHeight))
        }
        .background(boardColor)
        .scrollPosition(id: $position, anchor: .top)
        .scrollTargetBehavior(.viewAligned)
        .safeAreaPadding(.vertical, 40)
    }
}

#Preview {
    FretBoardView(
        instrument: Instrument(name: "Guitar", strings: [
            Pitch("E2"),
            Pitch("A2"),
            Pitch("D3"),
            Pitch("G3"),
            Pitch("B3"),
            Pitch("E4"),
        ]),
        chord: Chord(type: ChordType(third: .major), key: Key("C"))
    )
}
