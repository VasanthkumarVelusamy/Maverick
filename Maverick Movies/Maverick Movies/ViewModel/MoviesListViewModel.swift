//
//  MoviesListViewModel.swift
//  Maverick Movies
//
//  Created by Vasanth Kumar on 17/12/21.
//

import Foundation

class MoviesListViewModel {
    private var movieStore: MovieNetworkStore
    var movies: [Movie] = []
    private var totalItems = Int.max
    private var page = 1
    
    init(movieStore: MovieNetworkStore) {
        self.movieStore = movieStore
    }
    
    func resetStore() {
        page = 1
        totalItems = Int.max
        movies.removeAll()
    }
    
    final func fetchMovies(for title: String, completion: @escaping ([Movie]?, MovieError?) -> ()) {
        guard totalItems > movies.count else {
            completion(movies, nil)
            return
        }
        let queue = DispatchQueue(label: "FetchMovies", qos: .userInitiated)
        
        queue.sync {
            self.movieStore.fetchMovies(with: title, page: self.page) { result, error in
                self.movies.append(contentsOf: result?.search ?? [])
                if let total = result?.totalResults {
                    if let totalResults = Int(total) {
                        self.totalItems =  totalResults
                    }
                }
                completion(self.movies, error)
            }
        }
        
        page += 1
    }
    
}
