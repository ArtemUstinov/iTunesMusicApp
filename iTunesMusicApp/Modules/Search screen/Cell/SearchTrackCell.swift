//
//  SearchTrackCell.swift
//  iTunesMusicApp
//
//  Created by Артём Устинов on 25.12.2020.
//  Copyright © 2020 Artem Ustinov. All rights reserved.
//

import UIKit

protocol SearchCellViewModelProtocol: Codable {
    var trackPicture: String? { get }
    var albumName: String? { get }
    var artistName: String? { get }
    var trackName: String? { get }
    var trackPrice: Double? { get }
    var currency: String? { get }
    var previewUrl: String? { get }
}

class SearchTrackCell: UITableViewCell {
    
    //MARK: - Public properties:
    static let cellIdentifier = "SearchTrackCell"
    
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
    
    //MARK: - Private properties:
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
    
    private let demoButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .darkText
        button.setImage(#imageLiteral(resourceName: "search"), for: .normal)
        return button
    }()
    
    private let addButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = #colorLiteral(red: 0.9098039216, green: 0.2705882353, blue: 0.3529411765, alpha: 1)
        button.setImage(#imageLiteral(resourceName: "Add"), for: .normal)
        return button
    }()
    
    //MARK: - Override methods:
    override func prepareForReuse() {
        super.prepareForReuse()
        
        coverOfAlbum.image = nil
    }
    
    private var cellSearchViewModel: CellSearchViewModel.Cell?
    
    //MARK: - Public methods:
    func configureCell(with album: CellSearchViewModel.Cell) {
        
        cellSearchViewModel = album
        
        checkSavedTracks()
        
        coverOfAlbum.fetchImage(from: album.trackPicture ?? "")
        trackNameLabel.text = album.trackName
        artistNameLabel.text = album.artistName
        albumNameLabel.text = album.albumName
        
        addSubviews()
        setupLayoutTrackStackView()
        
        addTargets()
    }
    
    //MARK: - Private methods:
    private func checkSavedTracks() {
        let savedTracks = StorageManager.shared.fetchTracks()
        let isFavouriteTrack = savedTracks.first(where: {
            $0.trackId == cellSearchViewModel?.trackId
        }) != nil
        
        if isFavouriteTrack {
            addButton.isHidden = true
        } else {
            addButton.isHidden = false
        }
    }
    
    private func addSubviews() {
        addSubview(trackStackView)
    }
    
    //MARK: - Setup Layout
    private func setupLayoutTrackStackView() {
        NSLayoutConstraint.activate([
            trackStackView.topAnchor.constraint(equalTo: self.topAnchor, constant: 12),
            trackStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -12),
            trackStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 21),
            trackStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -24),
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
        
        //        trackStackView.addArrangedSubview(demoButton)
        //        NSLayoutConstraint.activate([
        //            demoButton.centerYAnchor.constraint(equalTo: self.centerYAnchor),
        //            demoButton.widthAnchor.constraint(equalToConstant: 16)
        //        ])
        
        trackStackView.addArrangedSubview(addButton)
        NSLayoutConstraint.activate([
            addButton.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            addButton.widthAnchor.constraint(equalToConstant: 16)
        ])
        
    }
    
    //MARK: - Button Targets
    private func addTargets() {
        demoButton.addTarget(self,
                             action: #selector(handleDemoButtonTapped),
                             for: .touchUpInside)
        
        addButton.addTarget(self,
                            action: #selector(handleAddButtonTapped),
                            for: .touchUpInside)
    }
    
    @objc private func handleDemoButtonTapped() {
        
        let tracks = StorageManager.shared.fetchTracks()
        
        print("Show: ", tracks.count)
    }
    
    @objc private func handleAddButtonTapped() {
        
        StorageManager.shared.saveTrack(track: cellSearchViewModel)
        addButton.isHidden = true
        print("Save :", cellSearchViewModel?.trackName)
    }
}
