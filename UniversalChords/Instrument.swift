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
    
    func nextPosition(at: Key) -> Finger {
        let newPosition = position + self.note.key.distance(to: at)
        return Finger(position: newPosition, string: string)
    }
}

typealias Fingering = Array<Finger>

extension Fingering {
    
    func nextMissing(chord: Chord) -> Key? {
        let missing = Set(chord.keys).subtracting(Set(self.map({ finger in
            finger.note.key
        })))
        if missing.count > 0 {
            return missing.first
        } else {
            return nil
        }
    }
    
    mutating func replaceBestFinger(replacement: Finger) {
        // last > first > highest
        if self.last?.string == replacement.string {
            self[endIndex-1] = replacement
        } else if self.first?.string == replacement.string {
            self[0] = replacement
        } else {
            if let i = self.lastIndex(where: {f in f.string == replacement.string}) {
                self[i] = replacement
            }
        }
    }
}

let fingerCache = NSCache<NSString, AnyObject>()

class Instrument: Identifiable, Hashable, Codable {
    
    let name: String
    var id: String { self.name }
    var stringCount: Int { 0 }
    
    init (name: String) {
        self.name = name
    }
    
    static func == (lhs: Instrument, rhs: Instrument) -> Bool {
        return lhs.name == rhs.name
    }    
    
    public func hash(into hasher: inout Hasher) {
        return hasher.combine(id)
    }
}

class StringedInstrument: Instrument {
    
    let strings: [Pitch]
    override var stringCount: Int { strings.count }
    
    init(name: String, strings: [Pitch]) {
        self.strings = strings
        super.init(name: name)
    }
    
    required init(from decoder: any Decoder) throws {
        fatalError("init(from:) has not been implemented")
    }
    
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
        var loops = 0
        // make sure that all notes in the chord are accounted for in the fingering
        while let missingKey = fingering.nextMissing(chord: chord) {
            if let toReplace = fingering.min(by: { lhs, rhs in
                lhs.note.key.distance(to: missingKey) < rhs.note.key.distance(to: missingKey)
            }) {
                fingering.replaceBestFinger(replacement: toReplace.nextPosition(at: missingKey))
            }
            loops += 1
            if loops > strings.count {
                break // don't try more times than there are strings, just give up
            }
        }
        return fingering
    }
}


class Piano: Instrument {
    override var stringCount: Int { 88 }
}
