//
//  ModulesFactory.swift
//  RecipeSearch
//
//  Created by Mark Vasiv on 30/05/2019.
//  Copyright © 2019 Mark Vasiv. All rights reserved.
//

import Foundation
import SafariServices

final class ModulesFactory { }

// MARK: - MainModulesFactory
extension ModulesFactory: MainModulesFactory {
    func makeRecipeSearchView() -> RecipeSearchViewController {
        let viewModel = RecipeSearchViewModel(searchService: RecipeServiceImpl())
        return RecipeSearchViewController.loadFromStoryboard(with: viewModel)
    }
    
    func makeRecipeDetailView(recipe: RecipeSearchModel) -> RecipeDetailViewController {
        let viewModel = RecipeDetailViewModel(searchModel: recipe, service: RecipeServiceImpl())
        return RecipeDetailViewController.loadFromStoryboard(with: viewModel)
    }
}

// MARK: - MiscModulesFactory
extension ModulesFactory: MiscModulesFactory {
    func makeSafariView(url: URL) -> SFSafariViewController {
        return SFSafariViewController(url: url)
    }
}
