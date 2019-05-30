//
//  FindRecipeResponse.swift
//  RecipeSearch
//
//  Created by Mark Vasiv on 30/05/2019.
//  Copyright © 2019 Mark Vasiv. All rights reserved.
//

import Foundation

struct FindRecipeResponse: Codable {
    let count: Int
    let recipes: [RecipeSearchModel]
}
