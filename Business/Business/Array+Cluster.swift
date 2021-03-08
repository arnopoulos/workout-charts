//
//  Array+Cluster.swift
//  Business
//
//  Created by Andrew Arnopoulos on 3/4/21.
//

import Foundation

extension Array {
    func cluster<Value: Hashable>(with key: KeyPath<Self.Element, Value>) -> Dictionary<Value, Self> {
        var clusterMapping = [Value: Self]()
        for set in self {
            let partial = clusterMapping[set[keyPath: key]] ?? []
            clusterMapping[set[keyPath: key]] = partial + [set]
        }
        return clusterMapping
    }
}
