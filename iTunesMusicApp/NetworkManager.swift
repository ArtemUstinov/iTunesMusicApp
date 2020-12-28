//
//  NetworkManager.swift
//  iTunesMusicApp
//
//  Created by Артём Устинов on 24.12.2020.
//  Copyright © 2020 Artem Ustinov. All rights reserved.
//

import Foundation

class NetworkManager: NetworkDefault {
    
    private enum ApiUrl {
        static let search =
        "https://itunes.apple.com/search?term=%@&entity=album&sorted=recent"
        static let album =
        "https://itunes.apple.com/lookup?id=%@&entity=song&limit=200"
    }

    func fetchSearchData(
        search text: String,
        completion: @escaping(Result<[Album], Error>) -> Void
    ) {
        let urlString = String(format: ApiUrl.search, text)
        guard let url = URL(string: urlString) else { return }

        request(url: url) { completion($0) }
    }
    
    func fetchDataAlbum(
        id album: Int?,
        completion: @escaping(Result<[Track], Error>) -> Void
    ) {
        let urlString = String(format: ApiUrl.album, String(album ?? 0))
        guard let url = URL(string: urlString) else { return }

        request(url: url) { completion($0) }
    }
    
    func fetchImageData(
        from url: URL,
        completion: @escaping (Result<(Data, URLResponse), Error>) -> Void
    ) {
        requestData(from: url, completion: { completion($0) })
    }
}
