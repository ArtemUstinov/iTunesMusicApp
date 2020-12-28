//
//  NetworkDefault.swift
//  iTunesMusicApp
//
//  Created by Дмитрий Константинов on 27.12.2020.
//  Copyright © 2020 Artem Ustinov. All rights reserved.
//

import Foundation

protocol NetworkDefault {
    func request<T: Decodable>(url: URL, completion: @escaping (Result<[T], Error>) -> Void)
    func requestData(from url: URL, completion: @escaping (Result<(Data, URLResponse), Error>) -> Void)
}

extension NetworkDefault {

    func request<T: Decodable>(url: URL, completion: @escaping (Result<[T], Error>) -> Void) {

        URLSession.shared.dataTask(with: url) { (data, _, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let data = data else {
                //completion with custom error
                completion(.success([]))
                return
            }

            do {
                let model = try JSONDecoder().decode(SearchModel<T>.self, from: data)
                completion(.success(model.results ?? []))
            } catch let error {
                completion(.failure(error))
            }
        }.resume()
    }

    func requestData(from url: URL, completion: @escaping (Result<(Data, URLResponse), Error>) -> Void) {

        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let data = data, let response = response else {
                //completiom with custom error
                print(error?.localizedDescription ?? "No error description")
                return }
            completion(.success((data, response)))
        }.resume()
    }
}
