//
//  SearchAlbumCell.swift
//  iTunesMusicApp
//
//  Created by Артём Устинов on 25.12.2020.
//  Copyright © 2020 Artem Ustinov. All rights reserved.
//

import UIKit

class SearchAlbumCell: UITableViewCell {
    
    //MARK: - Private properties:
    private let coverOfAlbum: CoverImageView = {
        let image = CoverImageView()
        image.contentMode = .scaleToFill
        return image
    }()
    
    private let trackNameLabel: UILabel = {
        let label = UILabel()
        
        return label
    }()
    
    private let singerNameLabel: UILabel = {
        let label = UILabel()
        
        return label
    }()
    
    //MARK: - Public methods:
    func configureCell(with albums: CellViewModel.Cell?) {
        
        coverOfAlbum.fetchImage(from:
            albums?.coverUrlString ?? "")
        setupSubviews()
    }
    
    //MARK: - Private methods:
    private func setupSubviews() {
        addSubview(coverOfAlbum)
        setupConstraints()
    }
    
    private func setupConstraints() {
        
        coverOfAlbum.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            coverOfAlbum.topAnchor.constraint(equalTo: self.topAnchor,
                                            constant: 12),
            coverOfAlbum.bottomAnchor.constraint(equalTo: self.bottomAnchor,
                                               constant: 12),
            coverOfAlbum.leftAnchor.constraint(equalTo: self.leftAnchor,
                                             constant: 5)])
//            coverOfAlbum.trailingAnchor.constraint(equalTo: trackNameLabel.leftAnchor,
//                                                 constant: 5)])
//        coverOfAlbum.heightAnchor.constraint(equalToConstant: 40),
//        coverOfAlbum.widthAnchor.constraint(equalToConstant: 40)])
        
//        trackNameLabel.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//            trackNameLabel.topAnchor.constraint(equalTo: self.topAnchor,
//                                                constant: 0),
//            trackNameLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor,
//                                                   constant: 3),
//            trackNameLabel.leftAnchor.constraint(equalTo: coverOfAlbum.rightAnchor,
//                                                 constant: 0),
//            trackNameLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 0)
//        ])
        
//        singerNameLabel.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//            singerNameLabel.topAnchor.constraint(equalTo: trackNameLabel.bottomAnchor,
//                                                constant: 0),
//            singerNameLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor,
//                                                   constant: 0),
//            singerNameLabel.leftAnchor.constraint(equalTo: coverOfAlbum.rightAnchor,
//                                                 constant: 5),
//            singerNameLabel.rightAnchor.constraint(equalTo: self.rightAnchor,
//                                                   constant: 0)
//        ])
        
    }
}
