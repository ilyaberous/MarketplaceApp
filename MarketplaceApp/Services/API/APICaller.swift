//
//  APICaller.swift
//  MarketplaceApp
//
//  Created by Ilya on 31.08.2023.
//

import Foundation
import UIKit



class APICaller {
    static let shared = APICaller()
    
    public func fetchData<T:Decodable>(url: String, completion: @escaping (Result<T, NetworkError>) -> ()) {
        guard let url = URL(string: url) else {
            completion(.failure(.badURL(URLError(.badURL))))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            
            if let error = error {
                completion(.failure(.transportError(error)))
            }
            
            if let response = response as? HTTPURLResponse, !(200...299).contains(response.statusCode) {
                       completion(.failure(.serverError(statusCode: response.statusCode)))
                       return
                   }
                   
           guard let data = data else {
               completion(.failure(.noData))
               return
           }
           
           do {
               let result = try JSONDecoder().decode(T.self, from: data)
               completion(.success(result))
           } catch {
               completion(.failure(.decodingError(error)))
           }
            
       }.resume()
    }
}

enum NetworkError: Error {
    case badURL(Error)
    case transportError(Error)
    case serverError(statusCode: Int)
    case noData
    case decodingError(Error)
    case encodingError(Error)
}

