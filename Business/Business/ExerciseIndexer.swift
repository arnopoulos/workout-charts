//
//  ExerciseIndexer.swift
//  Business
//
//  Created by Andrew Arnopoulos on 3/4/21.
//

import Foundation

public struct ExerciseIndexer {
    public let exercises: [Exercise]
}

public extension ExerciseIndexer {
    init(_ sets: [ExerciseService.Set]) {
        let setMapping = sets.cluster(with: \.name)
        exercises = setMapping.reduce([]) { (partial, keyValuePair) -> [Exercise] in
            let data = keyValuePair.value.cluster(with: \.date).map {
                Exercise.Cluster(
                    date: $0.key,
                    sets: $0.value.map { ($0.repetitions, $0.weight) }
                )
            }
            return partial + [
                Exercise(
                    name: keyValuePair.key,
                    data: data
                )
            ]
        }.sorted { $0.name < $1.name }
    }
}

extension ExerciseIndexer {
    public class Exercise {
        public struct Cluster {
            public typealias Set = (repetitions: Int, weight: Double)
            public let date: Date
            public let sets: [Set]
            public let oneRepMax: Double
            
            init(date: Date, sets: [Set]) {
                self.date = date
                self.sets = sets
                //In the future we might want to store the lower and upper bounds.
                oneRepMax = sets.map {
                    $0.weight * (36.0 / (37.0 - Double($0.repetitions)))
                }.reduce(0, max)
            }
        }
        public let name: String
        public let data: [Cluster]
        
        init(name: String, data: [Cluster]) {
            self.name = name
            self.data = data.sorted { $0.date < $1.date }
            
        }
    }
}

public extension ExerciseService {
    func load(callback: @escaping (Result<ExerciseIndexer, Error>) -> Void) {
        load { result in
            callback(result.map { ExerciseIndexer($0) })
        }
    }
}
