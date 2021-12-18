//
//  MoviesListViewModel.swift
//  Maverick Movies
//
//  Created by Vasanth Kumar on 17/12/21.
//

import Foundation

class MoviesListViewModel {
    var movieStore: MovieStore
    
    init(movieStore: MovieStore) {
        self.movieStore = movieStore
    }
    
    final func fetchMovies(for title: String, completion: @escaping (SearchResult?, MovieError?)->()) {
        movieStore.fetchMovies(with: title) { result, error in
            completion(result, error)
        }
    }
    
}
