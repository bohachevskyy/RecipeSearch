//
//  RecipeSearchViewModelTests.swift
//  RecipeSearchViewModelTests
//
//  Created by Mark Vasiv on 31/05/2019.
//  Copyright © 2019 Mark Vasiv. All rights reserved.
//

import XCTest
@testable import RecipeSearch

final class RecipeSearchViewModelTests: XCTestCase {
    
    lazy var service: RecipeServiceMock = RecipeServiceMock()
    
    let defaultTimeout: TimeInterval = 0.5
    
    func testInitialStateIsEmpty() {
        let stateIsEmpty = expectation(description: "State is empty")
        
        let viewModel = RecipeSearchViewModel(searchService: service)
        
        if case .empty = viewModel.state {
            stateIsEmpty.fulfill()
        }
        
        wait(for: [stateIsEmpty], timeout: defaultTimeout)
    }
    
    func testViewModelFetchesData() {
        service.throwsError = false
        
        let dataLoaded = expectation(description: "Data fetched")
        
        service.onDataLoad = { (result) in
            dataLoaded.fulfill()
        }
        
        let viewModel = RecipeSearchViewModel(searchService: service)
        viewModel.didSearch(with: Random.string(length: 3))
        
        wait(for: [dataLoaded], timeout: defaultTimeout)
    }
    
    func testNormalDataFetch() {
        service.throwsError = false
        
        let loadingStatePassedToView = expectation(description: "Loading state passed to view")
        let dataPassedToView = expectation(description: "Data passed to view")
        
        let viewModel = RecipeSearchViewModel(searchService: service)
        
        viewModel.onStateChange = { (state) in
            if case .loading = state {
                loadingStatePassedToView.fulfill()
            }
            if case .withData(_) = state {
                dataPassedToView.fulfill()
            }
        }
        
        viewModel.didSearch(with: Random.string(length: 3))
        
        wait(for: [loadingStatePassedToView, dataPassedToView], timeout: defaultTimeout, enforceOrder: true)
    }
    
    func testErrorDataFetch() {
        service.throwsError = true
        
        let errorPassedToView = expectation(description: "Error passed to view")
        let currentStateIsEmpty = expectation(description: "Current state is empty")
        let updateStateToEmpty = expectation(description: "Updated state to empty")
        let viewModel = RecipeSearchViewModel(searchService: service)
        
        viewModel.onError = { (error) in
            errorPassedToView.fulfill()
            if viewModel.state == .empty {
                currentStateIsEmpty.fulfill()
            }
        }
        
        viewModel.onStateChange = { (state) in
            if case .empty = state {
                updateStateToEmpty.fulfill()
            }
        }
        
        viewModel.didSearch(with: Random.string(length: 3))
        
        wait(for: [errorPassedToView, currentStateIsEmpty, updateStateToEmpty], timeout: defaultTimeout)
    }
    
    func testMultiplePagesLoad() {
        service.throwsError = false
        service.returnFullPage = true
        
        let loadedTwoPages = expectation(description: "Loaded two pages")
        
        let viewModel = RecipeSearchViewModel(searchService: service)
        
        var numberOfLoads = 0
        
        viewModel.onStateChange = { (state) in
            if case .withData(_) = state {
                numberOfLoads += 1
            }
            
            if numberOfLoads == 2 {
                loadedTwoPages.fulfill()
            }
        }
        
        viewModel.didSearch(with: Random.string(length: 3))
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1) {
            viewModel.didScrollToBottom()
        }
        
        wait(for: [loadedTwoPages], timeout: defaultTimeout)
    }
    
    func testStopsTryingToLoadNewPage() {
        service.throwsError = false
        service.returnFullPage = false
        
        let loadedTwoPages = expectation(description: "Loaded two pages")
        loadedTwoPages.isInverted = true
        
        let viewModel = RecipeSearchViewModel(searchService: service)
        
        var numberOfLoads = 0
        
        viewModel.onStateChange = { (state) in
            if case .withData(_) = state {
                numberOfLoads += 1
            }
            
            if numberOfLoads > 1 {
                loadedTwoPages.fulfill()
            }
        }
        
        viewModel.didSearch(with: Random.string(length: 3))
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1) {
            viewModel.didScrollToBottom()
        }
        
        wait(for: [loadedTwoPages], timeout: defaultTimeout)
    }
    
    func testErasesDataOnCancel() {
        service.throwsError = false
        
        let loadedData = expectation(description: "Loaded data")
        let erasedData = expectation(description: "Erased data")
        
        let viewModel = RecipeSearchViewModel(searchService: service)
        
        viewModel.onStateChange = { (state) in
            if case .withData(_) = state {
                loadedData.fulfill()
            }
            
            if case .empty = state {
                erasedData.fulfill()
            }
        }
        
        viewModel.didSearch(with: Random.string(length: 3))
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1) {
            viewModel.didTapCancel()
        }
        
        wait(for: [loadedData, erasedData], timeout: defaultTimeout, enforceOrder: true)
    }
    
    func testInvokesCancelCallback() {
        let invokedCancelCallback = expectation(description: "Invoked cancel callback")
        let viewModel = RecipeSearchViewModel(searchService: service)
        
        viewModel.onCancel = {
            invokedCancelCallback.fulfill()
        }
        
        viewModel.didTapCancel()
        
        wait(for: [invokedCancelCallback], timeout: defaultTimeout)
    }
    
    func testInvokesSelectionCallback() {
        service.throwsError = false
        let invokedSelectionCallback = expectation(description: "Invoked selection callback")
        
        let viewModel = RecipeSearchViewModel(searchService: service)
        
        var index: Int = 0
        var data: [RecipeSearchModel] = []
        
        viewModel.onStateChange = { (state) in
            if case .withData(let _data) = state {
                data = _data
                
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1, execute: {
                    index = Random.integer(min: 0, max: data.count)
                    viewModel.didSelectRow(at: IndexPath(row: index, section: 0))
                })
            }
        }
        
        viewModel.onSelection = { (model) in
            if model.recipeId == data[index].recipeId {
                invokedSelectionCallback.fulfill()
            }
        }
        
        viewModel.didSearch(with: Random.string(length: 3))
        
        wait(for: [invokedSelectionCallback], timeout: defaultTimeout)
    }
}
