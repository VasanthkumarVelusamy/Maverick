//
//  NetworkManager.swift
//  Maverick Movies
//
//  Created by Vasanth Kumar on 17/12/21.
//

import Foundation

struct MovieNetworkManager: MovieStore {
    
    func fetchMovies(with name: String, completion: @escaping (SearchResult?, MovieError?)->()) {
        NetworkLayer.request(router: .fetchMovies, queryItems: getParam(for: name)) { (result: Result<SearchResult, Error>) in
            print(result)
        }
    }
}

extension MovieNetworkManager {
    func getParam(for title: String) -> [URLQueryItem] {
        [
            URLQueryItem(name: "apikey", value: AppConstants.APIKey.rawValue),
            URLQueryItem(name: "s", value: title),
            URLQueryItem(name: "type", value: AppConstants.movie.rawValue),
        ]
    }
}
