//
//  FretBoardView.swift
//  UniversalChords
//
//  Created by Chase Caster on 5/11/24.
//

import SwiftUI
import MusicTheory

struct ScrollOffsetPreferenceKey: PreferenceKey {
    static var defaultValue: CGPoint = .zero
    
    static func reduce(value: inout CGPoint, nextValue: () -> CGPoint) {
    }
}

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
    @AppStorage(kStoredHandedness) private var handedness: Handedness = .right
    @AppStorage(kStoredAccidentals) private var accidentals: Accidental = .sharp
    
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
        }
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
                let fingerings = instrument.fingerings(chord: chord, position: (position ?? 0))
                ForEach(Array(zip(fingerings, fingerings.indices)), id: \.1) { finger, s in
                    let key = accidentals == .flat ? finger.note.key.flat : finger.note.key.sharp
                    if (finger.position <= fretCount) {
                        Text(key.description)
                            .foregroundStyle(foreground)
                            .font(.title)
                            .background(alignment: .center) {
                                Circle()
                                .fill(background)
                                .frame(width: fingerSize, height: fingerSize)
                            }
                            .position(x: width * CGFloat(s),
                                    y: CGFloat(finger.position * fretHeight))
                    }
                }
            }
        }
    }
    
    var body: some View {
        VStack() {
//            Text("\(position!)")
            if #available(iOS 17.0, *) {
                // new style position tracking
                fretScroll
                    .scrollPosition(id: $position, anchor: .top)
                    .scrollTargetBehavior(.viewAligned)
                    .safeAreaPadding(.vertical, 40)
            } else {
                fretScroll
            }
        }
    }
    
    var fretScroll: some View {
        GeometryReader() { geometry in
            ScrollView() {
                
                if #available(iOS 17.0, *) {
                    fretContent
                } else {
                    // old style position tracking
                    fretContent
                    .background(GeometryReader { geometry in
                        Color.clear
                            .preference(key: ScrollOffsetPreferenceKey.self, value: geometry.frame(in: .named("fretboardScroll")).origin)
                    })
                    .onPreferenceChange(ScrollOffsetPreferenceKey.self) { value in
                        self.position = -Int(value.y/CGFloat(fretHeight))
                    }
                }
                Spacer().frame(height: max(geometry.size.height - CGFloat(fretHeight*5), CGFloat(fretHeight)))
            }.coordinateSpace(name: "fretboardScroll")
        }
    }
    
    var fretContent: some View {
        Grid() {
            let rightPad = fingerSize/2 + 10
            GridRow() {
                Text("")
                stringNamesView.padding(.trailing, rightPad)
            }
            GridRow() {
                if #available(iOS 17.0, *) {
                    fretNumbersView.scrollTargetLayout()
                } else {
                    fretNumbersView
                }
                ZStack() {
                    fretsView
                    stringsView
                    notesView
                }.frame(height: CGFloat((fretCount) * fretHeight))
                    .background(boardColor)
                    .padding(.trailing, rightPad)
            }
        }
    }
}

#Preview {
    FretBoardView(
        instrument: Instrument(name: "Test", strings: [
            Pitch("E4"),
            Pitch("E4"),
            Pitch("A4"),
        ]),
        chord: Chord(type: ChordType(third: .major), key: Key("C"))
    )
}
