//
//  CoverImageView.swift
//  iTunesMusicApp
//
//  Created by Артём Устинов on 24.12.2020.
//  Copyright © 2020 Artem Ustinov. All rights reserved.
//

import UIKit

class CoverImageView: UIImageView {
    
    //MARK: - Private properties:
    private let networkManager = NetworkManager()
    
    //MARK: - Initializers:
    convenience init (
        contentMode: UIView.ContentMode,
        cornerRadius: CGFloat = 0,
        masksToBounds: Bool = true,
        autoresizing: Bool = false
    ) {
        self.init()
        self.contentMode = contentMode
        layer.cornerRadius = cornerRadius
        layer.masksToBounds = masksToBounds
        translatesAutoresizingMaskIntoConstraints = autoresizing
    }
    
    //MARK: - Public methods:
    func fetchImage(from url: String) {
        
        guard let url = URL(string: url) else {
            image = #imageLiteral(resourceName: "album-art-empty")
            return
        }
        
        if let cachedImage = getCachedImage(from: url) {
            print("Cached photo was displayed")
            image = cachedImage
            return
        }
        
        networkManager.fetchImageData(from: url) {
            [weak self] (imageData, response) in
            DispatchQueue.main.async {
                self?.image = UIImage(data: imageData)
            }
            self?.saveImageToCache(from: imageData,
                                   and: response)
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
    
    private func saveImageToCache(from data: Data,
                                  and response: URLResponse) {
        
        guard let url = response.url else { return }
        let urlRequest = URLRequest(url: url)
        let cachedResponse = CachedURLResponse(response: response,
                                               data: data)
        URLCache.shared.storeCachedResponse(cachedResponse,
                                            for: urlRequest)
        //        print("Save image")
    }
}
