//
//  TrackDetailView.swift
//  iTunesMusicApp
//
//  Created by Артём Устинов on 28.12.2020.
//  Copyright © 2020 Artem Ustinov. All rights reserved.
//

import UIKit
import AVKit

protocol TrackMovingDelegate: class {
    func moveBackForPreviousTrack() -> CellSearchViewModel.Cell?
    func moveForwardForNextTrack() -> CellSearchViewModel.Cell?
}

class TrackDetailView: UIView {
    
    //MARK: - Public properties:
    weak var trackMovingDelegate: TrackMovingDelegate?
    
    weak var tabBarDelegate: TabBarControllerDelegate?
    
    //MARK: - Private properties:
    private let avPlayer: AVPlayer = {
        let avPlayer = AVPlayer()
        avPlayer.volume = 0.5
        avPlayer.automaticallyWaitsToMinimizeStalling = false
        return avPlayer
    }()
    
    //MARK: - miniPlayerView
    private let topLineMiniPlayerView: UIView = {
        let view = UIView()
        view.alpha = 0.7
        view.backgroundColor = .opaqueSeparator
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let miniPlayerView: UIView = {
        let view = UIView()
        view.backgroundColor = .secondarySystemBackground
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let miniPlayerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.spacing = 16
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let miniTrackImage: CoverImageView = {
        let image = CoverImageView()
        image.contentMode = .scaleAspectFill
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    private let miniTrackNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Track"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let miniPlayPauseButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .darkText
        button.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 11,
                                              left: 11,
                                              bottom: 11,
                                              right: 11)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let miniNextTrackButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .darkText
        button.setImage(#imageLiteral(resourceName: "Right"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    //MARK: - StackViews
    let mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
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
    
    //MARK: - UIButtons
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
        let button = UIButton(type: .system)
        button.tintColor = .darkText
        button.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    //MARK: - UIImageViews
    private let trackImage: CoverImageView = {
        let image = CoverImageView()
        image.contentMode = .scaleAspectFill
        image.layer.cornerRadius = 10
        image.layer.masksToBounds = true
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
    
    //MARK: - UILabels
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
    
    //MARK: - UISliders
    private let currentTimeSlider: UISlider = {
        let slider = UISlider()
        slider.translatesAutoresizingMaskIntoConstraints = false
        return slider
    }()
    
    private let volumeSlider: UISlider = {
        let slider = UISlider()
        slider.value = 0.5
        slider.translatesAutoresizingMaskIntoConstraints = false
        return slider
    }()
    
    //MARK: - Override methods:
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        setupGestures()
        
        
        addTargets()
        
        monitorStartTimeTrack()
        observePlayerCurrentTime()
        
        setupSubview()
        autoLayoutMainStackView()
        autoLayoutMiniPlayerView()
        autoLayoutTrackTimeStackView()
        autoLayoutLabelsOfTimeStackView()
        autoLayoutTrackNameStackView()
        autoLayoutMusicButtonsStackView()
        autoLayoutVolumeStackView()
        
    }
    
    //MARK: - SetupUI
    func set(cellViewModel: CellSearchViewModel.Cell) {
        
        miniTrackNameLabel.text = cellViewModel.trackName
        miniTrackImage.fetchImage(from: cellViewModel.trackPicture ?? "")
        
        playPauseButton.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
        miniPlayPauseButton.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
        
        getThumbnailImage(withScale: 0.8)
        
        trackNameLabel.text = cellViewModel.trackName
        artistNameLabel.text = cellViewModel.artistName
        
        let convertImageSize =
            cellViewModel.trackPicture?.replacingOccurrences(of: "100x100",
                                                             with: "600x600")
        trackImage.fetchImage(from: convertImageSize ?? "")
        
        playTrack(from: cellViewModel.previewUrl)
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
        trackImage.transform = CGAffineTransform(scaleX: scale, y: scale)
    }
    
    //MARK: - Setup AVPlayer
    private func playTrack(from previewUrlTrack: String?) {
        
        guard let url = URL(string: previewUrlTrack ?? "") else { return }
        let playerItem = AVPlayerItem(url: url)
        avPlayer.replaceCurrentItem(with: playerItem)
        avPlayer.play()
    }
    
    private func monitorStartTimeTrack() {
        
        let time = CMTimeMake(value: 1, timescale: 10)
        let times = [NSValue(time: time)]
        avPlayer.addBoundaryTimeObserver(forTimes: times,
                                         queue: .main) { [weak self] in
                                            self?.enlargeTrackImage()
        }
    }
    
    private func observePlayerCurrentTime() {
        
        let interval = CMTimeMake(value: 1, timescale: 10)
        avPlayer.addPeriodicTimeObserver(forInterval: interval, queue: .main) {
            [weak self] time in
            self?.currentTimeLabel.text = time.toDisplayString()
            
            guard let durationTime = self?.avPlayer.currentItem?.duration else {
                return
            }
            let currentDurationTime = (durationTime - time).toDisplayString()
            self?.durationTimeLabel.text = "-\(currentDurationTime)"
            self?.updateCurrentTimeSlider()
        }
    }
    
    private func updateCurrentTimeSlider() {
        
        let currentTimeSeconds = CMTimeGetSeconds(avPlayer.currentTime())
        let durationSeconds = CMTimeGetSeconds(avPlayer.currentItem?.duration
            ?? CMTimeMake(value: 1, timescale: 1))
        let percentage = currentTimeSeconds / durationSeconds
        currentTimeSlider.value = Float(percentage)
    }
    
    //MARK: - Setup gestures
    private func setupGestures() {
        
        miniPlayerView.addGestureRecognizer(UITapGestureRecognizer(target: self,
                                                                   action: #selector(handleTapMaximized)))
        
        miniPlayerView.addGestureRecognizer(UIPanGestureRecognizer(target: self,
                                                                   action: #selector(handlePanMaximized)))
        
        addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handlePanMinimized)))
    }
    
    @objc private func handleTapMaximized() {
        self.tabBarDelegate?.setMaximizedTrackDetailView(cellViewModel: nil)
    }
    
    @objc private func handlePanMaximized(gesture: UIPanGestureRecognizer) {
        switch gesture.state {
        case .began:
            print("Began")
        case .changed:
            print("changed")
            handlePanChangedToMazimize(gesture: gesture)
        case .ended:
            print("ended")
            handlePanEnded(gesture: gesture)
        default:
            print("default")
        }
    }
    
    @objc private func handlePanMinimized(gesture: UIPanGestureRecognizer) {
        switch gesture.state {
        case .changed:
            handlePanChangedToMinimize(gesture: gesture)
        case .ended:
            handlePanEndedToMinimize(gesture: gesture)
        default:
            print("default")
        }
    }
    
    private func handlePanChangedToMazimize(gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: self)
        transform = CGAffineTransform(translationX: 0, y: translation.y)
        
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
                            self.tabBarDelegate?.setMaximizedTrackDetailView(cellViewModel: nil)
                        } else {
                            self.tabBarDelegate?.setMinimizedTrackDetailView()
                        }
        }, completion: nil)
    }
    
