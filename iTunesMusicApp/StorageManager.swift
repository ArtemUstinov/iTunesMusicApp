//
//  StorageManager.swift
//  iTunesMusicApp
//
//  Created by Артём Устинов on 02.01.2021.
//  Copyright © 2021 Artem Ustinov. All rights reserved.
//

import Foundation

class StorageManager {
    
    static let shared = StorageManager()
    
    private init() {}
    
    //MARK: - Private properties:
    private let userDefaults = UserDefaults.standard
    private let trackKey = "TrackKey"
    
    //MARK: - Public methods:
    func fetchTracks() -> [CellSearchViewModel.Cell] {
        
        guard let data =
            UserDefaults.standard.object(forKey: trackKey)
                as? Data else { return [] }
        guard let tracks =
            try? JSONDecoder().decode([CellSearchViewModel.Cell].self,
                                      from: data) else { return [] }
        return tracks
    }
    
    func saveTrack(track: CellSearchViewModel.Cell?) {
        
        guard let track = track else { return }
        var tracks = fetchTracks()
        tracks.append(track)
        guard let data = try? JSONEncoder().encode(tracks) else { return }
        userDefaults.set(data, forKey: trackKey)
    }
    
    func deleteTrack(at index: Int) {
        var tracks = fetchTracks()
        tracks.remove(at: index)
        guard let data = try? JSONEncoder().encode(tracks) else { return }
        userDefaults.set(data, forKey: trackKey)
    }
}
