//
//  ViewModeState.swift
//  RecipeSearch
//
//  Created by Mark Vasiv on 30/05/2019.
//  Copyright © 2019 Mark Vasiv. All rights reserved.
//

import Foundation

enum ViewModeState<T> {
    case empty
    case loading
    case withData(data: T)
    
    var data: T? {
        switch self {
        case .withData(let data):
            return data
        default:
            return nil
        }
    }
}

extension ViewModeState: Equatable {
    static func == (lhs: ViewModeState, rhs: ViewModeState) -> Bool {
        switch (lhs, rhs) {
        case (.empty, .empty):
            return true
        case (.loading, .loading):
            return true
        case (.withData(_), .withData(_)):
            return true
        default:
            return false
        }
    }
}
