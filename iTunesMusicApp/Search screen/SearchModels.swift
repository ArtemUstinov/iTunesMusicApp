//
//  SearchModels.swift
//  iTunesMusicApp
//
//  Created by Артём Устинов on 25.12.2020.
//  Copyright (c) 2020 Artem Ustinov. All rights reserved.
//

import UIKit

enum Search {
    
    enum Model {
        struct Request {
            enum RequestType {
                case getSearchData(searchText: String)
                case getStorageData(forCell: CellSearchModel.Cell)
                case saveTrack(track: CellSearchModel.Cell?)
            }
        }
        struct Response {
            enum ResponseType {
                case presentFooterView
                case presentSearchData(resultSearch: [Track]?)
                case presentError(error: Error)
                case presentStorageData(isFavourite: Bool)
            }
        }
        struct ViewModel {
            enum ViewModelData {
                case displayFooterView
                case displaySearchData(searchViewModel: CellSearchModel)
                case displayError(error: Error)
                case displayFavouriteTrack(isFavourite: Bool)
            }
        }
    }
}

struct CellSearchModel: Codable {
    struct Cell: Codable {
        let trackId: Int?
        let artistName: String?
        let albumName: String?
        let trackName: String?
        let previewUrl: String?
        let trackPicture: String?
    }
    let cells: [Cell]?
}

