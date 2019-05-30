//
//  RecipeDetailViewModel.swift
//  RecipeSearch
//
//  Created by Mark Vasiv on 30/05/2019.
//  Copyright © 2019 Mark Vasiv. All rights reserved.
//

import Foundation

final class RecipeDetailViewModel {
    var isLoading: Bool = false
    let searchModel: FindRecipeModel
    let service: RecipeService
    var ingredients: [String] = []
    var shouldShowSkeletonIngredients: Bool {
        return isLoading == true && ingredients.isEmpty
    }
    var onError: ((String) -> ())?
    var onIngredientsUpdate: CompletionBlock?
    var onOpenExternalResource: ((String) -> ())?
    
    init(searchModel: FindRecipeModel, service: RecipeService) {
        self.searchModel = searchModel
        self.service = service
        loadFullModel()
    }
}

extension RecipeDetailViewModel {
    func didTapInstructions() {
        onOpenExternalResource?(searchModel.f2fURL)
    }
    
    func didTapOriginal() {
        onOpenExternalResource?(searchModel.sourceURL)
    }
    
    func loadFullModel() {
        isLoading = true
        
        service.getRecipeDetail(id: searchModel.recipeId) { [weak self] (result) in
            switch result {
            case .failure(let error):
                self?.onError?(error.localizedDescription)
            case .success(let recipe):
                self?.ingredients = recipe.ingredients
                self?.onIngredientsUpdate?()
            }
            
            self?.isLoading = false
        }
    }
}
