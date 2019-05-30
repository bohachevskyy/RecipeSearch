//
//  RecipeDetailViewController.swift
//  RecipeSearch
//
//  Created by Mark Vasiv on 30/05/2019.
//  Copyright © 2019 Mark Vasiv. All rights reserved.
//

import UIKit

final class RecipeDetailViewController: UIViewController, StoryboardLoadable {
    typealias ViewModelType = RecipeDetailViewModel
    
    var viewModel: RecipeDetailViewModel!
    
    @IBOutlet var headerImageView: LoadingImageView!
    @IBOutlet var headerTop: NSLayoutConstraint!
    @IBOutlet var headerHeight: NSLayoutConstraint!
    @IBOutlet var tableView: UITableView!
    
    let kHeaderHeight: CGFloat = 250
    let kSectionHeaderHeight: CGFloat = 24
    let kIngredientCellHeight: CGFloat = 40
    let kFooterCellHeight: CGFloat = 150
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        bindViewModel()
    }
}

// MARK: - Setup
extension RecipeDetailViewController {
    func setupTableView() {
        tableView.backgroundColor = nil
        tableView.contentInset = UIEdgeInsets(top: kHeaderHeight, left: 0, bottom: 0, right: 0)
        tableView.tableFooterView = UIView()
    }
    
    func bindViewModel() {
        let model = viewModel.searchModel
        title = model.title
        headerImageView.setImageWithURL(model.imageURL)
        
        viewModel.onError = { [weak self] (error) in
            self?.showError(error)
        }
        
        viewModel.onIngredientsUpdate = { [weak self] in
            self?.tableView.reloadSections(IndexSet(integer: 0), with: .automatic)
        }
    }
}

// MARK: - UITableViewDataSource
extension RecipeDetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            return RecipeDetailSectionHeader(title: "Ingredients")
        } else {
            return RecipeDetailSectionHeader(title: "Info")
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            if viewModel.shouldShowSkeletonIngredients {
                return RecipeDetailIngredientSkeletonCell.defaultCellCount
            } else {
                return viewModel.ingredients.count
            }
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            if viewModel.shouldShowSkeletonIngredients {
                return tableView.dequeueReusableCell(withIdentifier: RecipeDetailIngredientSkeletonCell.reuseId, for: indexPath)
            } else {
                return tableView.dequeueReusableCell(withIdentifier: RecipeDetailIngredientCell.reuseId, for: indexPath)
            }
        } else {
            return tableView.dequeueReusableCell(withIdentifier: RecipeDetailFooterCell.reuseId, for: indexPath)
        }
    }
}

// MARK: - UITableViewDelegate
extension RecipeDetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return kSectionHeaderHeight
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return kIngredientCellHeight
        } else {
            return kFooterCellHeight
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let footerCell = cell as? RecipeDetailFooterCell {
            willDisplayFooterCell(footerCell, forRowAt: indexPath)
        } else if let skeletonIngredientCell = cell as? RecipeDetailIngredientSkeletonCell {
            willDisplayIngredientSkeletonCell(skeletonIngredientCell, forRowAt: indexPath)
        } else if let ingredientCell = cell as? RecipeDetailIngredientCell {
            willDisplayIngredientCell(ingredientCell, forRowAt: indexPath)
        }
    }
    
    func willDisplayFooterCell(_ cell: RecipeDetailFooterCell, forRowAt indexPath: IndexPath) {
        cell.fillWithModel(viewModel.searchModel)
        
        cell.onOriginalTap = { [weak self] in
            self?.viewModel.didTapOriginal()
        }
        
        cell.onInstructionsTap = { [weak self] in
            self?.viewModel.didTapInstructions()
        }
    }
    
    func willDisplayIngredientCell(_ cell: RecipeDetailIngredientCell, forRowAt indexPath: IndexPath) {
        guard viewModel.ingredients.count > indexPath.row else { return }
        cell.fillWithIngredientName(viewModel.ingredients[indexPath.row])
    }
    
    func willDisplayIngredientSkeletonCell(_ cell: RecipeDetailIngredientSkeletonCell, forRowAt indexPath: IndexPath) {
        cell.startSliding()
    }
}

// MARK: - UIScrollViewDelegate
extension RecipeDetailViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset = scrollView.contentOffset.y
        let inset = -tableView.adjustedContentInset.top
        
        if offset > inset {
            headerTop.constant = inset - offset
        } else {
            headerTop.constant = 0
            headerHeight.constant = 250 + (inset - offset)
        }
        
        headerImageView.layoutIfNeeded()
    }
}
