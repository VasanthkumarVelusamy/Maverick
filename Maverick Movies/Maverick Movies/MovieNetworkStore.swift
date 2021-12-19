//
//  NetworkManager.swift
//  Maverick Movies
//
//  Created by Vasanth Kumar on 17/12/21.
//

import Foundation

protocol MovieNetworkStore {
    func fetchMovies(with name: String, page: Int, completion: @escaping (SearchResult?, MovieError?)->())
    func fetchMovieDetail(with imdbID: String, completion: @escaping (MovieDetail?, MovieError?)-> ())
}
