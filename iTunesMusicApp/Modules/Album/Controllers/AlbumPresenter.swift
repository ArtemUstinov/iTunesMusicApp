//
//  AlbumPresenter.swift
//  iTunesMusicApp
//
//  Created by Артём Устинов on 27.12.2020.
//  Copyright (c) 2020 Artem Ustinov. All rights reserved.
//

import UIKit

protocol AlbumPresentationLogic {
  func presentData(response: Album.Model.Response.ResponseType)
}

class AlbumPresenter: AlbumPresentationLogic {
  weak var viewController: AlbumDisplayLogic?
  
  func presentData(response: Album.Model.Response.ResponseType) {
  
  }
  
}
