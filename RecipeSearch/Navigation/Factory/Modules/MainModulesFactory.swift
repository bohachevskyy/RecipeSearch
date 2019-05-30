//
//  MainModulesFactory.swift
//  RecipeSearch
//
//  Created by Mark Vasiv on 30/05/2019.
//  Copyright © 2019 Mark Vasiv. All rights reserved.
//

import Foundation
import SafariServices

protocol MainModulesFactory {
    func makeRecipeSearchView() -> RecipeSearchViewController
    func makeRecipeDetailView(recipe: RecipeSearchModel) -> RecipeDetailViewController
    func makeSafariView(url: URL) -> SFSafariViewController
}
