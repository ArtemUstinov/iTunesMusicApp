//
//  SearchResponseModel.swift
//  iTunesMusicApp
//
//  Created by Артём Устинов on 24.12.2020.
//  Copyright © 2020 Artem Ustinov. All rights reserved.
//

struct SearchModel<T: Decodable>: Decodable {
    let resultCount: Int?
    let  results: [T]?
}

