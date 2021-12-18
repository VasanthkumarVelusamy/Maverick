//
//  NetworkManager.swift
//  Maverick Movies
//
//  Created by Vasanth Kumar on 17/12/21.
//

import Foundation

protocol MovieStore {
    func fetchMovies(with name: String, completion: @escaping (SearchResult?, MovieError?)->())
}
