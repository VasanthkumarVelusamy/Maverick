//
//  MovieCollectionViewCell.swift
//  Maverick Movies
//
//  Created by Vasanth Kumar on 18/12/21.
//

import UIKit

class MovieCollectionViewCell: UICollectionViewCell {
    @IBOutlet private weak var imageView: UIImageView!
    static let identifier = "MovieCell"
    func setDetails(imageURLString: String) {
        imageView.loadImageUsingCache(withUrl: imageURLString)
    }
}
