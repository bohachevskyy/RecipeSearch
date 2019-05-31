//
//  EmptyView.swift
//  RecipeSearch
//
//  Created by Mark Vasiv on 30/05/2019.
//  Copyright © 2019 Mark Vasiv. All rights reserved.
//

import UIKit

final class EmptyView: UIView {
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    
    static func loadFromXib() -> EmptyView? {
        return Bundle.main.loadNibNamed("EmptyView", owner: nil, options: nil)?.first as? EmptyView
    }
    
    func setImage(image: UIImage?, title: String?, description: String?) {
        imageView.image = image
        titleLabel.text = title
        descriptionLabel.text = description
    }
    
    func setFirstLoadAppearance() {
        setImage(image: UIImage(named: "searchIcon"), title: "Start searching", description: "Enter your favourite dish or ingredient")
    }
    
    func setNoDataAppearance() {
        setImage(image: UIImage(named: "emptySearchIcon"), title: "Nothing found", description: "Try entering something else, we don't know about this recipe yet")
    }
}
