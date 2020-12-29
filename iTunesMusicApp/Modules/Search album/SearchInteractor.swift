//
//  SearchInteractor.swift
//  iTunesMusicApp
//
//  Created by Артём Устинов on 25.12.2020.
//  Copyright (c) 2020 Artem Ustinov. All rights reserved.
//

import UIKit

protocol SearchBusinessLogic {
    func makeRequest(request: Search.Model.Request.RequestType)
}

class SearchInteractor: SearchBusinessLogic {
    
    //MARK: - Public properties:
    var presenter: SearchPresentationLogic?
    var service: SearchService?
    
    //MARK: - Private properties:
    private let networkManager = NetworkManager()
    
    //MARK: - Public methods:
    func makeRequest(request: Search.Model.Request.RequestType) {
        if service == nil{
            service = SearchService()
        }
        
        switch request {
        case .getSearchData(let searchText):
            presenter?.presentData(response: Search.Model.Response.ResponseType.presentFooterView)
            self.presentSearchData(with: searchText)
        }
    }
    
    //MARK: - Private methods:
    private func presentSearchData(with text: String) {
        networkManager.fetchSearchData(search: text) {
            [weak self] resultData in
            switch resultData {
            
            case .success(let searchResult):
                self?.presenter?.presentData(response: Search.Model.Response.ResponseType.presentSearchData(resultSearch: searchResult))
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
