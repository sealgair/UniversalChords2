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
        case .major: return String(localized: "chord-major")
        case .minor: return String(localized: "chord-minor")
        }
    }
}

extension ChordFifthType: Identifiable {
    public var id: Self { self }
    
    public var label: String {
      switch self {
      case .perfect: return String(localized: "chord-none")
      case .augmented: return String(localized: "chord-aug")
      case .diminished: return String(localized: "chord-dim")
      }
    }
}

extension ChordSeventhType: Identifiable {
    public var id: Self { self }
    
    public var label: String {
        switch self {
        case .major: return String(localized: "chord-maj7")
        case .dominant: return String(localized: "chord-7")
        case .diminished: return String(localized: "chord-dim7")
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
        case .sus2: return String(localized: "chord-sus2")
        case .sus4: return String(localized: "chord-sus4")
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
    
    var flat: Key {
        guard let sharpId = Key.keysWithSharps.firstIndex(of: self) else { return self }
        return Key.keysWithFlats[sharpId]
    }
    
    var sharp: Key {
        guard let flatId = Key.keysWithFlats.firstIndex(of: self) else { return self }
        return Key.keysWithSharps[flatId]
    }
}

extension Pitch: Hashable {
    func add(semitones: Int) -> Pitch? {
        return Pitch(rawValue: self.rawValue + semitones)
    }
}
