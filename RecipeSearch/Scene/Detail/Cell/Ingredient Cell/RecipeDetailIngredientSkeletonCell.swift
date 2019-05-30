//
//  RecipeDetailIngredientSkeletonCell.swift
//  RecipeSearch
//
//  Created by Mark Vasiv on 30/05/2019.
//  Copyright © 2019 Mark Vasiv. All rights reserved.
//

import UIKit

class RecipeDetailIngredientSkeletonCell: UITableViewCell, ReusableCell {
    static let defaultCellCount: Int = 5
    
    @IBOutlet var labelGradientView: GradientView!
    @IBOutlet var labelWidthConstraint: NSLayoutConstraint!
}

// MARK: - Lifecycle
extension RecipeDetailIngredientSkeletonCell {
    override func awakeFromNib() {
        super.awakeFromNib()
        setupGradientViews()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        stopSliding()
    }
}

// MARK: - Setup
extension RecipeDetailIngredientSkeletonCell {
    func setupGradientViews() {
        labelWidthConstraint.constant = CGFloat((120...240).randomElement() ?? 120)
        labelGradientView.setDefaultSkeletonColors()
    }
}

// MARK: - Sliding
extension RecipeDetailIngredientSkeletonCell {
    func startSliding() {
        labelGradientView.slide()
    }
    
    func stopSliding() {
        labelGradientView.stopSliding()
    }
}
