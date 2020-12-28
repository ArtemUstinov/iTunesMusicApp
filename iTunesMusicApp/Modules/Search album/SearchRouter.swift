//
//  SearchRouter.swift
//  iTunesMusicApp
//
//  Created by Артём Устинов on 25.12.2020.
//  Copyright (c) 2020 Artem Ustinov. All rights reserved.
//

import UIKit

protocol SearchRoutingLogic {
    func presentAlbumViewController(albumId: Int)
}

class SearchRouter: SearchRoutingLogic {

  weak var viewController: SearchViewController?
  
  // MARK: Routing
    public func presentAlbumViewController(albumId: Int) {

        let vc = AlbumViewController(idAlbum: albumId)
        viewController?.present(vc, animated: true)
    }
}
