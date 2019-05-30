//
//  RecipeService.swift
//  RecipeSearch
//
//  Created by Mark Vasiv on 30/05/2019.
//  Copyright © 2019 Mark Vasiv. All rights reserved.
//

import Foundation

protocol RecipeService {
    func findRecipe(keyword: String, page: Int, completion: @escaping (Result<[FindRecipeModel], Error>) -> ())
    func getRecipeDetail(id: String, completion: @escaping (Result<RecipeDetailModel, Error>) -> ())
}
