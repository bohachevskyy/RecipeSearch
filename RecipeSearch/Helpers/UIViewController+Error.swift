//
//  UIViewController+Error.swift
//  RecipeSearch
//
//  Created by Mark Vasiv on 30/05/2019.
//  Copyright © 2019 Mark Vasiv. All rights reserved.
//

import UIKit

extension UIViewController {
    func showError(_ message: String) {
        let alertController = UIAlertController(title: nil,
                                                message: message,
                                                preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: "Dismiss",
                                                style: .default,
                                                handler: nil))
        
        present(alertController, animated: true, completion: nil)
    }
}
