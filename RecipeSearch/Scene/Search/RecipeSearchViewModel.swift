//
//  RecipeSearchViewModel.swift
//  RecipeSearch
//
//  Created by Mark Vasiv on 30/05/2019.
//  Copyright © 2019 Mark Vasiv. All rights reserved.
//

import Foundation

final class RecipeSearchViewModel {
    enum State {
        case empty
        case loading
        case data(recepies: [RecipeSearchModel])
        
        var data: [RecipeSearchModel] {
            switch self {
            case .data(let recepies):
                return recepies
            default:
                return []
            }
        }
    }
    
    var state: State = .empty {
        didSet {
            onStateChange?(state)
        }
    }
    var currentPage: Int = 1
    var currentText: String? = nil
    var isLoading: Bool = false
    var gotAllPages: Bool = false
    
    let searchService: RecipeService
    
    var onSelection: ((RecipeSearchModel) -> ())?
    var onError: ((String) -> ())?
    var onStateChange: ((State) -> ())?
    
    init(searchService: RecipeService) {
        self.searchService = searchService
    }
}

// MARK: - User Actions
extension RecipeSearchViewModel {
    func didSearch(with text: String?) {
        guard let text = text, !text.isEmpty else {
            state = .empty
            isLoading = false
            currentPage = 1
            return
        }
        
        state = .loading
        isLoading = true
        currentPage = 1
        gotAllPages = false
        currentText = text
        
        searchService.findRecipe(keyword: text, page: 1) { [weak self] (result) in
            switch result {
            case .failure(let error):
                self?.state = .empty
                self?.onError?(error.localizedDescription)
            case .success(let recipes):
                self?.state = .data(recepies: recipes)
                if recipes.count < 30 {
                    self?.gotAllPages = true
                }
            }
            
            self?.isLoading = false
        }
    }
    
    func didScrollToBottom() {
        guard let text = currentText, !text.isEmpty else { return }
        guard isLoading == false else { return }
        guard gotAllPages == false else { return }
        
        isLoading = true
        
        searchService.findRecipe(keyword: text, page: currentPage + 1) { [weak self] (result) in
            switch result {
            case .failure(let error):
                self?.onError?(error.localizedDescription)
            case .success(let recipes):
                self?.state = .data(recepies: (self?.state.data ?? []) + recipes)
                self?.currentPage += 1
                if recipes.count < 30 {
                    self?.gotAllPages = true
                }
            }
            
            self?.isLoading = false
        }
    }
    
    func didSelectRow(at indexPath: IndexPath) {
        guard state.data.count > indexPath.row else { return }
        let model = state.data[indexPath.row]
        onSelection?(model)
    }
}
