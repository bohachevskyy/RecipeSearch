//
//  RecipeServiceMock.swift
//  RecipeSearchViewModelTests
//
//  Created by Mark Vasiv on 31/05/2019.
//  Copyright © 2019 Mark Vasiv. All rights reserved.
//

import Foundation
@testable import RecipeSearch

class RecipeServiceMock: RecipeService {
    var throwsError: Bool = false
    var returnFullPage: Bool = true
    
    var onDataLoad: ((Result<[RecipeSearchModel], Error>) -> ())?
    
    func findRecipe(keyword: String, page: Int, completion: @escaping (Result<[RecipeSearchModel], Error>) -> ()) {
        guard !throwsError else {
            onDataLoad?(.failure(NetworkError.invalidURL))
            completion(.failure(NetworkError.invalidURL))
            return
        }
        
        var count: Int = 30
        
        if !returnFullPage {
            count = Random.integer(min: 1, max: 29)
        }
        
        let recipes = (0..<count).map({ _ in RecipeSearchModel.random() })
        onDataLoad?(.success(recipes))
        completion(.success(recipes))
    }
    
    func getRecipeDetail(id: String, completion: @escaping (Result<RecipeDetailModel, Error>) -> ()) {
        fatalError("Not implemented")
    }
}

