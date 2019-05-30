//
//  RecipeServiceImpl.swift
//  RecipeSearch
//
//  Created by Mark Vasiv on 30/05/2019.
//  Copyright © 2019 Mark Vasiv. All rights reserved.
//

import Foundation

class RecipeServiceImpl: RecipeService {
    func findRecipe(keyword: String, page: Int, completion: @escaping (Result<[FindRecipeModel], Error>) -> ()) {
        let mappedCompletion: (Result<FindRecipeResponse, Error>) -> () = { (result) in
            let mappedResult = result.map({ $0.recipes })
            completion(mappedResult)
        }
        
        HTTPClient.request(requestConvertible: RecipeAPIRouter.find(keyword: keyword, page: page), completion: mappedCompletion)
    }
    
    func getRecipeDetail(id: String, completion: @escaping (Result<RecipeDetailModel, Error>) -> ()) {
        let mappedCompletion: (Result<GetRecipeDetailResponse, Error>) -> () = { (result) in
            let mappedResult = result.map({ $0.recipe })
            completion(mappedResult)
        }
        
        HTTPClient.request(requestConvertible: RecipeAPIRouter.getDetail(id: id), completion: mappedCompletion)
    }
}
