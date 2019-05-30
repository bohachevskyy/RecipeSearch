//
//  RecipeDetailViewModel.swift
//  RecipeSearch
//
//  Created by Mark Vasiv on 30/05/2019.
//  Copyright © 2019 Mark Vasiv. All rights reserved.
//

import Foundation

final class RecipeDetailViewModel {
    typealias State = ViewModeState<[String]>
    
    // MARK: View properties
    var state: State = .empty {
        didSet { onStateUpdate?(state) }
    }
    
    var title: String {
        return searchModel.title.stringByDecodingHTML()
    }
    
    var imageURL: String {
        return searchModel.imageURL
    }
    
    var footerModel: RecipeDetailFooterCellModel {
        return RecipeDetailFooterCellModel(searchModel: searchModel)
    }

    // MARK: Internal properties
    private var isLoading: Bool = false
    
    // MARK: Callbacks
    var onStateUpdate: ((State) -> ())?
    var onError: ((String) -> ())?
    var onOpenExternalResource: ((String) -> ())?
    
    // MARK: Lifecycle
    let searchModel: RecipeSearchModel
    let service: RecipeService
    
    init(searchModel: RecipeSearchModel, service: RecipeService) {
        self.searchModel = searchModel
        self.service = service
        loadFullModel()
    }
}

// MARK: - User actions
extension RecipeDetailViewModel {
    func didTapInstructions() {
        onOpenExternalResource?(searchModel.f2fURL)
    }
    
    func didTapOriginal() {
        onOpenExternalResource?(searchModel.sourceURL)
    }
}

// MARK: - Data fetch
private extension RecipeDetailViewModel {
    func loadFullModel() {
        state = .loading
        
        service.getRecipeDetail(id: searchModel.recipeId) { [weak self] (result) in
            switch result {
            case .failure(let error):
                self?.state = .empty
                self?.onError?(error.localizedDescription)
            case .success(let recipe):
                self?.state = .withData(data: recipe.ingredients)
            }
        }
    }
}
