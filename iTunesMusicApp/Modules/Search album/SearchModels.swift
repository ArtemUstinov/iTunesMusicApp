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
      }
    }
    struct Response {
      enum ResponseType {
        case presentFooterView
        case presentSearchData(resultSearch: [Track]?)
      }
    }
    struct ViewModel {
      enum ViewModelData {
        case displayFooterView
        case displaySearchData(searchViewModel: CellSearchViewModel)
      }
    }
  }
}

struct CellSearchViewModel {
    struct Cell: SearchCellViewModel {
        let artistName: String?
        let albumName: String?
        let trackName: String?
        let previewUrl: String?
        let trackPicture: String?
        let trackPrice: Double?
        let currency: String?
    }
    
    let cells: [Cell]?
}

