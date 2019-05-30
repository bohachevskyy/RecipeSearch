//
//  RecipeSearchViewModel.swift
//  RecipeSearch
//
//  Created by Mark Vasiv on 30/05/2019.
//  Copyright © 2019 Mark Vasiv. All rights reserved.
//

import Foundation

final class RecipeSearchViewModel {
    typealias State = ViewModeState<[RecipeSearchModel]>
    
    var state: State = .empty {
        didSet { onStateChange?(state) }
    }
    
    // MARK: Internal properties
    private var currentPage: Int = 0
    private var currentText: String? = nil
    private var isLoading: Bool = false
    private var gotAllPages: Bool = false
    
    // MARK: Callbacks
    var onSelection: ((RecipeSearchModel) -> ())?
    var onError: ((String) -> ())?
    var onStateChange: ((State) -> ())?
    var onCancel: CompletionBlock?
    
    // MARK: Lifecycle
    let searchService: RecipeService
    
    init(searchService: RecipeService) {
        self.searchService = searchService
    }
}

// MARK: - User Actions
extension RecipeSearchViewModel {
    func didSearch(with text: String?) {
        currentText = text
        
        guard let text = text, !text.isEmpty else {
            state = .empty
            isLoading = false
            currentPage = 0
            return
        }
        
        search(nextPage: false, text: text)
    }
    
    func didScrollToBottom() {
        guard let text = currentText, !text.isEmpty else { return }
        guard gotAllPages == false else { return }
        search(nextPage: true, text: text)
    }
    
    func didTapCancel() {
        didSearch(with: nil)
        onCancel?()
    }
    
    func didSelectRow(at indexPath: IndexPath) {
        guard state.data?.count ?? 0 > indexPath.row else { return }
        guard let model = state.data?[indexPath.row] else { return }
        onSelection?(model)
    }
}

// MARK: - Search
private extension RecipeSearchViewModel {
    func search(nextPage: Bool, text: String) {
        guard isLoading == false else { return }
        
        isLoading = true
        
        if state == .empty {
            state = .loading
        }
        
        if !nextPage {
            currentPage = 0
            gotAllPages = false
        }
        
        searchService.findRecipe(keyword: text, page: currentPage + 1) { [weak self] (result) in
            switch result {
            case .failure(let error):
                if !nextPage {
                    self?.state = .empty
                }
                self?.onError?(error.localizedDescription)
            case .success(let recipes):
                guard let text = self?.currentText, !text.isEmpty else {
                    self?.state = .empty
                    break
                }
                
                if nextPage {
                    let currentData = self?.state.data ?? []
                    self?.state = .withData(data: currentData + recipes)
                } else {
                    self?.state = .withData(data: recipes)
                }
                
                self?.currentPage += 1
                
                if recipes.count < 30 {
                    self?.gotAllPages = true
                }
            }
            
            self?.isLoading = false
        }
    }
}
