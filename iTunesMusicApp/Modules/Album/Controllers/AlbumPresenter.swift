//
//  AlbumPresenter.swift
//  iTunesMusicApp
//
//  Created by Артём Устинов on 27.12.2020.
//  Copyright (c) 2020 Artem Ustinov. All rights reserved.
//

import UIKit

protocol AlbumPresentationLogic {
  func presentData(response: SelectedAlbum.Model.Response.ResponseType)
}

class AlbumPresenter: AlbumPresentationLogic {
  weak var viewController: AlbumDisplayLogic?
  
  func presentData(response: SelectedAlbum.Model.Response.ResponseType) {
  
    switch response {
    case .presentAlbum(let resultAlbum):
        
        let tracks = resultAlbum?.map({ track in
            getTrackViewModel(for: track)
        })
        let tracksViewModel = TracksViewModel(tracks: tracks)
        viewController?.displayData(viewModel: SelectedAlbum.Model.ViewModel.ViewModelData.displayAlbumData(tracksViewModel: tracksViewModel))
    }
  }
    
    private func getTrackViewModel(for tracks: CurrentTrack?) -> TracksViewModel.Track {
        
        TracksViewModel.Track(artistName: tracks?.artistName,
                              albumName: tracks?.collectionName,
                              trackName: tracks?.trackName,
                              collectionId: tracks?.collectionId,
                              coverUrlString: tracks?.albumPicture,
                              priceOfTrack: tracks?.trackPrice,
                              priceOfAlbum: tracks?.collectionPrice,
                              currency: tracks?.currency)
    }
  
}
