//
//  ProductCollectionViewCellModel.swift
//  MarketplaceApp
//
//  Created by Ilya on 30.08.2023.
//

import Foundation
import UIKit


class ProductCollectionViewCellModel: NSObject {
    // MARK: - Properties
    
    let title: String
    var date: String {
        didSet {
            let dateFormatterGet = DateFormatter()
            dateFormatterGet.dateFormat = "yyyy-MM-dd"
            
            let dateFormatterPrint = DateFormatter()
            dateFormatterPrint.dateFormat = "d MMMM"
            dateFormatterPrint.locale = Locale(identifier: "ru_RU")
            
            if let formattedDate = dateFormatterGet.date(from: self.date) {
                date = dateFormatterPrint.string(from: formattedDate)
            } else {
                print("There was an error decoding the string")
            }
        }
    }
    let location: String
    var price: String {
        didSet {
            if (price.count-2 > 3) {
                let numberOfZero = (price.count-2) / 3
                let numberOfNotZero = (price.count-2) % 3
                
                var indx = price.startIndex
                var offsetBy = 3
                
                if numberOfNotZero != 0 {
                    indx = price.index(price.startIndex, offsetBy:  numberOfNotZero)
                    price.insert(" ", at: indx)
                    offsetBy = 4
                }
                
                
                for _ in 1..<numberOfZero where numberOfZero > 1 {
                    indx = price.index(indx, offsetBy: offsetBy)
                    price.insert(" ", at: indx)
                }
                
            }
        }
    }
    
    let imgURL: URL?
    
    // MARK: - LifeCycle
    
    init(title: String, date: String, location: String, price: String, imgURL: URL?) {
        self.title = title
        self.date = date
        self.location = location
        self.price = price
        defer {
            self.setFormattedPriceAndDate(price: price, date: date)
        }
        self.imgURL = imgURL
        super.init()
    }
    
    
    private func setFormattedPriceAndDate(price: String, date: String) {
        self.price = price
        self.date = date
    }
    
    // MARK: - Fetch image for CollectionViewcell
    
    func fetchImage(completion: @escaping (Result<Data, Error>) -> ()) {
        guard let url = imgURL else {
            completion(.failure(URLError(.badURL)))
            return
        }
        ImageDownloader.shared.downloadImage(url, completion: completion)
    }
}
