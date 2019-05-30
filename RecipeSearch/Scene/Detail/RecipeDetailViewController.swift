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
}

// MARK: - View lifecycle
extension RecipeDetailViewController {
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
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 40
    }
    
    func bindViewModel() {
        title = viewModel.title
        headerImageView.setImageWithURL(viewModel.imageURL)
        
        viewModel.onError = { [weak self] (error) in
            self?.showError(error)
        }
        
        viewModel.onStateUpdate = { [weak self] (state) in
            self?.handleStateUpdate(state: state)
        }
    }
}

// MARK: - Update
extension RecipeDetailViewController {
    func handleStateUpdate(state: ViewModelType.State) {
        tableView.reloadSections(IndexSet(integer: 0), with: .automatic)
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
            if viewModel.state == .loading {
                return RecipeDetailIngredientSkeletonCell.defaultCellCount
            } else {
                return viewModel.state.data?.count ?? 0
            }
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell
        
        if indexPath.section == 0 {
            if viewModel.state == .loading {
                cell = tableView.dequeueReusableCell(withIdentifier: RecipeDetailIngredientSkeletonCell.reuseId, for: indexPath)
            } else {
                cell =  tableView.dequeueReusableCell(withIdentifier: RecipeDetailIngredientCell.reuseId, for: indexPath)
            }
        } else {
            cell = tableView.dequeueReusableCell(withIdentifier: RecipeDetailFooterCell.reuseId, for: indexPath)
        }
        
        if let cell = cell as? RecipeDetailFooterCell {
            prepareFooterCell(cell, forRowAt: indexPath)
        } else if let cell = cell as? RecipeDetailIngredientSkeletonCell {
            prepareIngredientSkeletonCell(cell, forRowAt: indexPath)
        } else if let cell = cell as? RecipeDetailIngredientCell {
            prepareIngredientCell(cell, forRowAt: indexPath)
        }
        
        return cell
    }
}

// MARK: - Prepare cells
extension RecipeDetailViewController {
    func prepareFooterCell(_ cell: RecipeDetailFooterCell, forRowAt indexPath: IndexPath) {
        cell.fillWithModel(viewModel.searchModel)
        
        cell.onOriginalTap = { [weak self] in
            self?.viewModel.didTapOriginal()
        }
        
        cell.onInstructionsTap = { [weak self] in
            self?.viewModel.didTapInstructions()
        }
    }
    
    func prepareIngredientCell(_ cell: RecipeDetailIngredientCell, forRowAt indexPath: IndexPath) {
        guard viewModel.state.data?.count ?? 0 > indexPath.row else { return }
        guard let model = viewModel.state.data?[indexPath.row] else { return }
        cell.fillWithIngredientName(model)
    }
    
    func prepareIngredientSkeletonCell(_ cell: RecipeDetailIngredientSkeletonCell, forRowAt indexPath: IndexPath) {
        cell.startSliding()
    }
}

// MARK: - UITableViewDelegate
extension RecipeDetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return kSectionHeaderHeight
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
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
            headerHeight.constant = kHeaderHeight + (inset - offset)
        }
        
        headerImageView.layoutIfNeeded()
    }
}
