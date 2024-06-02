//
//  FretBoardView.swift
//  UniversalChords
//
//  Created by Chase Caster on 5/11/24.
//

import SwiftUI
import MusicTheory

struct FretBoardView: View {
    let darkNutColor = Color(r: 255, g: 255, b: 240)
    let darkFretColor =  Color(r: 137, g: 148, b: 153)
    let darkBoardColor = Color(r: 50, g: 0, b: 5)
    let darkStringColor = Color(r: 181, g: 166, b: 66)
    
    let lightNutColor = Color(r: 25, g: 45, b: 59)
    let lightFretColor = Color(r: 181, g: 166, b: 66)
    let lightBoardColor = Color(r: 238, g: 232, b: 226)
    let lightStringColor = Color(r: 137, g: 148, b: 153)
    
    var nutColor: Color { colorScheme == .dark ? darkNutColor : lightNutColor }
    var fretColor: Color { colorScheme == .dark ? darkFretColor : lightFretColor }
    var boardColor: Color { colorScheme == .dark ? darkBoardColor : lightBoardColor }
    var stringColor: Color { colorScheme == .dark ? darkStringColor : lightStringColor }
    
    let fretCount: Int = 16
    let fretHeight: Int = 80
    let fingerSize: CGFloat = 40
    
    var instrument: Instrument
    var stringCount: Int { instrument.strings.count }
    var orderedStrings: Array<Pitch> {
        switch(handedness) {
        case .right: instrument.strings
        case .left:instrument.strings.reversed()
        }
    }
    
    var chord: Chord
    @State var position: Int? = 0
    @Environment(\.colorScheme) var colorScheme
    @AppStorage("handedness") private var handedness: Handedness = .right
    
    var stringNamesView: some View {
        GeometryReader() { geometry in
            let width = (1/CGFloat(stringCount-1)) * geometry.size.width
            HStack(spacing: 0) {
                ForEach(orderedStrings, id: \.self) { string in
                    Text(string.key.description)
                    .font(.title2)
                    .frame(width: width)
                }
            }.offset(x: -width/2)
        }
    }
    
    var stringsView: some View {
        GeometryReader() { geometry in
            Path() { path in
                for string in 0...stringCount-1 {
                    let s: CGFloat = CGFloat(string)/CGFloat(stringCount-1)
                    let x: Int = Int(s * geometry.size.width)
                    path.move(to: CGPoint(x:x, y: -10))
                    path.addLine(to: CGPoint(x:x, y: fretHeight*fretCount+20))
                }
            }.stroke(stringColor, lineWidth: 3)
        }
    }
    
    var fretNumbersView: some View {
        VStack(spacing: 0) {
            ForEach(0...fretCount, id: \.self) { i in
                HStack {
                    Text(String(i))
                    .frame(height: CGFloat(fretHeight))
                    .font(.title3)
                    VStack() {
                        if ([3,5,7,9,12,15].contains(i)) {
                            Circle().frame(width: 10, height: 10)
                        } else {
                            Circle().fill(.clear).frame(width: 10, height: 10)
                        }
                        if (i == 12) {
                            Circle().frame(width: 10, height: 10)
                        }
                    }.offset(x: 5)
                }
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
            let background: Color = colorScheme == .dark ? .white : .black
            let foreground: Color = colorScheme == .dark ? .black : .white
            ZStack {
                let width = (1/CGFloat(stringCount-1)) * geometry.size.width
                ForEach(instrument.fingerings(chord: chord, position: (position ?? 0))) { finger in
                    let s = CGFloat(orderedStrings.firstIndex(of: finger.string) ?? 0)
                    Text(finger.note.key.description)
                        .foregroundStyle(foreground)
                        .font(.title)
                        .background(alignment: .center) {
                            Circle()
                            .fill(background)
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
            let rightPad = fingerSize/2 + 10
            Grid() {
                GridRow() {
                    Text("")
                    stringNamesView.padding(.trailing, rightPad)
                }
                GridRow() {
                    fretNumbersView
                    ZStack() {
                        fretsView
                        stringsView
                        notesView
                    }.frame(height: CGFloat(fretCount * fretHeight))
                    .background(boardColor)
                    .padding(.trailing, rightPad)
                }
            }
        }
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
