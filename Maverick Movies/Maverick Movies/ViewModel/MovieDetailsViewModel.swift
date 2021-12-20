//
//  MovieDetailViewModel.swift
//  Maverick Movies
//
//  Created by Vasanth Kumar on 17/12/21.
//

import Foundation

class MovieDetailsViewModel {
    
    private var movieStore: MovieNetworkStore
    
    var movieDetail: MovieDetail?
    
    init(movieStore: MovieNetworkStore) {
        self.movieStore = movieStore
    }
    
    func fetchMovieDetail(with imdbID: String, completion: @escaping (Bool)->()) {
        movieStore.fetchMovieDetail(with: imdbID) { movieDetail, error in
            self.movieDetail = movieDetail
            completion(movieDetail != nil)
        }
    }
}
