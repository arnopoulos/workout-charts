//
//  ExerciseLoaderTests.swift
//  BusinessTests
//
//  Created by Andrew Arnopoulos on 2/28/21.
//

import XCTest
@testable import Business

class ExerciseLoaderTests: XCTestCase {

    func testLoadingOneExercise() throws {
        let sets = try model {
            """
            Oct 11 2020,Back Squat,1,10,45
            """
        }
        
        XCTAssertEqual(
            sets,
            [
                ExerciseService.Set(
                    name: "Back Squat",
                    date: Date(timeIntervalSince1970: 1602396000),
                    repetitions: 10,
                    weight: 45
                )
            ]
        )
    }
    
    func testLoadingEmptyData() throws {
        let sets = try model {
            ""
        }
        XCTAssertEqual(sets, [])
    }
    
    func testLoadingDataWithEmptyRows() throws {
        let sets = try model {
            """
                    
            Oct 11 2020,Back Squat,1,10,45
            """
        }
        XCTAssertEqual(
            sets,
            [
                ExerciseService.Set(
                    name: "Back Squat",
                    date: Date(timeIntervalSince1970: 1602396000),
                    repetitions: 10,
                    weight: 45
                )
            ]
        )
    }
    
    func testLoadingDataWithFileURL() throws {
        let path = try XCTUnwrap(Bundle.current.path(forResource: "WorkoutData", ofType: "txt"))
        let location = try XCTUnwrap(URL(string: "file://\(path)"))
        let service = ExerciseService(location: location)
        let models = try model(from: service)
        XCTAssertEqual(models.count, 582)
    }
}

extension ExerciseLoaderTests {
    func model(from contents: () -> String) throws -> [ExerciseService.Set] {
        
        let dataLoader = MockDataLoader {
            contents().data(using: .utf8)!
        }
        let loader = ExerciseService(
            location: URL(string: "https://google.com")!,
            dataLoader: dataLoader
        )
        return try model(from: loader)
    }
    
    func model(from service: ExerciseService) throws -> [ExerciseService.Set] {
        enum LoadingError: Error {
            case error
        }
        var models: [ExerciseService.Set]?
        let loadExpectation = expectation(description: "Loading expectation")
        service.load { (result: Result<[ExerciseService.Set], Error>) in
            guard case let .success(returned) = result else { return }
            models = returned
            loadExpectation.fulfill()
        }
        wait(for: [loadExpectation], timeout: 1.0)
        guard let unwrapped = models else { throw LoadingError.error }
        return unwrapped
    }
}
