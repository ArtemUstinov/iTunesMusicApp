//
//  AlbumModel.swift
//  iTunesMusicApp
//
//  Created by Артём Устинов on 24.12.2020.
//  Copyright © 2020 Artem Ustinov. All rights reserved.
//

struct Track: Decodable {
    let artistId: Int?
    let collectionId: Int?
    let trackId: Int?
    let artistName: String?
    let collectionName: String?
    let trackName: String?
    let previewUrl: String?
    let albumPicture: String?
    let trackPrice: Double?
    let currency: String?
    
    enum CodingKeys: String, CodingKey {
        case artistId
        case collectionId
        case trackId
        case artistName
        case collectionName
        case trackName
        case previewUrl
        case albumPicture = "artworkUrl100"
        case trackPrice
        case currency
    }
}
