//
//  CoordinatorFactoryProtocol.swift
//  RecipeSearch
//
//  Created by Mark Vasiv on 30/05/2019.
//  Copyright © 2019 Mark Vasiv. All rights reserved.
//

import UIKit

protocol CoordinatorFactoryProtocol {
    func makeAppCoordinator(window: UIWindow) -> AppCoordinator
}
