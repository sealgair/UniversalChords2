//
//  Instrument.swift
//  UniversalChords
//
//  Created by Chase Caster on 5/5/24.
//

import Foundation
import MusicTheory


struct Finger: Identifiable {
    let position: Int
    let string: Pitch
    var note: Pitch {
        return self.string + position
    }
    var id: Int { note.rawValue }
}

typealias Fingering = Array<Finger>

let fingerCache = NSCache<NSString, AnyObject>()

struct Instrument: Identifiable, Hashable {
    let name: String
    let strings: [Pitch]
    var id: String { self.name }
    
    func fingerings(chord: Chord) -> Fingering {
        var fingering = Fingering()
        for string in strings {
            var positions = Array<Int>()
            for note in chord.keys {
                positions.append(string.key.distance(to: note))
            }
            fingering.append(Finger(position: positions.min() ?? 0, string: string))
        }
        return fingering
    }
}
