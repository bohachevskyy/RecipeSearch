//
//  GradientTransition.swift
//  RecipeSearch
//
//  Created by Mark Vasiv on 30/05/2019.
//  Copyright © 2019 Mark Vasiv. All rights reserved.
//

import UIKit

typealias GradientTransition = (from: CGPoint, to: CGPoint)

enum GradientProperty {
    case startPoint
    case endPoint
    
    var transition: GradientTransition {
        switch self {
        case .startPoint:
            return GradientTransition(from: CGPoint(x: -1, y: 0.5), to: CGPoint(x: 1, y: 0.5))
        case .endPoint:
            return GradientTransition(from: CGPoint(x: 0, y: 0.5), to: CGPoint(x: 2, y: 0.5))
        }
    }
}
