//
//  NetworkManager.swift
//  Maverick Movies
//
//  Created by Vasanth Kumar on 17/12/21.
//

import Foundation

struct MovieNetworkManager: MovieNetworkStore {
    
    func fetchMovies(with name: String, page: Int, completion: @escaping (SearchResult?, MovieError?) -> ()) {
        NetworkLayer.request(router: .fetchMovies, queryItems: getParamForMoviesList(for: name, page: page)) { (result: Result<SearchResult, Error>) in
            switch result {
            case .success(let searchResult):
                completion(searchResult, nil)
            case .failure(_):
                completion(nil, MovieError.unknown(AppConstants.defaultError.rawValue))
            }
        }
    }
    
    func fetchMovieDetail(with imdbID: String, completion: @escaping (MovieDetail?, MovieError?)->()) {
        NetworkLayer.request(router: .fetchDetails, queryItems: getParamForMovieDetails(with: imdbID)) { (result: Result<MovieDetail, Error>) in
            switch result {
            case .success(let detail):
                completion(detail, nil)
            case .failure(let error):
                completion(nil, MovieError.unknown("Something went wrong. \(error.localizedDescription)"))
            }
        }
    }
}

extension MovieNetworkManager {
    func getParamForMoviesList(for title: String, page: Int) -> [URLQueryItem] {
        [
            URLQueryItem(name: "apikey", value: AppConstants.APIKey.rawValue),
            URLQueryItem(name: "s", value: title),
            URLQueryItem(name: "type", value: AppConstants.movie.rawValue),
            URLQueryItem(name: "page", value: "\(page)")
        ]
    }
    
    func getParamForMovieDetails(with imdbID: String) -> [URLQueryItem] {
        [URLQueryItem(name: "apikey", value: AppConstants.APIKey.rawValue),
         URLQueryItem(name: "i", value: imdbID)
        ]
    }
}
