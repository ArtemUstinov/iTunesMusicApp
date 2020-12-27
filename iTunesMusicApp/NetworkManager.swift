//
//  NetworkManager.swift
//  iTunesMusicApp
//
//  Created by Артём Устинов on 24.12.2020.
//  Copyright © 2020 Artem Ustinov. All rights reserved.
//

import Foundation

class NetworkManager {
    
    private enum ApiUrl {
        static let search =
        "https://itunes.apple.com/search?term=%@&entity=album&sorted=recent"
        static let album =
        "https://itunes.apple.com/lookup?id=%@&entity=song&limit=200"
    }

    func fetchSearchData(search text: String,
                         completion: @escaping(Result<[Album]?, Error>) -> Void) {
        
        let urlString = String(format: ApiUrl.search, text)

        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, _, error) in
            if let error = error {
                completion(.failure(error))
                print(error.localizedDescription)
                return
            }
            guard let data = data else { return }
            
            do {
                let albums = try JSONDecoder().decode(SearchModel<Album>.self,
                                                      from: data)
                completion(.success(albums.results))
            } catch let error {
                //completion Error
                print(error.localizedDescription)
            }
        }.resume()
    }
    
    func fetchDataAlbum(id album: Int?,
                         completion: @escaping(Result<[Track]?, Error>) -> Void) {
        
        let urlString = String(format: ApiUrl.album, String(album ?? 0))

        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, _, error) in
            if let error = error {
                completion(.failure(error))
                print(error.localizedDescription)
                return
            }
            guard let data = data else { return }
            
            do {
                let album = try JSONDecoder().decode(SearchModel<Track>.self,
                                                      from: data)
                completion(.success(album.results))
            } catch let error {
                //completion Error
                print(error.localizedDescription)
            }
        }.resume()
    }
    
    func fetchImageData(from url: URL, completion: @escaping(Data, URLResponse) -> Void) {
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                //Completion with Result failure
                print(error.localizedDescription)
                return
            }
            guard let data = data, let response = response else {
                //completiom with Result failure
                print(error?.localizedDescription ?? "No error description")
                return }
            completion(data, response)
        }.resume()
    }
}
