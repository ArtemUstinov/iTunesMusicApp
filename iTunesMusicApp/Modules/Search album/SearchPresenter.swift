//
//  SearchPresenter.swift
//  iTunesMusicApp
//
//  Created by Артём Устинов on 25.12.2020.
//  Copyright (c) 2020 Artem Ustinov. All rights reserved.
//

import UIKit

protocol SearchPresentationLogic {
    func presentData(response: Search.Model.Response.ResponseType)
}

class SearchPresenter: SearchPresentationLogic {
    
    //MARK: - Public properties:
    weak var viewController: SearchDisplayLogic?
    
    //MARK: - Public methods:
    func presentData(response: Search.Model.Response.ResponseType) {
        
        switch response {
        case .presentFooterView:
            viewController?.displayData(viewModel: Search.Model.ViewModel.ViewModelData.displayFooterView)
        case .presentSearchData(let resultAlbums):
            
            let albums = resultAlbums?.map({ album in
                getSearchCellViewModel(from: album)
            })
            let searchViewModel = CellSearchViewModel(cells: albums)
            viewController?.displayData(viewModel: Search.Model.ViewModel.ViewModelData.displaySearchData(searchViewModel: searchViewModel))
        }
    }
    
    //MARK: - Private methods:
    private func getSearchCellViewModel(from album: Track?) -> CellSearchViewModel.Cell {
        
        CellSearchViewModel.Cell(coverUrlString: album?.albumPicture,
                                 albumName: album?.collectionName,
                                 artistName: album?.artistName,
                                 trackName: album?.trackName,
                                 trackPrice: album?.trackPrice,
                                 currency: album?.currency)
    }
}
