//
//  TrackDetailView.swift
//  iTunesMusicApp
//
//  Created by Артём Устинов on 28.12.2020.
//  Copyright © 2020 Artem Ustinov. All rights reserved.
//

import UIKit
import AVKit

//MARK: - Protocols
protocol TrackMovingDelegate: AnyObject {
    func moveBackForPreviousTrack() -> CellSearchModel.Cell?
    func moveForwardForNextTrack() -> CellSearchModel.Cell?
}

class TrackDetailView: UIView {
    
    //MARK: - Properties:
    weak var trackMovingDelegate: TrackMovingDelegate?
    weak var tabBarDelegate: TabBarControllerDelegate?
    
    private let avPlayer = AVPlayerViewModel.shared
    
    //MARK: - MiniPlayer UI elements:
    private let miniPlayerStackView = UIStackView(
        axis: .horizontal,
        distribution: .fill,
        spacing: 16
    )
    private let topLineMiniPlayerView = UIView(
        backgroundColor: .opaqueSeparator,
        alpha: 0.7
    )
    private let miniPlayPauseButton = UIButton(image: #imageLiteral(resourceName: "pause"))
    private let miniNextTrackButton = UIButton(image: #imageLiteral(resourceName: "Right"))
    private let miniTrackNameLabel = UILabel(weight: .regular)
    private let miniTrackImage = CoverImageView(cornerRadius: 5)
    let miniPlayerView = UIView(
        backgroundColor: .secondarySystemBackground
    )
    
    //MARK: - UI elements:
    let mainStackView = UIStackView(axis: .vertical,
                                    distribution: .fill,
                                    spacing: 10)
    private let labelsOfTimeStaskView = UIStackView(
        distribution: .fillEqually
    )
    private let trackTimeStackView = UIStackView(
        axis: .vertical,
        distribution: .fillProportionally
    )
    private let trackNameStaskView = UIStackView(
        axis: .vertical,
        alignment: .center
    )
    private let musicButtonsStackView = UIStackView(
        distribution: .fillEqually,
        alignment: .center
    )
    private let volumeStackView = UIStackView(spacing: 10)
    
    
    private let dragDownButton = UIButton(type: .custom,
                                          image: #imageLiteral(resourceName: "Drag Down"))
    private let previousTrackButton = UIButton(image: #imageLiteral(resourceName: "Left"))
    private let nextTrackButton = UIButton(image: #imageLiteral(resourceName: "Right"))
    private let playPauseButton = UIButton(image: #imageLiteral(resourceName: "pause"))
    
    private let trackImage = CoverImageView(cornerRadius: 10)
    private let lowSoundImage = UIImageView(image: #imageLiteral(resourceName: "Icon Min"))
    private let loudSoundImage = UIImageView(image: #imageLiteral(resourceName: "IconMax"))
    
    
    private let currentTimeLabel = UILabel(text: "00:00",
                                           size: 15,
                                           weight: .regular,
                                           alignment: .left,
                                           color: #colorLiteral(red: 0.5647058824, green: 0.568627451, blue: 0.5882352941, alpha: 1))
    private let durationTimeLabel = UILabel(text: "--:--",
                                            size: 15,
                                            weight: .regular,
                                            alignment: .right,
                                            color: #colorLiteral(red: 0.5647058824, green: 0.568627451, blue: 0.5882352941, alpha: 1))
    private let trackNameLabel = UILabel(size: 24,
                                         weight: .semibold,
                                         alignment: .center,
                                         lines: 0)
    private let artistNameLabel = UILabel(size: 24,
                                          weight: .light,
                                          color: #colorLiteral(red: 0.9098039216, green: 0.2705882353, blue: 0.3529411765, alpha: 1))
    
    
    private let currentTimeSlider = UISlider(value: 0)
    private let volumeSlider = UISlider(value: 0.5)
    
    //MARK: - Override methods:
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        setupGestures()
        addTargets()
        
        setupPlayer()
        
        setupSubviews()
        autoLayoutMainStackView()
        autoLayoutMiniPlayerView()
    }
    
    //MARK: - SetupUI:
    func set(cellViewModel: CellSearchModel.Cell) {
        
        miniTrackNameLabel.text = cellViewModel.trackName
        miniTrackImage.fetchImage(from: cellViewModel.trackPicture ?? "")
        
        playPauseButton.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
        miniPlayPauseButton.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
        
        getThumbnailImage(withScale: 0.8)
        
        trackNameLabel.text = cellViewModel.trackName
        artistNameLabel.text = cellViewModel.artistName
        
        let convertImageSize =
            cellViewModel.trackPicture?.replacingOccurrences(
                of: "100x100",
                with: "600x600"
        )
        trackImage.fetchImage(from: convertImageSize ?? "")
        
        avPlayer.playTrack(from: cellViewModel.previewUrl)
    }
    
    //MARK: - Setup TrackImage, player:
    private func setupPlayer() {
        avPlayer.monitorStartTimeTrack {
            [weak self] in
            self?.enlargeTrackImage()
        }
        avPlayer.observePlayerCurrentTime {
            [weak self] (time, currentDurationTime) in
            self?.currentTimeLabel.text = time.toDisplayString()
            self?.durationTimeLabel.text = "-\(currentDurationTime)"
            self?.currentTimeSlider.value =
                self?.avPlayer.updateCurrentTimeSlider() ?? 0
            
            if self?.currentTimeSlider.isTracking == true {
                self?.currentTimeSlider.minimumTrackTintColor = #colorLiteral(red: 0.9098039216, green: 0.2705882353, blue: 0.3529411765, alpha: 1)
                self?.currentTimeSlider.thumbTintColor = #colorLiteral(red: 0.9098039216, green: 0.2705882353, blue: 0.3529411765, alpha: 1)
            } else {
                self?.currentTimeSlider.minimumTrackTintColor = .lightGray
                self?.currentTimeSlider.thumbTintColor = nil
            }
        }
    }
    
    private func enlargeTrackImage() {
        UIView.animate(withDuration: 1,
                       delay: 0,
                       usingSpringWithDamping: 0.5,
                       initialSpringVelocity: 1,
                       options: .curveEaseInOut,
                       animations: {
                        self.trackImage.transform = .identity
        }, completion: nil)
    }
    
    private func reduceTrackImage() {
        UIView.animate(withDuration: 1,
                       delay: 0,
                       usingSpringWithDamping: 0.5,
                       initialSpringVelocity: 1,
                       options: .curveEaseInOut,
                       animations: {
                        self.getThumbnailImage(withScale: 0.8)
        }, completion: nil)
    }
    
    private func getThumbnailImage(withScale: CGFloat) {
        let scale = withScale
        trackImage.transform = CGAffineTransform(scaleX: scale,
                                                 y: scale)
    }
    
    //MARK: - Setup gestures:
    private func setupGestures() {
        
        miniPlayerView.addGestureRecognizer(
            UITapGestureRecognizer(target: self,
                                   action: #selector(handleTapMaximized))
        )
        miniPlayerView.addGestureRecognizer(
            UIPanGestureRecognizer(target: self,
                                   action: #selector(handlePanMaximized))
        )
        addGestureRecognizer(
            UIPanGestureRecognizer(target: self,
                                   action: #selector(handlePanMinimized))
        )
    }
    
    @objc private func handleTapMaximized() {
        self.tabBarDelegate?.setMaximizedTrackDetailView(cellViewModel: nil)
    }
    
    @objc private func handlePanMinimized(gesture: UIPanGestureRecognizer) {
        switch gesture.state {
        case .changed:
            handlePanChangedToMinimize(gesture: gesture)
        case .ended:
            handlePanEndedToMinimize(gesture: gesture)
        default:
            print("Default gesture")
        }
    }
    
    @objc private func handlePanMaximized(gesture: UIPanGestureRecognizer) {
        switch gesture.state {
        case .changed:
            handlePanChangedToMazimize(gesture: gesture)
        case .ended:
            handlePanEnded(gesture: gesture)
        default:
            break
        }
    }
    
    private func handlePanChangedToMazimize(gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: self)
        transform = CGAffineTransform(translationX: 0,
                                      y: translation.y)
        
        let newAlpha = 1 + translation.y / 200
        miniPlayerView.alpha = newAlpha < 0 ? 0 : newAlpha
        mainStackView.alpha = -translation.y / 200
    }
    
    private func handlePanEnded(gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: self)
        let velocity = gesture.velocity(in: self)
        
        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       usingSpringWithDamping: 0.7,
                       initialSpringVelocity: 1,
                       options: .curveEaseOut,
                       animations: {
                        self.transform = .identity
                        if translation.y < -200 || velocity.y < -500 {
                            self.tabBarDelegate?.setMaximizedTrackDetailView(
                                cellViewModel: nil
                            )
                        } else {
                            self.tabBarDelegate?.setMinimizedTrackDetailView()
                        }
        }, completion: nil)
    }
    
    private func handlePanChangedToMinimize(gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: self)
        transform = CGAffineTransform(translationX: 0,
                                      y: translation.y)
        
    }
    
    private func handlePanEndedToMinimize(gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: self)
        
        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       usingSpringWithDamping: 0.7,
                       initialSpringVelocity: 1,
                       options: .curveEaseOut,
                       animations: {
                        self.transform = .identity
                        if translation.y > 100 {
                            self.transform = .identity
                            self.tabBarDelegate?.setMinimizedTrackDetailView()
                        }
        }, completion: nil)
    }
    
    //MARK: - Targets UI elements:
    private func addTargets() {
        miniPlayPauseButton.addTarget(self,
                                      action: #selector(playPauseButtonTapped),
                                      for: .touchUpInside)
        miniNextTrackButton.addTarget(self,
                                      action: #selector(nextTrackButtonTapped),
                                      for: .touchUpInside)
        dragDownButton.addTarget(self,
                                 action: #selector(dragDownButtonTapped),
                                 for: .touchUpInside)
        playPauseButton.addTarget(self,
                                  action: #selector(playPauseButtonTapped),
                                  for: .touchUpInside)
        currentTimeSlider.addTarget(self,
                                    action: #selector(handleCurrentTimeSlider),
                                    for: .valueChanged)
        volumeSlider.addTarget(self,
                               action: #selector(handleVolumeSlider),
                               for: .valueChanged)
        previousTrackButton.addTarget(self,
                                      action: #selector(previousTrackButtonTapped),
                                      for: .touchUpInside)
        nextTrackButton.addTarget(self,
                                  action: #selector(nextTrackButtonTapped),
                                  for: .touchUpInside)
    }
    
    @objc private func dragDownButtonTapped() {
        tabBarDelegate?.setMinimizedTrackDetailView()
    }
    
    @objc private func handleCurrentTimeSlider() {
        let percentage = currentTimeSlider.value
        guard let duration =
            avPlayer.player.currentItem?.duration else { return }
        let durationInSeconds = CMTimeGetSeconds(duration)
        let seekTimeSeconds = Float64(percentage) * durationInSeconds
        let seekTime = CMTimeMakeWithSeconds(seekTimeSeconds,
                                             preferredTimescale: 1)
        avPlayer.player.seek(to: seekTime)
    }
    
    @objc private func handleVolumeSlider() {
        avPlayer.player.volume = volumeSlider.value
    }
    
    @objc private func previousTrackButtonTapped() {
        guard let previousTrack =
            trackMovingDelegate?.moveBackForPreviousTrack() else { return }
        set(cellViewModel: previousTrack)
    }
    
    @objc private func nextTrackButtonTapped() {
        guard let nextTrack =
            trackMovingDelegate?.moveForwardForNextTrack() else { return }
        set(cellViewModel: nextTrack)
    }
    
    @objc private func playPauseButtonTapped() {
        if avPlayer.player.timeControlStatus == .paused {
            avPlayer.player.play()
            miniPlayPauseButton.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
            playPauseButton.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
            enlargeTrackImage()
        } else {
            avPlayer.player.pause()
            miniPlayPauseButton.setImage(#imageLiteral(resourceName: "play"), for: .normal)
            playPauseButton.setImage(#imageLiteral(resourceName: "play"), for: .normal)
            reduceTrackImage()
        }
    }
    
    //MARK: - SetupAutoLayout:
    private func setupSubviews() {
        backgroundColor = .white
        addSubview(miniPlayerView)
        addSubview(mainStackView)
        
        miniPlayPauseButton.imageEdgeInsets =
            UIEdgeInsets(top: 11,
                         left: 11,
                         bottom: 11,
                         right: 11)
    }
    
    private func autoLayoutMiniPlayerView() {
        miniPlayerView.addSubview(topLineMiniPlayerView)
        miniPlayerView.addSubview(miniPlayerStackView)
        miniPlayerStackView.addArrangedSubview(miniTrackImage)
        miniPlayerStackView.addArrangedSubview(miniTrackNameLabel)
        miniPlayerStackView.addArrangedSubview(miniPlayPauseButton)
        miniPlayerStackView.addArrangedSubview(miniNextTrackButton)
        
        NSLayoutConstraint.activate([
            miniPlayerView.topAnchor.constraint(equalTo: topAnchor,
                                                constant: 0),
            miniPlayerView.leadingAnchor.constraint(equalTo: leadingAnchor,
                                                    constant: 0),
            miniPlayerView.trailingAnchor.constraint(equalTo: trailingAnchor,
                                                     constant: 0),
            miniPlayerView.heightAnchor.constraint(equalToConstant: 64),
            
            topLineMiniPlayerView.topAnchor.constraint(
                equalTo: miniPlayerView.topAnchor,
                constant: 0
            ),
            topLineMiniPlayerView.leadingAnchor.constraint(
                equalTo: miniPlayerView.leadingAnchor,
                constant: 0
            ),
            topLineMiniPlayerView.trailingAnchor.constraint(
                equalTo: miniPlayerView.trailingAnchor,
                constant: 0
            ),
            topLineMiniPlayerView.heightAnchor.constraint(equalToConstant: 1),
            
            miniPlayerStackView.topAnchor.constraint(
                equalTo: miniPlayerView.topAnchor,
                constant: 8
            ),
            miniPlayerStackView.bottomAnchor.constraint(
                equalTo: miniPlayerView.bottomAnchor,
                constant: -8
            ),
            miniPlayerStackView.leadingAnchor.constraint(
                equalTo: miniPlayerView.leadingAnchor,
                constant: 8
            ),
            miniPlayerStackView.trailingAnchor.constraint(
                equalTo: miniPlayerView.trailingAnchor,
                constant: -8
            ),
            
            miniTrackImage.widthAnchor.constraint(equalToConstant: 48),
            miniPlayPauseButton.widthAnchor.constraint(equalToConstant: 48),
            miniNextTrackButton.widthAnchor.constraint(equalToConstant: 48)
        ])
    }
    
    private func autoLayoutMainStackView() {
        mainStackView.addArrangedSubview(dragDownButton)
        mainStackView.addArrangedSubview(trackImage)
        
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(
                equalTo: safeAreaLayoutGuide.topAnchor,
                constant: 0
            ),
            mainStackView.bottomAnchor.constraint(
                equalTo: safeAreaLayoutGuide.bottomAnchor,
                constant: -30
            ),
            mainStackView.leadingAnchor.constraint(
                equalTo: safeAreaLayoutGuide.leadingAnchor,
                constant: 30
            ),
            mainStackView.trailingAnchor.constraint(
                equalTo: safeAreaLayoutGuide.trailingAnchor,
                constant: -30
            ),
            
            dragDownButton.heightAnchor.constraint(equalToConstant: 40),
            trackImage.widthAnchor.constraint(
                equalTo: trackImage.heightAnchor,
                multiplier: (1.0 / 1.0)
            )
        ])
        
        autoLayoutTrackTimeStackView()
        autoLayoutLabelsOfTimeStackView()
        autoLayoutTrackNameStackView()
        autoLayoutMusicButtonsStackView()
        autoLayoutVolumeStackView()
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
        musicButtonsStackView.addArrangedSubview(playPauseButton)
        musicButtonsStackView.addArrangedSubview(nextTrackButton)
    }
    
    private func autoLayoutVolumeStackView() {
        mainStackView.addArrangedSubview(volumeStackView)
        volumeStackView.addArrangedSubview(lowSoundImage)
        volumeStackView.addArrangedSubview(volumeSlider)
        volumeStackView.addArrangedSubview(loudSoundImage)
        
        NSLayoutConstraint.activate([
            lowSoundImage.heightAnchor.constraint(equalToConstant: 17),
            lowSoundImage.widthAnchor.constraint(
                equalTo: lowSoundImage.heightAnchor,
                multiplier: 1.0 / 1.0
            ),
            loudSoundImage.heightAnchor.constraint(equalToConstant: 17),
            loudSoundImage.widthAnchor.constraint(
                equalTo: loudSoundImage.heightAnchor,
                multiplier: 1.0 / 1.0
            )
        ])
    }
}
