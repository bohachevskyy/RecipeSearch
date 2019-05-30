//
//  ReusableCell.swift
//  RecipeSearch
//
//  Created by Mark Vasiv on 30/05/2019.
//  Copyright © 2019 Mark Vasiv. All rights reserved.
//

import UIKit

protocol ReusableCell {
    static var reuseId: String { get }
}

extension ReusableCell where Self: UITableViewCell {
    static var reuseId: String {
        return String(describing: Self.self)
    }
}
