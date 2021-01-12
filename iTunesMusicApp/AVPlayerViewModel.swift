//
//  AVPlayerViewModel.swift
//  iTunesMusicApp
//
//  Created by Артём Устинов on 11.01.2021.
//  Copyright © 2021 Artem Ustinov. All rights reserved.
//

import AVKit

class AVPlayerViewModel {
    
    static let shared = AVPlayerViewModel()
    private init() {}
    
    //MARK: - Public properties:
    let player: AVPlayer = {
        let avPlayer = AVPlayer()
        avPlayer.volume = 0.5
        avPlayer.automaticallyWaitsToMinimizeStalling = false
        return avPlayer
    }()
    
    //MARK: - Public methods:
    func playTrack(from previewUrlTrack: String?) {
        
        guard let url = URL(string: previewUrlTrack ?? "") else { return }
        let playerItem = AVPlayerItem(url: url)
        player.replaceCurrentItem(with: playerItem)
        player.play()
    }
    
    func monitorStartTimeTrack(completion: @escaping() -> Void) {
        
        let time = CMTimeMake(value: 1, timescale: 10)
        let times = [NSValue(time: time)]
        player.addBoundaryTimeObserver(forTimes: times,
                                       queue: .main) {
                                        completion()
        }
    }
    
    func observePlayerCurrentTime(
        completion: @escaping(CMTime, String) -> Void
    ) {
        let interval = CMTimeMake(value: 1, timescale: 10)
        player.addPeriodicTimeObserver(forInterval: interval, queue: .main) {
            [weak self] time in
            guard let durationTime = self?.player.currentItem?.duration else {
                return
            }
            let currentDurationTime = (durationTime - time).toDisplayString()
            completion(time, currentDurationTime)
        }
    }
    
    func updateCurrentTimeSlider() -> Float {
        
        let currentTimeSeconds = CMTimeGetSeconds(player.currentTime())
        let durationSeconds = CMTimeGetSeconds(player.currentItem?.duration
            ?? CMTimeMake(value: 1, timescale: 1))
        let percentage = currentTimeSeconds / durationSeconds
        return Float(percentage)
    }
}
