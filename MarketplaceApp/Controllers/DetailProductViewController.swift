//
//  DetailProductViewController.swift
//  MarketplaceApp
//
//  Created by Ilya on 31.08.2023.
//

import UIKit

class DetailProductViewController: UIViewController {

    // MARK: - Variables
    
    private let detailProductView: DetailProductView
    private var viewModel: DetailProductViewModel
    
    // MARK: - LifeCycle
    
    init(viewModel: DetailProductViewModel!) {
        self.viewModel = viewModel
        self.detailProductView = DetailProductView(frame: .zero, viewModel: viewModel)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupView()
    }
    
    // MARK: - Setup View
    
    func setupView() {
        view.addSubview(detailProductView)
        NSLayoutConstraint.activate([
            detailProductView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            detailProductView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            detailProductView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            detailProductView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
}
