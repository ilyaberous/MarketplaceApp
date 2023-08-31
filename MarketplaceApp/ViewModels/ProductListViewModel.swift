//
//  ProductListViewModel.swift
//  MarketplaceApp
//
//  Created by Ilya on 30.08.2023.
//

import Foundation
import UIKit

protocol ProductListViewModelDelegate: AnyObject {
    func didLoadInitialProducts()
    func didSelectProduct(_ product: Product)
    func didCatchError()
}

class ProductListViewModel: NSObject {
    
    // MARK: - Properties
    var currentIndexPath: IndexPath?
    let pressedDownTransform =  CGAffineTransform.identity.scaledBy(x: 0.98, y: 0.98)
    
    //неккоретный URL (чтобы продемонстрировать оборажение экрана в состоянии ошибки)
    public var productsURL = "https://www.avito.st/s/interns-ios/main-page.jsondfgdfdg"
    private var products: [Product] = [] {
        didSet {
            for product in products {
                let cellViewModel = ProductCollectionViewCellModel(title: product.title,
                                                                   date: product.date,
                                                                   location: product.location,
                                                                   price: product.price,
                                                                   imgURL: URL(string: product.img))
                
                if (!productCellViewModels.contains(cellViewModel)) {
                    productCellViewModels.append(cellViewModel)
                }
                
            }

        }
    }
    private var productCellViewModels: [ProductCollectionViewCellModel] = []
    public weak var delegate: ProductListViewModelDelegate?
    
    // MARK: - Fetch list of products
    
    public func fetchProducts() {
        APICaller.shared.fetchData(url: productsURL) { [weak self] (result : Result<Products, NetworkError>) in
            switch result {
            case .success(let products):
                self?.products = products.advertisements
                DispatchQueue.main.async {
                    self?.delegate?.didLoadInitialProducts()
                }
            case .failure(_):
                DispatchQueue.main.async {
                    self?.delegate?.didCatchError()
                }
            }
        }
    }
}

// MARK: - CollectionView settings

extension ProductListViewModel: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return products.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductCollectionViewCell.identifier, for: indexPath) as! ProductCollectionViewCell
        
        let product = productCellViewModels[indexPath.row]
        cell.configure(with: product)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let product = products[indexPath.row]
        delegate?.didSelectProduct(product)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.width - 10 - 2*16) / 2
        return CGSize(width: width, height: 329)
    }
}

