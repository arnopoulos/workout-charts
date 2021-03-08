//
//  MockDataLoader.swift
//  BusinessTests
//
//  Created by Andrew Arnopoulos on 2/28/21.
//

import Foundation
@testable import Business

class MockDataLoader {
    var result: Result<Data, Error>  = .failure(NSError())
    private(set) var url: URL?
    
    init(_ value: () -> Data) {
        self.result = .success(value())
    }
}

extension MockDataLoader: DataLoader {
    func load(data: URL, _ callback: @escaping (Result<Data, Error>) -> Void) {
        self.url = data
        callback(result)
    }
}
