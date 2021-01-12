//
//  LibraryTrackCell.swift
//  iTunesMusicApp
//
//  Created by Артём Устинов on 02.01.2021.
//  Copyright © 2021 Artem Ustinov. All rights reserved.
//

import UIKit

class LibraryTrackCell: UITableViewCell {
    
    //MARK: - UI elements:
    private let trackStackView = UIStackView(
        axis: .horizontal,
        distribution: .fill,
        spacing: 10
    )
    private let trackLabelsStackView = UIStackView(
        axis: .vertical,
        distribution: .fillEqually,
        spacing: 2
    )
    
    private let trackImage = CoverImageView(cornerRadius: 5)
    
    private let trackNameLabel = UILabel(size: 17)
    private let artistNameLabel = UILabel(size: 13, color: #colorLiteral(red: 0.4941176471, green: 0.4941176471, blue: 0.5215686275, alpha: 1))
    private let albumNameLabel = UILabel(size: 12, color: #colorLiteral(red: 0.4941176471, green: 0.4941176471, blue: 0.5215686275, alpha: 1))
    
    //MARK: - Override methods:
    override func prepareForReuse() {
        super.prepareForReuse()
        
        trackImage.image = nil
        trackNameLabel.text = nil
        artistNameLabel.text = nil
        albumNameLabel.text = nil
    }
    
    //MARK: - Public methods:
    func configureCell(with track: CellSearchModel.Cell) {
        trackImage.fetchImage(from: track.trackPicture ?? "")
        trackNameLabel.text = track.trackName
        artistNameLabel.text = track.artistName
        albumNameLabel.text = track.albumName
        
        setupLayoutTrackStackView()
    }
    
    //MARK: - Setup Layout:
    private func setupLayoutTrackStackView() {
        contentView.addSubview(trackStackView)
        
        trackStackView.addArrangedSubview(trackImage)
        trackStackView.addArrangedSubview(trackLabelsStackView)
        
        trackLabelsStackView.addArrangedSubview(trackNameLabel)
        trackLabelsStackView.addArrangedSubview(artistNameLabel)
        trackLabelsStackView.addArrangedSubview(albumNameLabel)
        
        NSLayoutConstraint.activate([
            trackStackView.topAnchor.constraint(
                equalTo: contentView.topAnchor,
                constant: 12
            ),
            trackStackView.bottomAnchor.constraint(
                equalTo: contentView.bottomAnchor,
                constant: -12
            ),
//            trackStackView.leadingAnchor.constraint(
//                equalTo: contentView.leadingAnchor
//            ),
//            trackStackView.trailingAnchor.constraint(
//                equalTo: contentView.readableContentGuide.trailingAnchor
//            ),
            trackImage.heightAnchor.constraint(equalToConstant: 60),
            trackImage.widthAnchor.constraint(equalToConstant: 60)
        ])
    }
}


