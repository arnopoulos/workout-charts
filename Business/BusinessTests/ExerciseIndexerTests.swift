//
//  ExerciseIndexerTests.swift
//  BusinessTests
//
//  Created by Andrew Arnopoulos on 3/4/21.
//

import Business
import XCTest

class ExerciseIndexerTests: XCTestCase {

    func testExerciseIndexerClustersExercisesByName() throws {
        let indexer = ExerciseIndexer([
            .init(name: "test1", date: Date(), repetitions: 1, weight: 10),
            .init(name: "test2", date: Date(), repetitions: 1, weight: 10),
            .init(name: "test1", date: Date(), repetitions: 1, weight: 10),
            .init(name: "test1", date: Date(), repetitions: 1, weight: 10),
            .init(name: "test2", date: Date(), repetitions: 1, weight: 10)
        ])
        XCTAssertEqual(indexer.exercises[0].data.count, 3)
        XCTAssertEqual(indexer.exercises[1].data.count, 2)
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
