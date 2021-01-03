//
//  LibraryInteractor.swift
//  iTunesMusicApp
//
//  Created by Артём Устинов on 02.01.2021.
//  Copyright (c) 2021 Artem Ustinov. All rights reserved.
//

import UIKit

protocol LibraryBusinessLogic {
    func makeRequest(request: Library.Model.Request.RequestType)
}

class LibraryInteractor: LibraryBusinessLogic {
    
    var presenter: LibraryPresentationLogic?
    var service: LibraryService?
    
    func makeRequest(request: Library.Model.Request.RequestType) {
        if service == nil {
            service = LibraryService()
        }
    }
}
