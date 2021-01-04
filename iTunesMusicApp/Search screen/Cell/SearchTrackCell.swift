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

    /// Убрали это свойство и добавили супер расширение на класс UITableViewCell
    //MARK: - Public properties:
//    static let cellIdentifier = "SearchTrackCell"

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

//    private let trackNameLabel: UILabel = {
//        let label = UILabel()
//        label.font = .systemFont(ofSize: 17, weight: .medium)
//        label.numberOfLines = 1
//        return label
//    }()

    /// Используем вспомогательные инициализаторы, делаем код значительно более читаемым
    private let trackNameLabel = UILabel(size: 17)

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

        /// Обнулять состояние ячейки что бы мы не видели не валидных данных
    }

    private var cellSearchViewModel: CellSearchViewModel.Cell?

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
        let savedTracks = StorageManager.shared.fetchTracks()
        let isFavouriteTrack = savedTracks.first(where: {
            $0.trackId == cellSearchViewModel?.trackId
        }) != nil

//        if isFavouriteTrack {
//            addButton.isHidden = true
//        } else {
//            addButton.isHidden = false
//        }
        /// старайся писать проще, если это возможно
        /// KISS - Keep It Simple, Stupid
        addButton.isHidden = isFavouriteTrack
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
            trackStackView.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            trackStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12),
            trackStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 21),
            trackStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24),

            coverOfAlbum.heightAnchor.constraint(equalToConstant: 60),
            coverOfAlbum.widthAnchor.constraint(equalToConstant: 60),

            addButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            addButton.widthAnchor.constraint(equalToConstant: 16)
        ])

        //        trackStackView.addArrangedSubview(demoButton)
        //        NSLayoutConstraint.activate([
        //            demoButton.centerYAnchor.constraint(equalTo: self.centerYAnchor),
        //            demoButton.widthAnchor.constraint(equalToConstant: 16)
        //        ])


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

/// Вынести в отдельный файл Extensions/UIKit/UILabel+
/// + Добавить вспомогательные инициализаьторы для других часто используемым классов
extension UILabel {

    convenience init(
        size: CGFloat,
        weight: UIFont.Weight = .medium,
        lines: Int = 1
    ) {
        self.init()
        font = .systemFont(ofSize: size, weight: weight)
        numberOfLines = lines
    }
}

/// Вынести в отдельный файл Extensions/UIKit/UITableViewCell+
/// Если где то используешь коллекцию, то можно добавить точно такую же фичу для неё.
extension UITableViewCell {

    static var identifier: String { String(describing: self) }
}
