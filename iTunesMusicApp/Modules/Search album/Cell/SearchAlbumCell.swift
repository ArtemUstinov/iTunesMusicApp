//
//  SearchAlbumCell.swift
//  iTunesMusicApp
//
//  Created by Артём Устинов on 25.12.2020.
//  Copyright © 2020 Artem Ustinov. All rights reserved.
//

import UIKit

protocol SearchCellViewModel {
    var coverUrlString: String? { get }
    var albumName: String? { get }
    var artistName: String? { get }
    var priceOfAlbum: Double? { get }
}

class SearchAlbumCell: UITableViewCell {
    
    //MARK: - Public properties:
    static let cellIdentifier = "SearchAlbumCell"
    
    //MARK: - Private properties:
    private let coverOfAlbum: CachedImageView = {
        let image = CachedImageView()
        image.contentMode = .scaleToFill
        return image
    }()
    
    private let albumNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "System", size: 14)
        label.numberOfLines = 0
        return label
    }()
    
    private let artistNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13)
        label.textColor = #colorLiteral(red: 0.4941176471, green: 0.4941176471, blue: 0.5215686275, alpha: 1)
        label.numberOfLines = 0
        return label
    }()
    
    private let priceAlbumLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 11)
        label.textColor = #colorLiteral(red: 0.4941176471, green: 0.4941176471, blue: 0.5215686275, alpha: 1)
        label.textAlignment = .right
        return label
    }()
    
    //MARK: - Override methods:
    override func prepareForReuse() {
        super.prepareForReuse()
        
        coverOfAlbum.image = nil
    }
    
    //MARK: - Public methods:
    func configureCell(with album: SearchCellViewModel?) {

        coverOfAlbum.setImage(url: album?.coverUrlString, placeholder: #imageLiteral(resourceName: "album-art-empty"))
        albumNameLabel.text = album?.albumName
        artistNameLabel.text = album?.artistName
        priceAlbumLabel.text = "\(album?.priceOfAlbum ?? 0)$"
        
        setupSubviews()
    }
    
    //MARK: - Private methods:
    private func setupSubviews() {
        addSubview(coverOfAlbum)
        addSubview(albumNameLabel)
        addSubview(artistNameLabel)
        addSubview(priceAlbumLabel)
        setupConstraints()
    }
    
    private func setupConstraints() {
        
        coverOfAlbum.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            coverOfAlbum.topAnchor.constraint(equalTo: self.topAnchor,
                                              constant: 3),
            coverOfAlbum.bottomAnchor.constraint(equalTo: self.bottomAnchor,
                                                 constant: -3),
            coverOfAlbum.leftAnchor.constraint(equalTo: self.leftAnchor,
                                               constant: 2),
            coverOfAlbum.heightAnchor.constraint(equalToConstant: 50),
            coverOfAlbum.widthAnchor.constraint(equalToConstant: 55)])
        
        albumNameLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            albumNameLabel.topAnchor.constraint(equalTo: self.topAnchor,
                                                constant: 4),
            albumNameLabel.bottomAnchor.constraint(equalTo: artistNameLabel.topAnchor,
                                                   constant: -4),
            albumNameLabel.leftAnchor.constraint(equalTo: coverOfAlbum.rightAnchor,
                                                 constant: 5),
        ])
        
        artistNameLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            artistNameLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor,
                                                    constant: -4),
            artistNameLabel.leftAnchor.constraint(equalTo: coverOfAlbum.rightAnchor,
                                                  constant: 5),
            artistNameLabel.rightAnchor.constraint(equalTo: self.rightAnchor,
                                                   constant: -16)
        ])
        
        priceAlbumLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            priceAlbumLabel.topAnchor.constraint(equalTo: self.topAnchor,
                                                    constant: 5),
            priceAlbumLabel.leftAnchor.constraint(equalTo: albumNameLabel.rightAnchor,
                                                  constant: 5),
            priceAlbumLabel.rightAnchor.constraint(equalTo: self.rightAnchor,
                                                   constant: -5),
            priceAlbumLabel.widthAnchor.constraint(equalToConstant: 40)
        ])
    }
}
