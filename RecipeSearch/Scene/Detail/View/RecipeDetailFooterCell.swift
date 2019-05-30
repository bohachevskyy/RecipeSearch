//
//  RecipeDetailFooterCell.swift
//  RecipeSearch
//
//  Created by Mark Vasiv on 30/05/2019.
//  Copyright © 2019 Mark Vasiv. All rights reserved.
//

import UIKit

class RecipeDetailFooterCell: UITableViewCell, ReusableCell {
    @IBOutlet var publisherLabel: UILabel!
    @IBOutlet var scoreLabel: UILabel!
    @IBOutlet var showInstructionsButton: UIButton!
    @IBOutlet var showOriginalButton: UIButton!
    
    var onInstructionsTap: CompletionBlock?
    var onOriginalTap: CompletionBlock?
    
    func fillWithModel(_ model: FindRecipeModel) {
        publisherLabel.text = model.publisher
        scoreLabel.text = String(format: "Score rank: %.1f", model.socialRank)
    }
    
    @IBAction func didTapInstructions(_ sender: Any) {
        onInstructionsTap?()
    }
    
    @IBAction func didTapOriginal(_ sender: Any) {
        onOriginalTap?()
    }
}
