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
        case getAlbums(searchText: String)
      }
    }
    struct Response {
      enum ResponseType {
        case some
        case presentAlbums(resultAlbums: [Album]?)
      }
    }
    struct ViewModel {
      enum ViewModelData {
        case some
        case displayAlbums(searchViewModel: SearchViewModel)
      }
    }
  }
}

struct SearchViewModel {
    struct Cell {
        let coverUrlString: String?
    }
    
    let cells: [Cell]?
}
