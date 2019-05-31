//
//  Random.swift
//  RecipeSearch
//
//  Created by Mark Vasiv on 31/05/2019.
//  Copyright © 2019 Mark Vasiv. All rights reserved.
//

import Foundation

struct Random {
    static func string(length: Int) -> String {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0..<length).map{ _ in letters.randomElement()! })
    }
    
    static func integer(min: Int, max: Int) -> Int {
        guard max > min else { fatalError("Min should be smaller than max") }
        return (min...max).randomElement()!
    }
}
