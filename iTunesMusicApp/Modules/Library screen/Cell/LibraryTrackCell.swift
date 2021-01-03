//
//  LibraryTrackCell.swift
//  iTunesMusicApp
//
//  Created by Артём Устинов on 02.01.2021.
//  Copyright © 2021 Artem Ustinov. All rights reserved.
//

import UIKit

class LibraryTrackCell: UITableViewCell {
    
    static let cellIdentifier = "TrackCell"
    
    //MARK: - UIStackViews:
    private let trackStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let trackLabelsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 2
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    //MARK: - UI elements:
    private let coverOfAlbum: CoverImageView = {
        let image = CoverImageView()
        image.backgroundColor = .red
        image.contentMode = .scaleAspectFill
        image.translatesAutoresizingMaskIntoConstraints = false
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
    func configureCell(with track: CellSearchViewModel.Cell) {
        
        coverOfAlbum.fetchImage(from: track.trackPicture ?? "")
        trackNameLabel.text = track.trackName
        artistNameLabel.text = track.artistName
        albumNameLabel.text = track.albumName
        
        addSubviews()
        setupLayoutTrackStackView()
    }
    
    //MARK: - Setup Layout:
    private func addSubviews() {
        addSubview(trackStackView)
    }
    
    private func setupLayoutTrackStackView() {
        NSLayoutConstraint.activate([
            trackStackView.topAnchor.constraint(equalTo: self.topAnchor,
                                                constant: 12),
            trackStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor,
                                                   constant: -12),
            trackStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor,
                                                    constant: 21),
            trackStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor,
                                                     constant: 0),
        ])
        
        trackStackView.addArrangedSubview(coverOfAlbum)
        NSLayoutConstraint.activate([
            coverOfAlbum.heightAnchor.constraint(equalToConstant: 60),
            coverOfAlbum.widthAnchor.constraint(equalToConstant: 60)
        ])
        
        trackStackView.addArrangedSubview(trackLabelsStackView)
        
        trackLabelsStackView.addArrangedSubview(trackNameLabel)
        trackLabelsStackView.addArrangedSubview(artistNameLabel)
        trackLabelsStackView.addArrangedSubview(albumNameLabel)
    }
}

