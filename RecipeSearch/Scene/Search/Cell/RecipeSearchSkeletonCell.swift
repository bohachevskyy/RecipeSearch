//
//  RecipeSearchSkeletonCell.swift
//  RecipeSearch
//
//  Created by Mark Vasiv on 30/05/2019.
//  Copyright © 2019 Mark Vasiv. All rights reserved.
//

import UIKit

class RecipeSearchSkeletonCell: UITableViewCell, ReusableCell {
    static let defaultCellCount: Int = 15
    
    @IBOutlet var imageGradientView: GradientView!
    @IBOutlet var labelGradientView: GradientView!
    @IBOutlet var labelWidthConstraint: NSLayoutConstraint!
}

// MARK: - Lifecycle
extension RecipeSearchSkeletonCell {
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
extension RecipeSearchSkeletonCell {
    func setupGradientViews() {
        imageGradientView.layer.cornerRadius = 5
        imageGradientView.clipsToBounds = true
        imageGradientView.setDefaultSkeletonColors()
        
        labelWidthConstraint.constant = CGFloat((120...240).randomElement() ?? 120)
        labelGradientView.setDefaultSkeletonColors()
    }
}

// MARK: - Sliding
extension RecipeSearchSkeletonCell {
    func startSliding() {
        [imageGradientView, labelGradientView].forEach({ $0?.slide() })
    }
    
    func stopSliding() {
        [imageGradientView, labelGradientView].forEach({ $0?.stopSliding() })
    }
}

