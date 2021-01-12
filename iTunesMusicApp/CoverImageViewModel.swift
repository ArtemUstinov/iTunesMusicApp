//
//  CoverImageViewModel.swift
//  iTunesMusicApp
//
//  Created by Артём Устинов on 11.01.2021.
//  Copyright © 2021 Artem Ustinov. All rights reserved.
//

import UIKit

class CoverImageViewModel {
    
    private let networkManager = NetworkManager()
    
    //MARK: - Cached methods:
    func fetchImageData(from url: URL,
                        completion: @escaping(Data) -> Void) {
        networkManager.fetchImageData(from: url) {
            [weak self] (imageData, response) in
            completion(imageData)
            self?.saveImageToCache(from: imageData,
                                   and: response)
        }
    }
    
    func getCachedImage(from url: URL) -> UIImage? {
        let urlRequest = URLRequest(url: url)
        if let cachedResponse =
            URLCache.shared.cachedResponse(for: urlRequest) {
            return UIImage(data: cachedResponse.data)
        }
        return nil
    }
    
    private func saveImageToCache(from data: Data,
                                  and response: URLResponse) {
        guard let url = response.url else { return }
        let urlRequest = URLRequest(url: url)
        let cachedResponse = CachedURLResponse(response: response,
                                               data: data)
        URLCache.shared.storeCachedResponse(cachedResponse,
                                            for: urlRequest)
    }
}
