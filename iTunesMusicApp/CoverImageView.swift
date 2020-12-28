//
//  CoverImageView.swift
//  iTunesMusicApp
//
//  Created by Артём Устинов on 24.12.2020.
//  Copyright © 2020 Artem Ustinov. All rights reserved.
//

import UIKit

class CachedImageView: UIImageView {
    
    //MARK: - Private properties:
    private let networkManager = NetworkManager()
    
    //MARK: - Public methods:
    func setImage(url: String?, placeholder: UIImage? = nil) {

        guard let urlString = url,
              let url = URL(string: urlString) else {
            image = placeholder
            return
        }

        if let cachedImage = getCachedImage(from: url) {
            print("Cached photo was displayed")
            image = cachedImage
            return
        }

        networkManager.fetchImageData(from: url) { [weak self] result in

            switch result {
            case .success((let data, let response)):
                DispatchQueue.main.async {
                    self?.image = UIImage(data: data)
                }
                self?.saveImageToCache(from: data, and: response)

            case .failure(let error):
                self?.image = placeholder
                print(error)
            }
        }
    }

    //MARK: - Private methods:
    private func getCachedImage(from url: URL) -> UIImage? {
        
        let urlRequest = URLRequest(url: url)
        if let cachedResponse = URLCache.shared.cachedResponse(for: urlRequest) {
            return UIImage(data: cachedResponse.data)
        }
        return nil
    }
    
    private func saveImageToCache(from data: Data, and response: URLResponse) {
        
        guard let url = response.url else { return }
        let urlRequest = URLRequest(url: url)
        let cachedResponse = CachedURLResponse(response: response, data: data)
        URLCache.shared.storeCachedResponse(cachedResponse, for: urlRequest)
    }
}
