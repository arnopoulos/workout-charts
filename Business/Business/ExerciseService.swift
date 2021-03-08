//
//  ModelLoader.swift
//  Business
//
//  Created by Andrew Arnopoulos on 2/28/21.
//

import Foundation

protocol DataLoader {
    func load(data: URL, _ callback: @escaping (Result<Data, Error>) -> Void)
}

extension Result {
    init?(value: Success?, error: Failure?) {
        if let error = error {
            self = .failure(error)
        } else if let value = value {
            self = .success(value)
        } else {
            return nil
        }
    }
}

extension URLSession: DataLoader {
    func load(data: URL, _ callback: @escaping (Result<Data, Error>) -> Void) {
        let task = dataTask(with: URLRequest(url: data)) { data, _, error in
            callback(
                //TODO Give more descriptive error
                Result(value: data, error: error) ?? .failure(NSError())
            )
        }
        task.resume()
    }
}

public struct ExerciseService {
    let location: URL
    
    private let dataLoader: DataLoader
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        //Assuming US date formatting
        formatter.dateFormat = "MMM dd yyyy"
        return formatter
    }()
    
    public init(location: URL) {
        self.init(location: location, dataLoader: URLSession.shared)
    }
    
    init(location: URL, dataLoader: DataLoader) {
        self.location = location
        self.dataLoader = dataLoader
    }
}

public extension ExerciseService {
    struct Set: Equatable {
        let name: String
        let date: Date
        let repetitions: Int
        let weight: Double
        
        public init(name: String, date: Date, repetitions: Int, weight: Double) {
            self.name = name
            self.date = date
            self.repetitions = repetitions
            self.weight = weight
        }
    }
    func load(callback: @escaping (Result<[Set], Error>) -> Void) {
        dataLoader.load(data: location) { result in
            
            let contents = result.map {
                String(decoding: $0, as: UTF8.self)
            }
            //TODO account for carriage return
            let setLines = contents.map { $0.split(separator: "\n") }
            let sets = setLines.map {
                Array($0.lazy.map {
                    $0.split(separator: ",")
                }
                //TODO Replace with check for invalid data
                //     to allow for
                .filter { $0.count == 5 }
                .map { component -> Set in
                    //
                    //TODO remove forced unwraps
                    let date = dateFormatter.date(from: String(component[0]))!
                    let name = String(component[1])
                    //Assuming that there will only ever be one set per line item
                    //Can be adjusted later if that becomes false down the line
                    let repititions = Int(component[3])!
                    let weight = Double(component[4])!
                    return Set(
                        name: name,
                        date: date,
                        repetitions: repititions,
                        weight: weight
                    )
                })
            }
            callback(sets)
        }
    }
}
