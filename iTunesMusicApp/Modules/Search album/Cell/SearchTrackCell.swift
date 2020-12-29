//
//  SearchTrackCell.swift
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
    var trackName: String? { get }
    var trackPrice: Double? { get }
    var currency: String? { get }
}

class SearchTrackCell: UITableViewCell {
    
    //MARK: - Public properties:
    static let cellIdentifier = "SearchTrackCell"
    
    //MARK: - Private properties:
    private let coverOfAlbum: CoverImageView = {
        let image = CoverImageView()
        image.contentMode = .scaleAspectFill
        return image
    }()
    
    private let trackNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .medium)
        label.numberOfLines = 1
        return label
    }()
    
    private let artistNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13, weight: .medium)
        label.textColor = #colorLiteral(red: 0.4941176471, green: 0.4941176471, blue: 0.5215686275, alpha: 1)
        label.numberOfLines = 1
        return label
    }()
    
    private let albumNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.textColor = #colorLiteral(red: 0.4941176471, green: 0.4941176471, blue: 0.5215686275, alpha: 1)
        label.numberOfLines = 1
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
        
        coverOfAlbum.fetchImage(from: album?.coverUrlString ?? "")
        trackNameLabel.text = album?.trackName
        artistNameLabel.text = album?.artistName
        albumNameLabel.text = album?.albumName
//        priceAlbumLabel.text = "\(album?.trackPrice ?? 0) \(album?.currency ?? "")"
        
        setupSubviews()
    }
    
    //MARK: - Private methods:
    private func setupSubviews() {
        addSubview(coverOfAlbum)
        addSubview(trackNameLabel)
        addSubview(artistNameLabel)
        addSubview(albumNameLabel)
//        addSubview(priceAlbumLabel)
        setupConstraints()
    }
    
    private func setupConstraints() {
        
        coverOfAlbum.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            coverOfAlbum.topAnchor.constraint(equalTo: self.topAnchor,
                                              constant: 12),
            coverOfAlbum.bottomAnchor.constraint(equalTo: self.bottomAnchor,
                                                 constant: -12),
            coverOfAlbum.leftAnchor.constraint(equalTo: self.leftAnchor,
                                               constant: 21),
            coverOfAlbum.heightAnchor.constraint(equalToConstant: 60),
            coverOfAlbum.widthAnchor.constraint(equalToConstant: 60)])
        
        trackNameLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            trackNameLabel.topAnchor.constraint(equalTo: self.topAnchor,
                                                constant: 13),
//            trackNameLabel.bottomAnchor.constraint(equalTo: artistNameLabel.topAnchor,
//                                                   constant: -5),
            trackNameLabel.leftAnchor.constraint(equalTo: coverOfAlbum.rightAnchor,
                                                 constant: 10),
            trackNameLabel.rightAnchor.constraint(equalTo: self.rightAnchor,
                                                  constant: -20),
//            trackNameLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 250)
        ])
        
        artistNameLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            artistNameLabel.topAnchor.constraint(equalTo: trackNameLabel.bottomAnchor,
                                                 constant: 2),
            artistNameLabel.bottomAnchor.constraint(equalTo: albumNameLabel.topAnchor,
                                                    constant: -2),
            artistNameLabel.leftAnchor.constraint(equalTo: coverOfAlbum.rightAnchor,
                                                  constant: 10),
            artistNameLabel.rightAnchor.constraint(equalTo: self.rightAnchor,
            constant: -20)
//            artistNameLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 250)
        ])
        
        albumNameLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
//            albumNameLabel.topAnchor.constraint(equalTo: artistNameLabel.bottomAnchor,
//                                                constant: 2),
            albumNameLabel.leftAnchor.constraint(equalTo: coverOfAlbum.rightAnchor,
                                                 constant: 10),
            albumNameLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor,
                                                    constant: -13),
            albumNameLabel.rightAnchor.constraint(equalTo: self.rightAnchor,
            constant: -20)
//            albumNameLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 250)
        ])
        
//        priceAlbumLabel.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//            priceAlbumLabel.topAnchor.constraint(equalTo: self.topAnchor,
//                                                 constant: 5),
//            priceAlbumLabel.leftAnchor.constraint(equalTo: trackNameLabel.rightAnchor,
//                                                  constant: 5),
//            priceAlbumLabel.rightAnchor.constraint(equalTo: self.rightAnchor,
//                                                   constant: -5),
//            priceAlbumLabel.widthAnchor.constraint(equalToConstant: 40)
//        ])
    }
}
