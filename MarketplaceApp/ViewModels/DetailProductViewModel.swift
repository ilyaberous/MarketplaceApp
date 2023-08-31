//
//  DetailViewModel.swift
//  MarketplaceApp
//
//  Created by Ilya on 31.08.2023.
//

import Foundation
import UIKit

protocol DetailProductViewModelDelegate: AnyObject {
    func didDataLoad()
    func didCatchError()
}

final class DetailProductViewModel: NSObject {
    // MARK: - Properties
    public var baseCurrentProductUrl = "https://www.avito.st/s/interns-ios/details/ddddrhhr" // /{itemId}.json
    private var product: Product
    public var detailProduct: DetailProduct!
    public weak var delegate: DetailProductViewModelDelegate?
    
    private var currentProductUrl: String {
        return baseCurrentProductUrl + "/" +  product.id + ".json"
    }
    
    private var imageURL: URL? {
        return URL(string: product.img)
    }
    
    // MARK: - Init
    init(product: Product) {
        self.product = product
    }
    
    
    public func fetchDetailProducts() {
        APICaller.shared.fetchData(url: currentProductUrl) { [weak self] (result : Result<DetailProduct, NetworkError>) in
            switch result {
            case .success(let result):
                self?.detailProduct = result
                //убрал Dispatch!!
                DispatchQueue.global(priority: .high).async {
                    self?.delegate?.didDataLoad()
                }
                
            case .failure(_):
                DispatchQueue.main.async {
                    self?.delegate?.didCatchError()
                }
            }
        }
    }
    
    func fetchImage(completion: @escaping (Result<Data, Error>) -> ()) {
        guard let url = imageURL else {
            completion(.failure(URLError(.badURL)))
            return
        }
        ImageDownloader.shared.downloadImage(url, completion: completion)
    }
    
}
