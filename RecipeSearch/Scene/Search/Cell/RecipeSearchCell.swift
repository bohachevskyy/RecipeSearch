//
//  RecipeSearchCell.swift
//  RecipeSearch
//
//  Created by Mark Vasiv on 30/05/2019.
//  Copyright © 2019 Mark Vasiv. All rights reserved.
//

import UIKit

class RecipeSearchCell: UITableViewCell, ReusableCell {
    @IBOutlet var iconImageView: LoadingImageView!
    @IBOutlet var recipeTitleLabel: UILabel!
}

// MARK: - Lifecycle
extension RecipeSearchCell {
    override func awakeFromNib() {
        super.awakeFromNib()
        setupAppearance()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        resetValues()
    }
}

// MARK: - Setup
extension RecipeSearchCell {
    func setupAppearance() {
        iconImageView.contentMode = .scaleAspectFill
        iconImageView.layer.cornerRadius = 5
        iconImageView.clipsToBounds = true
    }
    
    func fillWithModel(_ model: FindRecipeModel) {
        iconImageView.setImageWithURL(model.imageURL)
        recipeTitleLabel.text = model.title
    }
    
    func resetValues() {
        iconImageView?.image = nil
        recipeTitleLabel.text = nil
    }
}
