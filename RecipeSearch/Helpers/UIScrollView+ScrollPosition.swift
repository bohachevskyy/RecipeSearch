//
//  UIScrollView+ScrollPosition.swift
//  RecipeSearch
//
//  Created by Mark Vasiv on 30/05/2019.
//  Copyright © 2019 Mark Vasiv. All rights reserved.
//

import UIKit

extension UIScrollView {
    func hasScrolledToBottom(padding: CGFloat = 0) -> Bool {
        let effectiveFrameHeight = frame.size.height - adjustedContentInset.top - adjustedContentInset.bottom
        let yOffset = contentOffset.y + adjustedContentInset.top
        let disatnceFromBottom = contentSize.height - yOffset
        
        return disatnceFromBottom - effectiveFrameHeight < padding
    }
}
