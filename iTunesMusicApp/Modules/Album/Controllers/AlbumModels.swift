//
//  AlbumModels.swift
//  iTunesMusicApp
//
//  Created by Артём Устинов on 27.12.2020.
//  Copyright (c) 2020 Artem Ustinov. All rights reserved.
//

import UIKit

enum SelectedAlbum {
   
  enum Model {
    struct Request {
      enum RequestType {
        case getAlbumInfo(albumId: Int)
      }
    }
    struct Response {
      enum ResponseType {
        case presentAlbum(resultAlbum: [CurrentTrack]?)
      }
    }
    struct ViewModel {
      enum ViewModelData {
        case displayAlbumData(tracksViewModel: TracksViewModel)
      }
    }
  }
}

struct TracksViewModel {
    struct Track {
        let artistName: String?
        let albumName: String?
        let trackName: String?
        let collectionId: Int?
        let coverUrlString: String?
        let priceOfTrack: Double?
        let priceOfAlbum: Double?
        let currency: String?
    }
    
    let tracks: [Track]?
}

