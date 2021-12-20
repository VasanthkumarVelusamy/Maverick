//
//  MovieDetailsViewController.swift
//  Maverick Movies
//
//  Created by Vasanth Kumar on 19/12/21.
//

import UIKit

class MovieDetailsViewController: UIViewController {
    // MARK: - Outlets
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet private weak var contentView: UIView!
    @IBOutlet private weak var errorLabel: UILabel!
    @IBOutlet private weak var posterImageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var yearLabel: UILabel!
    @IBOutlet private weak var categoryLabel: UILabel!
    @IBOutlet private weak var durationLabel: UILabel!
    @IBOutlet private weak var imdbRatingLabel: UILabel!
    @IBOutlet private weak var synopsisLabel: UILabel!
    @IBOutlet private weak var scoreLabel: UILabel!
    @IBOutlet private weak var reviewsLabel: UILabel!
    @IBOutlet private weak var popularityLabel: UILabel!
    @IBOutlet private weak var directorLabel: UILabel!
    @IBOutlet private weak var writerLabel: UILabel!
    @IBOutlet private weak var actorsLabel: UILabel!
    
    // MARK: - Properties
    private var imdbID = ""
    private let movieDetailsViewModel = MovieDetailsViewModel(movieStore: MovieNetworkManager())

    // MARK: - Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Film Detail"
        getMovieDetails()
        navigationItem.largeTitleDisplayMode = .never
        showLoading()
    }
    
    // MARK: - Configurations
    private final func setupUIWithDetails() {
        guard let detail = movieDetailsViewModel.movieDetail else { return }
        
        if let poster = detail.poster {
            posterImageView.loadImageUsingCache(withUrl: poster)
        } else {
            posterImageView.image = UIImage(named: "noimage")
        }
        
        titleLabel.text = detail.title
        yearLabel.text = detail.year
        categoryLabel.text = detail.genre
        durationLabel.text = detail.runtime
        imdbRatingLabel.text = detail.imdbRating
        synopsisLabel.text = detail.plot
        scoreLabel.text = detail.imdbRating
        reviewsLabel.text = detail.imdbVotes
        popularityLabel.text = detail.metascore
        directorLabel.text = detail.director
        writerLabel.text = detail.writer
        actorsLabel.text = detail.actors
    }
    
    // MARK: - Utility Methods
    private final func showLoading() {
        activityIndicator.startAnimating()
        contentView.isHidden = true
    }
    
    private final func hideLoading(with error: String? = nil) {
        activityIndicator.stopAnimating()
        if let error = error {
            errorLabel.text = error
        } else {
            contentView.isHidden = false
        }
    }
    
    final func setDetails(imdbID: String, title: String) {
        self.imdbID = imdbID
    }
    
    // MARK: - API Request
    private final func getMovieDetails() {
        movieDetailsViewModel.fetchMovieDetail(with: imdbID) { success in
            if success {
                DispatchQueue.main.async {
                    self.hideLoading()
                    self.setupUIWithDetails()
                }
            }
        }
    }

}
