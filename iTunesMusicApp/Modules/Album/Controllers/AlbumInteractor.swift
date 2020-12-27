//
//  AlbumInteractor.swift
//  iTunesMusicApp
//
//  Created by Артём Устинов on 27.12.2020.
//  Copyright (c) 2020 Artem Ustinov. All rights reserved.
//

import UIKit

protocol AlbumBusinessLogic {
    func makeRequest(request: SelectedAlbum.Model.Request.RequestType)
}

class AlbumInteractor: AlbumBusinessLogic {
    
    var presenter: AlbumPresentationLogic?
    var service: AlbumService?
    
    private let networkManager = NetworkManager()
    
    func makeRequest(request: SelectedAlbum.Model.Request.RequestType) {
        if service == nil {
            service = AlbumService()
        }
        
        switch request {
        case .getAlbumInfo(let id):
            getAlbumData(with: id)
        }
    }
    
    private func getAlbumData(with id: Int) {
        networkManager.fetchDataAlbum(id: id) { [weak self] resultData in
            
            switch resultData {
            case .success(let album):
                self?.presenter?.presentData(response: SelectedAlbum.Model.Response.ResponseType.presentAlbum(resultAlbum: album))
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
}
