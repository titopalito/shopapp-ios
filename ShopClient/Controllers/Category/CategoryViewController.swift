//
//  CategoryViewController.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 9/20/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import UIKit

class CategoryViewController: GridCollectionViewController<CategoryViewModel>, SortModalControllerProtocol {
    var categoryId: String!
    
    override func viewDidLoad() {
        viewModel = CategoryViewModel()
        super.viewDidLoad()
        
        setupViewModel()
        loadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        updateCartBarItem()
    }
    
    // MARK: - setup
    private func updateCartBarItem() {
        Repository.shared.getCartProductList { [weak self] (products, error) in
            let cartItemsCount = products?.count ?? 0
            self?.addCartBarButton(with: cartItemsCount)
        }
    }
    
    private func setupViewModel() {
        viewModel.categoryId = categoryId
        
        viewModel.products.asObservable()
            .subscribe(onNext: { [weak self] products in
                self?.stopLoadAnimating()
                self?.collectionView.reloadData()
            })
            .disposed(by: disposeBag)
    }
    
    private func loadData() {
        viewModel.reloadData()
    }
    
    // MARK: - actions
    func sortTapHandler() {
        let selectedValueString = SortingValue.allValues[viewModel.selectedSortingValue.rawValue]
        showCategorySortingController(with: SortingValue.allValues, selectedItem: selectedValueString, delegate: self)
    }
    
    // MARK: - overriding
    override func pullToRefreshHandler() {
        viewModel.reloadData()
    }
    
    override func infinityScrollHandler() {
        viewModel.loadNextPage()
    }
    
    // MARK: - SortModalControllerProtocol
    func didSelect(item: String) {
        if let index = SortingValue.allValues.index(of: item) {
            viewModel.selectedSortingValue = SortingValue(rawValue: index) ?? viewModel.selectedSortingValue
            let indexPath = IndexPath(row: 0, section: 0)
            collectionView.scrollToItem(at: indexPath, at: .top, animated: false)
            viewModel.reloadData()
        }
    }
    
    // MARK: - ErrorViewProtocol
    func didTapTryAgain() {
        loadData()
    }
}
