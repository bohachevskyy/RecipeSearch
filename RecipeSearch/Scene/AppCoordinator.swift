//
//  AppCoordinator.swift
//  RecipeSearch
//
//  Created by Mark Vasiv on 30/05/2019.
//  Copyright © 2019 Mark Vasiv. All rights reserved.
//

import UIKit

class AppCoordinator: Coordinatable {
    let window: UIWindow
    let modulesFactory: MainModulesFactory & MiscModulesFactory
    
    lazy var navigationController: UINavigationController = UINavigationController()
    lazy var router: NavigationRoutable = NavigationRouter(rootController: navigationController)
    
    init(window: UIWindow, modulesFactory: MainModulesFactory & MiscModulesFactory) {
        self.window = window
        self.modulesFactory = modulesFactory
    }
    
    func start() {
        window.rootViewController = router.toPresent
        window.makeKeyAndVisible()
        showSearchView()
    }
}

// MARK: - Show Views
extension AppCoordinator {
    func showSearchView() {
        let view = modulesFactory.makeRecipeSearchView()
        router.setRootModule(view)
        
        view.viewModel.onSelection = { [weak self] (recipe) in
            self?.showDetailView(recipe: recipe)
        }
    }
    
    func showDetailView(recipe: FindRecipeModel) {
        let view = modulesFactory.makeRecipeDetailView(recipe: recipe)
        router.push(view)
        
        view.viewModel.onOpenExternalResource = { [weak self] (urlString) in
            guard let url = URL(string: urlString) else { return }
            self?.presentSafariView(url: url)
        }
    }
}

extension AppCoordinator {
    func presentSafariView(url: URL) {
        let view = modulesFactory.makeSafariView(url: url)
        view.modalPresentationStyle = .overFullScreen
        router.present(view)
    }
}

