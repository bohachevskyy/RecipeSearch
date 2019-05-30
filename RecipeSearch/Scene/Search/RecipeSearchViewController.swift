//
//  RecipeSearchViewController.swift
//  RecipeSearch
//
//  Created by Mark Vasiv on 30/05/2019.
//  Copyright © 2019 Mark Vasiv. All rights reserved.
//

import UIKit

final class RecipeSearchViewController: UIViewController, StoryboardLoadable {
    typealias ViewModelType = RecipeSearchViewModel
    
    var viewModel: RecipeSearchViewModel!
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var tableViewBottom: NSLayoutConstraint!
    lazy var searchController: UISearchController = UISearchController(searchResultsController: nil)
    lazy var emptyView: EmptyView = EmptyView.loadFromXib()!
    
    deinit {
        deRegisterKeyboardNotifications()
    }
}

// MARK: - View lifecycle
extension RecipeSearchViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSearchController()
        setupAppearance()
        setupEmptyView()
        bindViewModel()
        handleStateUpdate(state: viewModel.state)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.hidesSearchBarWhenScrolling = false
        registerKeyboardNotifications()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationItem.hidesSearchBarWhenScrolling = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        deRegisterKeyboardNotifications()
    }
}

// MARK: - Setup
extension RecipeSearchViewController {
    func setupSearchController() {
        searchController.dimsBackgroundDuringPresentation = false
        //navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.searchController = searchController
        searchController.searchBar.delegate = self
    }
    
    func setupAppearance() {
        definesPresentationContext = true
        //extendedLayoutIncludesOpaqueBars = true
        tableView.tableFooterView = UIView()
    }
    
    func setupEmptyView() {
        emptyView.setFirstLoadAppearance()
        
        view.addSubview(emptyView)
        emptyView.translatesAutoresizingMaskIntoConstraints = false
        emptyView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        emptyView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        emptyView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        emptyView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
    }
    
    func bindViewModel() {
        viewModel.onStateChange = { [weak self] (state) in
            self?.handleStateUpdate(state: state)
        }
        
        viewModel.onError = { [weak self] (error) in
            self?.showError(error)
        }
    }
}

// MARK: - Update
extension RecipeSearchViewController {
    func handleStateUpdate(state: ViewModelType.State) {
        switch state {
        case .empty:
            emptyView.setFirstLoadAppearance()
            emptyView.isHidden = false
            tableView.isHidden = true
        case .loading:
            emptyView.isHidden = true
            tableView.isHidden = false
        case .data(let recepies):
            emptyView.setNoDataAppearance()
            emptyView.isHidden = !recepies.isEmpty
            tableView.isHidden = recepies.isEmpty
        }
        
        tableView.reloadData()
    }
}

// MARK: - UISearchBarDelegate
extension RecipeSearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        viewModel.didSearch(with: searchBar.text)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        viewModel.didSearch(with: nil)
    }
}

// MARK: - UITableViewDataSource
extension RecipeSearchViewController: UITableViewDataSource  {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch viewModel.state {
        case .data(let recepies):
            return recepies.count
        case .empty:
            return 0
        case .loading:
            return RecipeSearchSkeletonCell.defaultCellCount
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch viewModel.state {
        case .data(_):
            return tableView.dequeueReusableCell(withIdentifier: RecipeSearchCell.reuseId, for: indexPath)
        default:
            return tableView.dequeueReusableCell(withIdentifier: RecipeSearchSkeletonCell.reuseId, for: indexPath)
        }
    }
}

// MARK: - UITableViewDataDelegate
extension RecipeSearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let recipeCell = cell as? RecipeSearchCell{
            willDisplayNormalCell(recipeCell, forRowAt: indexPath)
        } else if let skeletonCell = cell as? RecipeSearchSkeletonCell {
            willDisplaySkeletonCell(skeletonCell, forRowAt: indexPath)
        }
    }
    
    func willDisplaySkeletonCell(_ cell: RecipeSearchSkeletonCell, forRowAt indexPath: IndexPath) {
        cell.startSliding()
    }
    
    func willDisplayNormalCell(_ cell: RecipeSearchCell, forRowAt indexPath: IndexPath) {
        guard viewModel.state.data.count > indexPath.row else { return }
        let model = viewModel.state.data[indexPath.row]
        cell.fillWithModel(model)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.didSelectRow(at: indexPath)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: - UIScrollViewDelegate
extension RecipeSearchViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.hasScrolledToBottom(padding: 150) {
            viewModel.didScrollToBottom()
        }
    }
}

// MARK: - KeyboardAppearanceProtocol
extension RecipeSearchViewController: KeyboardAppearanceProtocol {
    func keyboardWillChangeHeight(height: CGFloat, duration: TimeInterval, show: Bool) {
        adaptToKeyboard(height: height, show: show, duration: duration)
    }
    
    func keyboardDidChangeHeight(height: CGFloat, show: Bool) {
        adaptToKeyboard(height: height, show: show)
    }
    
    func adaptToKeyboard(height: CGFloat, show: Bool, duration: TimeInterval = 0) {
        let constant: CGFloat = show ? height : 0
        
        let updateBlock = {
            self.tableViewBottom.constant = constant
            self.view.layoutIfNeeded()
        }
        
        if duration > 0 {
            UIView.animate(withDuration: duration, animations: updateBlock)
        } else {
            updateBlock()
        }
    }
}
