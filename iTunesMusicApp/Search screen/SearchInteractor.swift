//
//  SearchInteractor.swift
//  iTunesMusicApp
//
//  Created by Артём Устинов on 25.12.2020.
//  Copyright (c) 2020 Artem Ustinov. All rights reserved.
//

import UIKit

//MARK: - Protocols
protocol SearchBusinessLogic {
    func makeRequest(request: Search.Model.Request.RequestType)
}

class SearchInteractor: SearchBusinessLogic {
    
    //MARK: - Properties:
    var presenter: SearchPresentationLogic?
    
    private let networkManager = NetworkManager()
    private let storageManager = StorageManager.shared
    
    //MARK: - Public methods:
    func makeRequest(request: Search.Model.Request.RequestType) {

        switch request {
        case .getSearchData(let searchText):
            presenter?.presentData(response:
                Search.Model.Response.ResponseType.presentFooterView)
            self.presentSearchData(with: searchText)
        case .getStorageData(let cell):
            storageManager.checkSavedTracks(for: cell) {
                [weak self] isFavouriteTrack in
                self?.presenter?.presentData(
                    response:
                    Search.Model.Response.ResponseType.presentStorageData(
                        isFavourite: isFavouriteTrack
                    )
                )
            }
        case .saveTrack(let track):
            StorageManager.shared.saveTrack(track: track)
        }
    }
    
    //MARK: - Private methods:
    private func presentSearchData(with text: String) {
        networkManager.fetchSearchData(search: text) {
            [weak self] resultData in
            switch resultData {
            case .success(let searchResult):
                self?.presenter?.presentData(
                    response:
                    Search.Model.Response.ResponseType.presentSearchData(
                        resultSearch: searchResult
                    )
                )
            case .failure(let error):
                self?.presenter?.presentData(
                    response:
                    Search.Model.Response.ResponseType.presentError(
                        error: error)
                )
                print(error.localizedDescription)
            }
        }
    }
}
