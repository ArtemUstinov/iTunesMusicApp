//
//  SearchTrackCell.swift
//  iTunesMusicApp
//
//  Created by Артём Устинов on 25.12.2020.
//  Copyright © 2020 Artem Ustinov. All rights reserved.
//

import UIKit

class SearchTrackCell: UITableViewCell {
    
    private var cellSearchViewModel: CellSearchViewModel.Cell?
    
    //MARK: - UI elements:
    private let trackStackView = UIStackView(axis: .horizontal,
                                             distribution: .fill,
                                             spacing: 10)
    private let trackLabelsStackView = UIStackView(axis: .vertical,
                                                   distribution: .fillEqually,
                                                   spacing: 2)
    
    private let coverOfAlbum = CoverImageView(contentMode: .scaleAspectFill)
    
    private let trackNameLabel = UILabel(size: 17)
    private let artistNameLabel = UILabel(size: 13, color: #colorLiteral(red: 0.4941176471, green: 0.4941176471, blue: 0.5215686275, alpha: 1))
    private let albumNameLabel = UILabel(size: 12, color: #colorLiteral(red: 0.4941176471, green: 0.4941176471, blue: 0.5215686275, alpha: 1))
    
    private let addButton = UIButton(tintColor: #colorLiteral(red: 0.9098039216, green: 0.2705882353, blue: 0.3529411765, alpha: 1),
                                     image: #imageLiteral(resourceName: "Add"),
                                     state: .normal)
    
    //MARK: - Override methods:
    override func prepareForReuse() {
        super.prepareForReuse()
        
        coverOfAlbum.image = nil
        trackNameLabel.text = nil
        artistNameLabel.text = nil
        albumNameLabel.text = nil
    }
    
    //MARK: - Public methods:
    func configureCell(with album: CellSearchViewModel.Cell) {
        
        /// Режим выделения ячейки
//        selectionStyle = .none
        
        cellSearchViewModel = album
        checkSavedTracks()
        
        coverOfAlbum.fetchImage(from: album.trackPicture ?? "")
        trackNameLabel.text = album.trackName
        artistNameLabel.text = album.artistName
        albumNameLabel.text = album.albumName
        
        setupLayoutTrackStackView()
        addTargets()
    }
    
    //MARK: - Private methods:
    private func checkSavedTracks() {
        /// это надо проверять после получения данных с сервера, добавить isFavorite в модель ячейки
        StorageManager.shared.checkSavedTracks(for: cellSearchViewModel) {
            [weak self] isFavouriteTrack in
            self?.addButton.isHidden = isFavouriteTrack
        }
    }
    
    //MARK: - Setup Layout
    private func setupLayoutTrackStackView() {
        addSubview(trackStackView)
        
        trackStackView.addArrangedSubview(coverOfAlbum)
        trackStackView.addArrangedSubview(trackLabelsStackView)
        trackStackView.addArrangedSubview(addButton)
        trackLabelsStackView.addArrangedSubview(trackNameLabel)
        trackLabelsStackView.addArrangedSubview(artistNameLabel)
        trackLabelsStackView.addArrangedSubview(albumNameLabel)
        
        NSLayoutConstraint.activate([
            trackStackView.topAnchor.constraint(equalTo: topAnchor,
                                                constant: 12),
            trackStackView.bottomAnchor.constraint(equalTo: bottomAnchor,
                                                   constant: -12),
            trackStackView.leadingAnchor.constraint(equalTo: leadingAnchor,
                                                    constant: 21),
            trackStackView.trailingAnchor.constraint(equalTo: trailingAnchor,
                                                     constant: -24),
            
            coverOfAlbum.heightAnchor.constraint(equalToConstant: 60),
            coverOfAlbum.widthAnchor.constraint(equalToConstant: 60),
            
            addButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            addButton.widthAnchor.constraint(equalToConstant: 16)
        ])
    }
    
    //MARK: - Button Targets
    private func addTargets() {
        
        addButton.addTarget(self,
                            action: #selector(handleAddButtonTapped),
                            for: .touchUpInside)
    }
    
    @objc private func handleAddButtonTapped() {
        /// сделать делегат для ячейки, обрабатывать данную логику в vc
        StorageManager.shared.saveTrack(track: cellSearchViewModel)
        addButton.isHidden = true
    }
}