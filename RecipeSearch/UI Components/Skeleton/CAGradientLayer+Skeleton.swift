//
//  CAGradientLayer+Skeleton.swift
//  RecipeSearch
//
//  Created by Mark Vasiv on 30/05/2019.
//  Copyright © 2019 Mark Vasiv. All rights reserved.
//

//
// Based on https://github.com/gonzalonunez/Skeleton
//

import UIKit

extension CAGradientLayer {
    fileprivate static let kSlidingAnimationKey = "com.test.skeleton"
    
    func slide(group: ((CAAnimationGroup) -> Void) = { _ in }) {
        let startPointTransition = GradientProperty.startPoint.transition
        let endPointTransition = GradientProperty.endPoint.transition
        
        let startPointAnim = CABasicAnimation(keyPath: #keyPath(startPoint))
        startPointAnim.apply(gradientTransition: startPointTransition)
        
        let endPointAnim = CABasicAnimation(keyPath: #keyPath(endPoint))
        endPointAnim.apply(gradientTransition: endPointTransition)
        
        let animGroup = CAAnimationGroup()
        animGroup.animations = [startPointAnim, endPointAnim]
        animGroup.duration = 1
        animGroup.timingFunction = CAMediaTimingFunction(name: .easeIn)
        animGroup.repeatCount = .infinity
        
        group(animGroup)
        add(animGroup, forKey: CAGradientLayer.kSlidingAnimationKey)
    }
    
    func stopSliding() {
        removeAnimation(forKey: CAGradientLayer.kSlidingAnimationKey)
    }
}

fileprivate extension CABasicAnimation {
    func apply(gradientTransition: GradientTransition) {
        fromValue = NSValue(cgPoint: gradientTransition.from)
        toValue = NSValue(cgPoint: gradientTransition.to)
    }
}
