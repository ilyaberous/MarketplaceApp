//
//  MainScreenViewController.swift
//  MarketplaceApp
//
//  Created by Ilya on 30.08.2023.
//

import UIKit

class MainScreenViewController: UIViewController {
    
    // MARK: - Variables
    
    private let productListView = ProductListView()
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Products"
        view.backgroundColor = .systemBackground
        setupView()
    }
    
    // MARK: - Setup View
    
    func setupView() {
        productListView.delegate = self
        view.addSubview(productListView)
        NSLayoutConstraint.activate([
            productListView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            productListView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            productListView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            productListView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
}

extension MainScreenViewController: ProductListViewDelegate {
    func productListView(_ productListView: ProductListView, _ product: Product) {
        let viewModel = DetailProductViewModel(product: product)
        let vc = DetailProductViewController(viewModel: viewModel)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
}