    private func handlePanChangedToMinimize(gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: self)
        transform = CGAffineTransform(translationX: 0, y: translation.y)
        
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
    
    //MARK: Targets
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
    
    //MARK: - @objc Actions
    @objc private func dragDownButtonTapped() {
        tabBarDelegate?.setMinimizedTrackDetailView()
        //        removeFromSuperview()
    }
    
    @objc private func handleCurrentTimeSlider() {
        let percentage = currentTimeSlider.value
        guard let duration = avPlayer.currentItem?.duration else { return }
        let durationInSeconds = CMTimeGetSeconds(duration)
        let seekTimeSeconds = Float64(percentage) * durationInSeconds
        let seekTime = CMTimeMakeWithSeconds(seekTimeSeconds,
                                             preferredTimescale: 1)
        avPlayer.seek(to: seekTime)
    }
    
    @objc private func handleVolumeSlider() {
        avPlayer.volume = volumeSlider.value
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
        if avPlayer.timeControlStatus == .paused {
            avPlayer.play()
            miniPlayPauseButton.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
            playPauseButton.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
            enlargeTrackImage()
        } else {
            avPlayer.pause()
            miniPlayPauseButton.setImage(#imageLiteral(resourceName: "play"), for: .normal)
            playPauseButton.setImage(#imageLiteral(resourceName: "play"), for: .normal)
            reduceTrackImage()
        }
    }
    
    //MARK: - SetupAutoLayout
    private func setupSubview() {
        backgroundColor = .white
        addSubview(miniPlayerView)
        addSubview(mainStackView)
    }
    
    private func autoLayoutMiniPlayerView() {
        NSLayoutConstraint.activate([
            miniPlayerView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor,
                                                constant: 0),
            miniPlayerView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor,
                                                    constant: 0),
            miniPlayerView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor,
                                                     constant: 0),
            miniPlayerView.heightAnchor.constraint(equalToConstant: 64)
        ])
        
        miniPlayerView.addSubview(topLineMiniPlayerView)
        NSLayoutConstraint.activate([
            topLineMiniPlayerView.topAnchor.constraint(equalTo: miniPlayerView.topAnchor,
                                                       constant: 0),
            topLineMiniPlayerView.leadingAnchor.constraint(equalTo: miniPlayerView.leadingAnchor,
                                                           constant: 0),
            topLineMiniPlayerView.trailingAnchor.constraint(equalTo: miniPlayerView.trailingAnchor,
                                                            constant: 0),
            topLineMiniPlayerView.heightAnchor.constraint(equalToConstant: 1)
        ])
        
        miniPlayerView.addSubview(miniPlayerStackView)
        NSLayoutConstraint.activate([
            miniPlayerStackView.topAnchor.constraint(equalTo: miniPlayerView.topAnchor,
                                                     constant: 8),
            miniPlayerStackView.bottomAnchor.constraint(equalTo: miniPlayerView.bottomAnchor,
                                                        constant: -8),
            miniPlayerStackView.leadingAnchor.constraint(equalTo: miniPlayerView.leadingAnchor,
                                                         constant: 8),
            miniPlayerStackView.trailingAnchor.constraint(equalTo: miniPlayerView.trailingAnchor,
                                                          constant: -8),
        ])
        
        miniPlayerStackView.addArrangedSubview(miniTrackImage)
        NSLayoutConstraint.activate([
            miniTrackImage.widthAnchor.constraint(equalToConstant: 48)
        ])
        
        miniPlayerStackView.addArrangedSubview(miniTrackNameLabel)
        NSLayoutConstraint.activate([
            
        ])
        
        miniPlayerStackView.addArrangedSubview(miniPlayPauseButton)
        NSLayoutConstraint.activate([
            miniPlayPauseButton.widthAnchor.constraint(equalToConstant: 48)
        ])
        
        miniPlayerStackView.addArrangedSubview(miniNextTrackButton)
        NSLayoutConstraint.activate([
            miniNextTrackButton.widthAnchor.constraint(equalToConstant: 48)
        ])
        
    }
    
    private func autoLayoutMainStackView() {
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor,
                                               constant: 0),
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
        musicButtonsStackView.addArrangedSubview(playPauseButton)
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
