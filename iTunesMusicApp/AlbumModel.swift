//
//  AlbumModel.swift
//  iTunesMusicApp
//
//  Created by Артём Устинов on 24.12.2020.
//  Copyright © 2020 Artem Ustinov. All rights reserved.
//

struct Album: Decodable {
    let wrapperType: String?
    let artistName: String?
    let collectionName: String?
    let collectionType: String?
    let collectionId: Int?
    let collectionPrice: Double?
    let albumPicture: String?
    
    enum CodingKeys: String, CodingKey {
        case wrapperType
        case artistName
        case collectionName
        case collectionType
        case collectionId
        case collectionPrice
        case albumPicture = "artworkUrl100"
    }
}
