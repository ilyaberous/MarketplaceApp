//
//  Card.swift
//  MarketplaceApp
//
//  Created by Ilya on 30.08.2023.
//

import Foundation


struct Product: Decodable {
    let id: String
    let title: String
    let price: String
    let location: String
    let img: String
    let date: String
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case title = "title"
        case price = "price"
        case location = "location"
        case img = "image_url"
        case date = "created_date"
    }
}
