//
//  RecipeDetailSectionHeader.swift
//  RecipeSearch
//
//  Created by Mark Vasiv on 30/05/2019.
//  Copyright © 2019 Mark Vasiv. All rights reserved.
//

import UIKit

class RecipeDetailSectionHeader: UIView {
    lazy var label: UILabel = UILabel()
    
    init(title: String? = nil) {
        super.init(frame: .zero)
        generalInit()
        setTitle(title)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        generalInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        generalInit()
    }
}

extension RecipeDetailSectionHeader {
    func generalInit() {
        backgroundColor = UIColor(red: 0.92, green: 0.92, blue: 0.92, alpha: 1)
        addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.leftAnchor.constraint(equalTo: leftAnchor, constant: 12).isActive = true
        label.rightAnchor.constraint(equalTo: rightAnchor, constant: -12).isActive = true
        label.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = UIColor.black
    }
    
    func setTitle(_ title: String?) {
        label.text = title?.uppercased()
    }
}
