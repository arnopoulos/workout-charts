//
//  BundleLocator.swift
//  BusinessTests
//
//  Created by Andrew Arnopoulos on 3/1/21.
//

import Foundation

private class BundleLocator {}

extension Bundle {
    static let current = Bundle(for: BundleLocator.self)
}
