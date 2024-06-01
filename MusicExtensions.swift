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
    
    public var label: String {
        switch self {
        case .major: return "Major"
        case .minor: return "Minor"
        }
    }
}

extension ChordFifthType: Identifiable {
    public var id: Self { self }
    
    public var label: String {
      switch self {
      case .perfect: return "⊘"
      case .augmented: return "Aug"
      case .diminished: return "Dim"
      }
    }
}

extension ChordSeventhType: Identifiable {
    public var id: Self { self }
    
    public var label: String {
        switch self {
        case .major: return "Maj7"
        case .dominant: return "7"
        case .diminished: return "Dim7"
        }
    }
    
    public static var optionalAll: [ChordSeventhType?] {
        return [nil] + self.all
    }
}

extension ChordSuspendedType: Identifiable {
    public var id: Self { self }
    
    public var label: String {
        switch self {
        case .sus2: return "Sus 2"
        case .sus4: return "Sus 4"
        }
    }
    
    public static var optionalAll: [ChordSuspendedType?] {
        return [nil] + self.all
    }
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
    func add(semitones: Int) -> Pitch? {
        return Pitch(rawValue: self.rawValue + semitones)
    }
}
