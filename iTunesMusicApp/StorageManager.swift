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
    
    private enum Key: String {
        case trackKey = "TrackKey"
    }
    
    private let userDefaults = UserDefaults.standard
    
    //MARK: - Public methods:
    func fetchTracks() -> [CellSearchViewModel.Cell] {
        
        guard let data =
            UserDefaults.standard.object(forKey: Key.trackKey.rawValue)
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
        userDefaults.set(data, forKey: Key.trackKey.rawValue)
    }
    
    func deleteTrack(at index: Int) {
        var tracks = fetchTracks()
        tracks.remove(at: index)
        guard let data = try? JSONEncoder().encode(tracks) else { return }
        userDefaults.set(data, forKey: Key.trackKey.rawValue)
    }
    
    func checkSavedTracks(for viewModel: CellSearchViewModel.Cell?,
                          completion: @escaping (Bool) -> Void) {
        let tracks = fetchTracks()
        let isFavouriteTrack = tracks.first(where: {
            $0.trackId == viewModel?.trackId
        }) != nil
        completion(isFavouriteTrack)
    }
}
