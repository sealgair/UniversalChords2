//
//  UniversalChordsTests.swift
//  UniversalChordsTests
//
//  Created by Chase Caster on 5/4/24.
//

import XCTest
import MusicTheory

final class UniversalChordsTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testNextPitch() throws {
        // Verify that Pitch.nextPitch() returns the correct pitch
    }
    
    func testPreviousPitch() throws {
        // Verify that Pitch.previousPitch() returns the correct pitch
    }
    
    func testWholeDIstance() throws {
        // Verify that Pitch.wholeDistance() returns the correct distance between pitches
        XCTAssertEqual(Pitch("A0").wholeDistance(to: Pitch("E1")), 4)
        XCTAssertEqual(Pitch("A0").wholeDistance(to: Pitch("C#1")), 3)
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }

}
