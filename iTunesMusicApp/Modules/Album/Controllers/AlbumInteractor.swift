//
//  AlbumInteractor.swift
//  iTunesMusicApp
//
//  Created by Артём Устинов on 27.12.2020.
//  Copyright (c) 2020 Artem Ustinov. All rights reserved.
//

import UIKit

protocol AlbumBusinessLogic {
  func makeRequest(request: Album.Model.Request.RequestType)
}

class AlbumInteractor: AlbumBusinessLogic {

  var presenter: AlbumPresentationLogic?
  var service: AlbumService?
  
  func makeRequest(request: Album.Model.Request.RequestType) {
    if service == nil {
      service = AlbumService()
    }
  }
  
}
