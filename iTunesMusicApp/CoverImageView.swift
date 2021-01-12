//
//  CoverImageView.swift
//  iTunesMusicApp
//
//  Created by Артём Устинов on 24.12.2020.
//  Copyright © 2020 Artem Ustinov. All rights reserved.
//

import UIKit

class CoverImageView: UIImageView {
    
    private let coverImageViewModel = CoverImageViewModel()
    
    //MARK: - Initializers:
    convenience init (
        cornerRadius: CGFloat = 0
    ) {
        self.init()
        self.contentMode = .scaleAspectFill
        layer.cornerRadius = cornerRadius
        layer.masksToBounds = true
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    //MARK: - Public methods:
    func fetchImage(from url: String) {
        
        guard let url = URL(string: url) else {
            image = #imageLiteral(resourceName: "album-art-empty")
            return
        }
        
        if let cachedImage = coverImageViewModel.getCachedImage(from: url) {
            image = cachedImage
            return
        }
        
        coverImageViewModel.fetchImageData(from: url) {
            [weak self] imageData in
            DispatchQueue.main.async {
                self?.image = UIImage(data: imageData)
            }
        }
    }
}
