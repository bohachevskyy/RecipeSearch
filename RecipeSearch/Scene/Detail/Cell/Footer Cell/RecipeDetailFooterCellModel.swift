//
//  RecipeDetailFooterCellModel.swift
//  RecipeSearch
//
//  Created by Mark Vasiv on 30/05/2019.
//  Copyright © 2019 Mark Vasiv. All rights reserved.
//

import Foundation

struct RecipeDetailFooterCellModel {
    let publisherName: String
    let score: String
    
    init(searchModel: RecipeSearchModel) {
        publisherName = searchModel.publisher
        score = String(format: "Score: %.1f", searchModel.socialRank)
    }
}
