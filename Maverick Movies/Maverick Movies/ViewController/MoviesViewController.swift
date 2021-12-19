//
//  ViewController.swift
//  Maverick Movies
//
//  Created by Vasanth Kumar on 17/12/21.
//

import UIKit

class MoviesViewController: UICollectionViewController {
    private let itemsPerRow: CGFloat = 2
    private let sectionInsets = UIEdgeInsets(
        top: 10.0,
        left: 10.0,
        bottom: 10.0,
        right: 10.0)
    
    let moviesListViewModel = MoviesListViewModel(movieStore: MovieNetworkManager())
    var movies: [Movie] = []
    private lazy var dataSource = makeDataSource()
    var isLoadingList = false
    
    enum Section {
        case main
    }
    
    typealias DataSource = UICollectionViewDiffableDataSource<Section, Movie>
    typealias SnapShot = NSDiffableDataSourceSnapshot<Section, Movie>
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
        registerCell()
        moviesListViewModel.resetStore()
        imageCache = NSCache<NSString, UIImage>()
        fetchMovies()
        applySnapshot()
    }
    
    private final func registerCell() {
        collectionView.register(UINib(nibName: LoadingFooterView.identifier, bundle: nil), forSupplementaryViewOfKind: "someKind", withReuseIdentifier: LoadingFooterView.identifier)
    }
    
    func makeDataSource() -> DataSource {
        let dataSource = DataSource(collectionView: collectionView) { collectionView, indexPath, movie in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieCollectionViewCell.identifier, for: indexPath) as? MovieCollectionViewCell
            if let poster = movie.poster {
                cell?.setDetails(imageURLString: poster)
            }
            return cell
        }
        
        dataSource.supplementaryViewProvider = { (collectionView: UICollectionView, kind: String, indexPath: IndexPath) -> UICollectionReusableView? in
            // Get a supplementary view of the desired kind.
            guard let footer = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: LoadingFooterView.identifier,
                for: indexPath) as? LoadingFooterView else { fatalError("Cannot create new footer") }
            return footer
        }
        
        return dataSource
    }
    
    func applySnapshot(animatingDifferences: Bool = true) {
        var snapshot = SnapShot()
        snapshot.appendSections([.main])
        snapshot.appendItems(movies)
        dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
    }
    
    private final func fetchMovies() {
        self.isLoadingList = true
        moviesListViewModel.fetchMovies(for: "Marvel") { movies, error in
            self.isLoadingList = false
            if let movies = movies {
                self.movies = movies
                print(movies)
                DispatchQueue.main.async {
                    self.applySnapshot()
                }
            } else if let error = error {
                print(error)
            }
        }
    }
    
}

extension MoviesViewController {
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (((scrollView.contentOffset.y + scrollView.frame.size.height) > scrollView.contentSize.height ) && !isLoadingList){
            self.fetchMovies()
        }
    }
}

// MARK: - Collection View Flow Layout Delegate
extension MoviesViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        let aspectRatio = 1.278
        if indexPath.section == 0 {
            return CGSize(width: widthPerItem, height: widthPerItem * aspectRatio)
        } else {
            return CGSize(width: availableWidth, height: 60)
        }
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAt section: Int
    ) -> UIEdgeInsets {
        return sectionInsets
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int
    ) -> CGFloat {
        return sectionInsets.left
    }
}
