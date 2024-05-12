//
//  Instrument.swift
//  UniversalChords
//
//  Created by Chase Caster on 5/5/24.
//

import Foundation
import MusicTheory


struct Finger {
    let position: Int
    let string: Pitch
    var note: Pitch {
        return self.string + position
    }
}

typealias Fingering = Array<Finger>

let fingerCache = NSCache<NSString, AnyObject>()

struct Instrument: Identifiable, Hashable {
    let name: String
    let strings: [Pitch]
    var id: String { self.name }
}
