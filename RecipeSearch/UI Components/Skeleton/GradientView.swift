//
//  GradientView.swift
//  RecipeSearch
//
//  Created by Mark Vasiv on 30/05/2019.
//  Copyright © 2019 Mark Vasiv. All rights reserved.
//

import UIKit

final class GradientView: UIView {
    override open class var layerClass: AnyClass {
        return CAGradientLayer.self
    }
}

extension GradientView {
    var gradientLayer: CAGradientLayer {
        return layer as! CAGradientLayer
    }
    
    func slide(group: ((CAAnimationGroup) -> Void) = { _ in }) {
        return gradientLayer.slide(group: group)
    }
    
    func stopSliding() {
        return gradientLayer.stopSliding()
    }
    
    func setDefaultSkeletonColors() {
        let baseColor = UIColor(red: 0.82, green: 0.82, blue: 0.82, alpha: 1)
        let darkColor = UIColor(red: 0.73, green: 0.72, blue: 0.72, alpha: 1)
        
        gradientLayer.colors = [baseColor, darkColor, baseColor].map({ $0.cgColor })
    }
}
