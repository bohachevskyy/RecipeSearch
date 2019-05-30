//
//  RecipeSearchCellModel.swift
//  RecipeSearch
//
//  Created by Mark Vasiv on 30/05/2019.
//  Copyright © 2019 Mark Vasiv. All rights reserved.
//

import Foundation

struct RecipeSearchCellModel {
    let title: String
    let imageURL: String
    
    init(searchModel: RecipeSearchModel) {
        self.title = searchModel.title.stringByDecodingHTML()
        self.imageURL = searchModel.imageURL
    }
}
