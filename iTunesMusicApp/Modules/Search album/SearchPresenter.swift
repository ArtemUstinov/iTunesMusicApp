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
        case .some:
            print("Some...")
        case .presentAlbums(let resultAlbums):
            
            let albums = resultAlbums?.map({ album in
                getSearchViewModel(from: album)
            })
            let searchViewModel = SearchViewModel(cells: albums)
            viewController?.displayData(viewModel: Search.Model.ViewModel.ViewModelData.displayAlbums(searchViewModel: searchViewModel))
        }
    }
    
    //MARK: - Private methods:
    private func getSearchViewModel(from album: Album?) -> SearchViewModel.Cell {
        
        SearchViewModel.Cell(coverUrlString: album?.albumPicture)
    }
}
