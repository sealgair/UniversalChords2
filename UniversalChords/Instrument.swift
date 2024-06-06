//
//  Instrument.swift
//  UniversalChords
//
//  Created by Chase Caster on 5/5/24.
//

import Foundation
import MusicTheory


struct Finger: Identifiable, Hashable {
    let position: Int
    let string: Pitch
    var note: Pitch {
        return self.string + position
    }
    var id: String { "\(string): \(note)" }
}

typealias Fingering = Array<Finger>

let fingerCache = NSCache<NSString, AnyObject>()

struct Instrument: Identifiable, Hashable, Codable {
    let name: String
    let strings: [Pitch]
    var id: String { self.name }
    
    func fingerings(chord: Chord, position: Int) -> Fingering {
        var fingering = Fingering()
        for string in strings {
            let start = string.add(semitones: position) ?? string
            var positions = Array<Int>()
            for note in chord.keys {
                positions.append(position + start.key.distance(to: note))
            }
            fingering.append(Finger(position: positions.min() ?? 0, string: string))
        }
        return fingering
    }
}
