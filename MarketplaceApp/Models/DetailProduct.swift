//
//  DetailProduct.swift
//  MarketplaceApp
//
//  Created by Ilya on 31.08.2023.
//

import Foundation



struct DetailProduct: Decodable {
    let id, title, price, location: String
    let imageURL: String
    let date, description, email, phoneNumber: String
    let address: String

    enum CodingKeys: String, CodingKey {
        case id, title, price, location
        case imageURL = "image_url"
        case date = "created_date"
        case description, email
        case phoneNumber = "phone_number"
        case address
    }
}
