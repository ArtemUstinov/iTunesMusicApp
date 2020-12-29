//
//  TrackModel.swift
//  iTunesMusicApp
//
//  Created by Артём Устинов on 24.12.2020.
//  Copyright © 2020 Artem Ustinov. All rights reserved.
//

struct CurrentTrack: Decodable {
    let wrapperType: String?
    let artistName: String?
    let collectionName: String?
    let trackName: String?
    let collectionId: Int?
    let albumPicture: String?
    let trackPrice: Double?
    let collectionPrice: Double?
    let currency: String?
    
    enum CodingKeys: String, CodingKey {
        case wrapperType
        case artistName
        case collectionName
        case trackName
        case collectionId
        case albumPicture = "artworkUrl100"
        case trackPrice
        case collectionPrice
        case currency
    }
}
