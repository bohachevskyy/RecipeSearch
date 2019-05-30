//
//  LoadingImageView.swift
//  RecipeSearch
//
//  Created by Mark Vasiv on 30/05/2019.
//  Copyright © 2019 Mark Vasiv. All rights reserved.
//

import UIKit

class LoadingImageView: UIImageView {
    lazy var skeletonView: GradientView = GradientView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        generalInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        generalInit()
    }
    
    func generalInit() {
        setupSkeletonView()
    }
}

// MARK: Setup
extension LoadingImageView {
    func setupSkeletonView() {
        addSubview(skeletonView)
        skeletonView.translatesAutoresizingMaskIntoConstraints = false
        skeletonView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        skeletonView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        skeletonView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        skeletonView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        skeletonView.setDefaultSkeletonColors()
        bringSubviewToFront(skeletonView)
    }
}

extension LoadingImageView {
    func setImageWithURL(_ url: String, completion: ((UIImage?) -> ())? = nil) {
        image = nil
        skeletonView.isHidden = false
        skeletonView.slide()
        
        ImageDownloadManager.downloadImage(url: url) { [weak self] (result) in
            switch result {
            case .success(let image):
                self?.image = image
                self?.skeletonView.stopSliding()
                self?.skeletonView.isHidden = true
                completion?(image)
            case .failure(_):
                completion?(nil)
                break
            }
        }
    }
}
