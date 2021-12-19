//
//  NetworkManager.swift
//  Maverick Movies
//
//  Created by Vasanth Kumar on 17/12/21.
//

import Foundation

struct MovieNetworkManager: MovieNetworkStore {
    
    func fetchMovies(with name: String, page: Int, completion: @escaping (SearchResult?, MovieError?) -> ()) {
        NetworkLayer.request(router: .fetchMovies, queryItems: getParam(for: name, page: page)) { (result: Result<SearchResult, Error>) in
            switch result {
            case .success(let searchResult):
                completion(searchResult, nil)
            case .failure(_):
                completion(nil, MovieError.unknown(AppConstants.defaultError.rawValue))
            }
        }
    }
    
//    func fetchMovies(with name: String, completion: @escaping (SearchResult?, MovieError?)->()) {
//        NetworkLayer.request(router: .fetchMovies, queryItems: getParam(for: name)) { (result: Result<SearchResult, Error>) in
//            switch result {
//            case .success(let searchResult):
//                completion(searchResult, nil)
//            case .failure(_):
//                completion(nil, MovieError.unknown(AppConstants.defaultError.rawValue))
//            }
//        }
//    }
}

extension MovieNetworkManager {
    func getParam(for title: String, page: Int) -> [URLQueryItem] {
        [
            URLQueryItem(name: "apikey", value: AppConstants.APIKey.rawValue),
            URLQueryItem(name: "s", value: title),
            URLQueryItem(name: "type", value: AppConstants.movie.rawValue),
            URLQueryItem(name: "page", value: "\(page)")
        ]
    }
}
