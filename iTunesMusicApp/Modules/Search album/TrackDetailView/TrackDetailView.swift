//
//  TrackDetailView.swift
//  iTunesMusicApp
//
//  Created by Артём Устинов on 28.12.2020.
//  Copyright © 2020 Artem Ustinov. All rights reserved.
//

import UIKit

class TrackDetailView: UIView {
    
    //MARK: StackViews
    private let mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let labelsOfTimeStaskView: UIStackView = {
        let stackView = UIStackView()
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let trackTimeStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let trackNameStaskView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let musicButtonsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.distribution = .fillEqually
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let volumeStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    //MARK: UIButtons
    private let dragDownButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "Drag Down"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let previousTrackButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .darkText
        button.setImage(#imageLiteral(resourceName: "Left"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let nextTrackButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .darkText
        button.setImage(#imageLiteral(resourceName: "Right"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let playPauseButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let playButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "play"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let pauseButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    //MARK: UIImageViews
    private let trackImage: UIImageView = {
        let image = UIImageView()
        image.backgroundColor = .red
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    private let lowSoundImage: UIImageView = {
        let image = UIImageView()
        image.image = #imageLiteral(resourceName: "Icon Min")
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    private let loudSoundImage: UIImageView = {
        let image = UIImageView()
        image.image = #imageLiteral(resourceName: "IconMax")
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    //MARK: UILabels
    private let currentTimeLabel: UILabel = {
        let label = UILabel()
        label.text = "00:00"
        label.font = .systemFont(ofSize: 15)
        label.textColor = #colorLiteral(red: 0.5647058824, green: 0.568627451, blue: 0.5882352941, alpha: 1)
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let durationTimeLabel: UILabel = {
        let label = UILabel()
        label.text = "--:--"
        label.font = .systemFont(ofSize: 15)
        label.textColor = #colorLiteral(red: 0.5647058824, green: 0.568627451, blue: 0.5882352941, alpha: 1)
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let trackNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Track"
        label.font = .systemFont(ofSize: 24, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let artistNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Artist"
        label.textColor = #colorLiteral(red: 0.9098039216, green: 0.2705882353, blue: 0.3529411765, alpha: 1)
        label.font = .systemFont(ofSize: 24, weight: .light)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    //MARK: UISliders
    private let currentTimeSlider: UISlider = {
        let slider = UISlider()
        slider.value = slider.minimumValue
        slider.translatesAutoresizingMaskIntoConstraints = false
        return slider
    }()
    
    private let volumeSlider: UISlider = {
        let slider = UISlider()
        slider.translatesAutoresizingMaskIntoConstraints = false
        return slider
    }()
    
    //MARK: - Override methods:
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        addTargets()
        
        setupSubview()
        autoLayoutMainStackView()
        autoLayoutTrackTimeStackView()
        autoLayoutLabelsOfTimeStackView()
        autoLayoutTrackNameStackView()
        autoLayoutMusicButtonsStackView()
        autoLayoutVolumeStackView()
    }
    
    //MARK: Targets
    private func addTargets() {
        dragDownButton.addTarget(self,
        action: #selector(dragDownButtonTapped),
        for: .touchUpInside)
    }
    
    //MARK: @objc Actions
    @objc private func dragDownButtonTapped() {
        removeFromSuperview()
    }
    
    @objc private func handleCurrentTimeSlider() {
        
    }
    
    @objc private func previousTrackButtonTapped() {
        
    }
    
    @objc private func nextTrackButtonTapped() {
        
    }
    
    @objc private func playPauseButtonTapped() {
        
    }
    
    //MARK: SetupAutoLayout
    private func setupSubview() {
        backgroundColor = .white
        addSubview(mainStackView)
    }
    
    private func autoLayoutMainStackView() {
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor,
                                               constant: 30),
            mainStackView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor,
                                                  constant: -30),
            mainStackView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor,
                                                   constant: 30),
            mainStackView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor,
                                                    constant: -30)
        ])
        
        mainStackView.addArrangedSubview(dragDownButton)
        NSLayoutConstraint.activate([
            dragDownButton.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        mainStackView.addArrangedSubview(trackImage)
        NSLayoutConstraint.activate([
            trackImage.widthAnchor.constraint(equalTo: trackImage.heightAnchor,
                                              multiplier: (1.0 / 1.0))
        ])
    }
    
    private func autoLayoutLabelsOfTimeStackView() {
        trackTimeStackView.addArrangedSubview(labelsOfTimeStaskView)
        
        labelsOfTimeStaskView.addArrangedSubview(currentTimeLabel)
        labelsOfTimeStaskView.addArrangedSubview(durationTimeLabel)
    }
    
    private func autoLayoutTrackTimeStackView() {
        mainStackView.addArrangedSubview(trackTimeStackView)
        
        trackTimeStackView.addArrangedSubview(currentTimeSlider)
    }
    
    private func autoLayoutTrackNameStackView() {
        mainStackView.addArrangedSubview(trackNameStaskView)
        
        trackNameStaskView.addArrangedSubview(trackNameLabel)
        trackNameStaskView.addArrangedSubview(artistNameLabel)
    }
    
    private func autoLayoutMusicButtonsStackView() {
        mainStackView.addArrangedSubview(musicButtonsStackView)
        
        musicButtonsStackView.addArrangedSubview(previousTrackButton)
        musicButtonsStackView.addArrangedSubview(playButton)
        musicButtonsStackView.addArrangedSubview(nextTrackButton)
    }
    
    private func autoLayoutVolumeStackView() {
        mainStackView.addArrangedSubview(volumeStackView)
        
        volumeStackView.addArrangedSubview(lowSoundImage)
        NSLayoutConstraint.activate([
            lowSoundImage.heightAnchor.constraint(equalToConstant: 17),
            lowSoundImage.widthAnchor.constraint(equalTo: lowSoundImage.heightAnchor,
                                                 multiplier: (1.0 / 1.0))
        ])
        
        volumeStackView.addArrangedSubview(volumeSlider)
        
        volumeStackView.addArrangedSubview(loudSoundImage)
        NSLayoutConstraint.activate([
            loudSoundImage.heightAnchor.constraint(equalToConstant: 17),
            loudSoundImage.widthAnchor.constraint(equalTo: loudSoundImage.heightAnchor,
                                                  multiplier: 1.0 / 1.0)
        ])
    }
}
