//
//  RecipeDetailIngredientCell.swift
//  RecipeSearch
//
//  Created by Mark Vasiv on 30/05/2019.
//  Copyright © 2019 Mark Vasiv. All rights reserved.
//

import UIKit

final class RecipeDetailIngredientCell: UITableViewCell, ReusableCell {
    @IBOutlet var ingredientNameLabel: UILabel!
    
    func fillWithIngredientName(_ name: String) {
        // This may be too expensive to do in a table view cell
        // But unfortunately API returns HTML symbols inside of JSON
        ingredientNameLabel.text = name.stringByDecodingHTML() ?? name
    }
}
