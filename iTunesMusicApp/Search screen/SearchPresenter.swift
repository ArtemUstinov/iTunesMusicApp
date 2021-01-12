//
//  SearchPresenter.swift
//  iTunesMusicApp
//
//  Created by Артём Устинов on 25.12.2020.
//  Copyright (c) 2020 Artem Ustinov. All rights reserved.
//

import UIKit

//MARK: - Protocols
protocol SearchPresentationLogic {
    func presentData(response: Search.Model.Response.ResponseType)
}

class SearchPresenter: SearchPresentationLogic {
    
    //MARK: Properties:
    weak var viewController: SearchDisplayLogic?
    let alertController = AlertController()
    
    //MARK: - Public methods:
    func presentData(response: Search.Model.Response.ResponseType) {
        
        switch response {
        case .presentFooterView:
            viewController?.displayData(viewModel:
                Search.Model.ViewModel.ViewModelData.displayFooterView)
        case .presentSearchData(let resultTracks):
            let track = resultTracks?.map({ track in
                getCellSearchModel(from: track)
            })
            let searchViewModel = CellSearchModel(cells: track)
            viewController?.displayData(viewModel:
                Search.Model.ViewModel.ViewModelData.displaySearchData(
                    searchViewModel: searchViewModel
                )
            )
        case .presentError(let error):
            viewController?.displayData(viewModel:
                Search.Model.ViewModel.ViewModelData.displayError(
                    error: error
                )
            )
        case .presentStorageData(let isFavourite):
            viewController?.displayData(viewModel:
                Search.Model.ViewModel.ViewModelData.displayFavouriteTrack(
                    isFavourite: isFavourite)
            )
        }
    }
    
    //MARK: - Private methods:
    private func getCellSearchModel(
        from track: Track?
    ) -> CellSearchModel.Cell {
        CellSearchModel.Cell(trackId: track?.trackId,
                             artistName: track?.artistName,
                             albumName: track?.collectionName,
                             trackName: track?.trackName,
                             previewUrl: track?.previewUrl,
                             trackPicture: track?.albumPicture)
    }
}
