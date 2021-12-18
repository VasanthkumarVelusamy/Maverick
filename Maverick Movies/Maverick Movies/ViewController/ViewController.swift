//
//  ViewController.swift
//  Maverick Movies
//
//  Created by Vasanth Kumar on 17/12/21.
//

import UIKit

class ViewController: UIViewController {
    let moviesListViewModel = MoviesListViewModel(movieStore: MovieNetworkManager())

    override func viewDidLoad() {
        super.viewDidLoad()
        moviesListViewModel.fetchMovies(for: "Marvel") { movies, error in
            if let movies = movies {
                print(movies)
            } else if let error = error {
                print(error)
            }
        }
    }
}
