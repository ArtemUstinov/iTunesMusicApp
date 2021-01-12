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
        "https://itunes.apple.com/search?term=%@&media=music"
        static let album =
        "https://itunes.apple.com/lookup?id=%@&entity=song&limit=200"
    }
    
    //MARK: - Public methods:
    func fetchSearchData(
        search text: String,
        completion: @escaping(Result<[Track]?, Error>) -> Void
    ) {
        let string = String(format: ApiUrl.search, text)
        let urlString =
            string.split(separator: " ").joined(separator: "%20")
        
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, _, error) in
            if let error = error {
                completion(.failure(error))
                print(error.localizedDescription)
                return
            }
            guard let data = data else { return }
            
            do {
                let albums =
                    try JSONDecoder().decode(SearchModel<Track>.self,
                                             from: data)
                completion(.success(albums.results))
            } catch let error {
                print(error.localizedDescription)
            }
        }.resume()
    }
    
    func fetchImageData(
        from url: URL,
        completion: @escaping(Data, URLResponse) -> Void
    ) {
        URLSession.shared.dataTask(with: url) {
            (data, response, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            guard let data = data,
                let response = response else {
                    print(error?.localizedDescription ?? "Unknown error")
                    return }
            completion(data, response)
        }.resume()
    }
}
