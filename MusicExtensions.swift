//
//  MusicExtensions.swift
//  UniversalChords
//
//  Created by Chase Caster on 5/4/24.
//

import Foundation
import MusicTheory

extension ChordThirdType: Identifiable {
    public var id: Self { self }
}

extension ChordFifthType: Identifiable {
    public var id: Self { self }
}

extension Key: Identifiable {
    public var id: Self { self }
    
    public var rawValue: Int { type.rawValue + accidental.rawValue }
    
    func distance(to: Key) -> Int {
        var dist = to.rawValue - self.rawValue
        while dist < 0 {
            dist += 12
        }
        return dist
    }
}

extension Pitch: Hashable {
    
}
