//
//  StoryboardLoadable.swift
//  RecipeSearch
//
//  Created by Mark Vasiv on 30/05/2019.
//  Copyright © 2019 Mark Vasiv. All rights reserved.
//

import UIKit

protocol StoryboardLoadable {
    associatedtype ViewModelType
    var viewModel: ViewModelType! { get set }
    static var identifier: String { get }
    static var storyboardName: String { get }
    static func loadFromStoryboard(with viewModel: ViewModelType) -> Self
}

extension StoryboardLoadable where Self: UIViewController {
    static var identifier: String {
        return String(describing: Self.self)
    }
    
    static var storyboardName: String {
        return "Main"
    }
    
    private static func loadFromStoryboard() -> Self {
        let bundle = Bundle(for: Self.self)
        let storyboard = UIStoryboard(name: storyboardName, bundle: bundle)
        return storyboard.instantiateViewController(withIdentifier: identifier) as! Self
    }
    
    static func loadFromStoryboard(with viewModel: ViewModelType) -> Self {
        var viewController = loadFromStoryboard()
        viewController.viewModel = viewModel
        return viewController
    }
}
