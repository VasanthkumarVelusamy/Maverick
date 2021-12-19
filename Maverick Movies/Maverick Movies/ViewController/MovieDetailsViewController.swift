//
//  MovieDetailsViewController.swift
//  Maverick Movies
//
//  Created by Vasanth Kumar on 19/12/21.
//

import UIKit

class MovieDetailsViewController: UIViewController {
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var imdbRatingLabel: UILabel!
    @IBOutlet weak var synopsisLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var reviewsLabel: UILabel!
    @IBOutlet weak var popularityLabel: UILabel!
    @IBOutlet weak var directorLabel: UILabel!
    @IBOutlet weak var writerLabel: UILabel!
    @IBOutlet weak var actorsLabel: UILabel!
    
    private var imdbID = ""
    let movieDetailsViewModel = MovieDetailsViewModel(movieStore: MovieNetworkManager())

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Film Detail"
        getMovieDetails()
        navigationItem.largeTitleDisplayMode = .never
        showLoading()
    }
    
    private final func showLoading() {
        activityIndicator.startAnimating()
        contentView.isHidden = true
    }
    
    private final func hideLoading(with error: String? = nil) {
        activityIndicator.stopAnimating()
        if let error = error {
//            contentView.isHidden = true
            errorLabel.text = error
        } else {
            contentView.isHidden = false
        }
    }
    
    final func setDetails(imdbID: String, title: String) {
        self.imdbID = imdbID
    }
    
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

}
