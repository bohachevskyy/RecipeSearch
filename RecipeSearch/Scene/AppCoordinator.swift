//
//  AppCoordinator.swift
//  RecipeSearch
//
//  Created by Mark Vasiv on 30/05/2019.
//  Copyright © 2019 Mark Vasiv. All rights reserved.
//

import UIKit

final class AppCoordinator: Coordinatable {
    let window: UIWindow
    let modulesFactory: MainModulesFactory & MiscModulesFactory
    
    lazy var navigationController: UINavigationController = UINavigationController()
    lazy var splitController: UISplitViewController = UISplitViewController()
    
    lazy var router: NavigationRoutable = {
        if UIDevice.current.userInterfaceIdiom == .pad {
            return SplitRouter(rootController: splitController)
        } else {
            return NavigationRouter(rootController: navigationController)
        }
    }()
    
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
        
        view.viewModel.onCancel = { [weak self] in
            if UIDevice.current.userInterfaceIdiom == .pad {
                self?.router.cleanStack()
            }
        }
    }
    
    func showDetailView(recipe: RecipeSearchModel) {
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

