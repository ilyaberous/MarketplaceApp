//
//  ImageDownloader.swift
//  MarketplaceApp
//
//  Created by Ilya on 30.08.2023.
//

import Foundation


final class ImageDownloader {

    static let shared = ImageDownloader()


    private var imageDataCache = NSCache<NSString, NSData>()


    private init() {}

    /// Get image content with URl
    /// - Parameters:
    ///   - url: Source url
    ///   - completion: Callback
    public func downloadImage(_ url: URL, completion: @escaping (Result<Data, Error>) -> ()) {
        let key = url.absoluteString as NSString
        if let data = imageDataCache.object(forKey: key) {
            completion(.success(data as Data))
            return
        }

        let request = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request) { [weak self] data, _, error in
            guard let data = data, error == nil else {
                completion(.failure(error ?? URLError(.badServerResponse)))
                return
            }
            let value = data as NSData
            self?.imageDataCache.setObject(value, forKey: key)
            completion(.success(data))
        }
        task.resume()
    }
}
