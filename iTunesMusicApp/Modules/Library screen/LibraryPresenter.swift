//
//  LibraryPresenter.swift
//  iTunesMusicApp
//
//  Created by Артём Устинов on 02.01.2021.
//  Copyright (c) 2021 Artem Ustinov. All rights reserved.
//

import UIKit

protocol LibraryPresentationLogic {
    func presentData(response: Library.Model.Response.ResponseType)
}

class LibraryPresenter: LibraryPresentationLogic {
    
    weak var viewController: LibraryDisplayLogic?
    
    func presentData(response: Library.Model.Response.ResponseType) {
        
    }
}
