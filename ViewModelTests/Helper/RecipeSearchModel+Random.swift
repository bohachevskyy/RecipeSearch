//
//  RecipeSearchModel+Random.swift
//  RecipeSearch
//
//  Created by Mark Vasiv on 31/05/2019.
//  Copyright © 2019 Mark Vasiv. All rights reserved.
//

import Foundation
@testable import RecipeSearch

extension RecipeSearchModel {
    static func random() -> RecipeSearchModel {
        return RecipeSearchModel(imageURL: "http://placehold.it/120x120&text=image1",
                                 sourceURL: "",
                                 f2fURL: "",
                                 title: Random.string(length: 10),
                                 publisher: Random.string(length: 10),
                                 publisherURL: "",
                                 socialRank: Float(Random.integer(min: 1, max: 100)),
                                 recipeId: Random.string(length: 4))
    }
}
