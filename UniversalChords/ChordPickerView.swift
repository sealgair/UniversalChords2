//
//  ChordPickerView.swift
//  UniversalChords
//
//  Created by Chase Caster on 5/5/24.
//

import SwiftUI
import MusicTheory

struct ChordPickerView: View {
    @Binding var note: Key
    var body: some View {
        VStack(spacing: -1) {
            ForEach(Key.keysWithSharps) { aNote in
                let selected = aNote == note
                Text(aNote.description)
                    .padding(10)
                    .frame(width: 50)
                    .border(.black, width: 2)
                    .background(selected ? .black : .clear)
                    .foregroundColor(selected ? .white : .black)
                    .onTapGesture {
                        note = aNote
                    }
            }
        }
    }
}

#Preview {
    struct Preview: View {
        @State var note = Key("c")
        var body: some View {
            ChordPickerView(note: $note)
        }
    }
    return Preview()
}
