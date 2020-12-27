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
        case some
        case getSearchData(searchText: String)
      }
    }
    struct Response {
      enum ResponseType {
        case some
        case presentSearchData(resultSearch: [Album]?)
      }
    }
    struct ViewModel {
      enum ViewModelData {
        case some
        case displaySearchData(searchViewModel: CellSearchViewModel)
      }
    }
  }
}

struct CellSearchViewModel {
    struct Cell: SearchCellViewModel {
        let coverUrlString: String?
        let albumName: String?
        let artistName: String?
        let priceOfAlbum: Double?
        let collectionId: Int?
    } 
    
    let cells: [Cell]?
}

