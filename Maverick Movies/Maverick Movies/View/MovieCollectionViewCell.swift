//
//  MovieCollectionViewCell.swift
//  Maverick Movies
//
//  Created by Vasanth Kumar on 18/12/21.
//

import UIKit

class MovieCollectionViewCell: UICollectionViewCell {
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet weak var movieNameLabel: UILabel!
    
    static let identifier = "MovieCell"
    func setDetails(imageURLString: String, movietTitle: String) {
        movieNameLabel.text = ""
        imageView.loadImageUsingCache(withUrl: imageURLString) { success in
            if !success {
                DispatchQueue.main.async {
                    self.movieNameLabel.text = movietTitle
                }
            }
        }
    }
}
