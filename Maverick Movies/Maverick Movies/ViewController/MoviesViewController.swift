//
//  ViewController.swift
//  Maverick Movies
//
//  Created by Vasanth Kumar on 17/12/21.
//

import UIKit

class MoviesViewController: UICollectionViewController {
    // MARK: - Outlets
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    
    // MARK: - Properties
    private let itemsPerRow: CGFloat = 2
    private let moviesListViewModel = MoviesListViewModel(movieStore: MovieNetworkManager())
    private lazy var dataSource = makeDataSource()
    private var isLoadingList = false
    private var selectedRow: Int?
    private var searchText: String? = ""
    private let searchController = UISearchController(searchResultsController: nil)
    private var messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 300, height: 80))
    private let sectionInsets = UIEdgeInsets(
        top: 10.0,
        left: 10.0,
        bottom: 10.0,
        right: 10.0)
    
    enum Section {
        case main
    }
    
    typealias DataSource = UICollectionViewDiffableDataSource<Section, Movie>
    typealias SnapShot = NSDiffableDataSourceSnapshot<Section, Movie>
    
    // MARK: - Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
        registerCell()
        applySnapshot()
        setupSearchBar()
        setupMessageLabel()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let detailsVC = segue.destination as! MovieDetailsViewController
        if let row = selectedRow {
            let movie = moviesListViewModel.movies[row]
            if let imdbID = movie.imdbID,
               let title = movie.title {
                // Passing imdbID for making API request for movie detail. And passing title for using on top of "No image" picture when there is no poster available
                detailsVC.setDetails(imdbID: imdbID, title: title)
            }
        }
    }
    
    // MARK: - Configurations
    /// Shows message when there is no items in the list
    private final func setupMessageLabel() {
        messageLabel.center = view.center
        messageLabel.numberOfLines = 0
        view.addSubview(messageLabel)
        view.bringSubviewToFront(messageLabel)
        showMessage()
    }
    
    private final func setupSearchBar() {
        searchController.searchBar.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Movies"
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    private final func registerCell() {
        collectionView.register(UINib(nibName: LoadingFooterView.identifier, bundle: nil), forSupplementaryViewOfKind: "someKind", withReuseIdentifier: LoadingFooterView.identifier)
    }
    
    // MARK: - Utility Methods
    private final func hideMessage() {
        DispatchQueue.main.async {
            self.messageLabel.isHidden = true
        }
    }
    
    private final func showMessage(_ message: String = "Enter valid title in search to get movies.") {
        DispatchQueue.main.async {
            self.messageLabel.isHidden = false
            self.messageLabel.text = message
        }
    }
    
    private final func showLoading() {
        DispatchQueue.main.async {
            self.activityIndicator.startAnimating()
        }
    }
    
    private final func hideLoading() {
        DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
        }
    }
    
    /// Clears data from the movies list. I.e, when the search was cancelled, or before starting a new search.
    private final func clearDataFromList() {
        showMessage()
        moviesListViewModel.resetStore()
        applySnapshot()
    }
    
    // MARK: - API Request
    private final func fetchMovies() {
        guard let title = searchText?.trimmingCharacters(in: .whitespacesAndNewlines), !title.isEmpty else { return }
        
        isLoadingList = true
        showLoading()
        moviesListViewModel.fetchMovies(for: title) {[weak self] movies, error in
            guard let welf = self else {
                return
            }
            
            welf.isLoadingList = false
            welf.hideLoading()
            
            if let error = error {
                welf.showMessage(error.localizedDescription)
            } else if let _ = movies {
                welf.hideMessage()
                welf.applySnapshot()
            }
        }
    }
}

// MARK: - Diffable Data Source
extension MoviesViewController {
    /// Creating the data source for using Diffable Data source
    func makeDataSource() -> DataSource {
        let dataSource = DataSource(collectionView: collectionView) { collectionView, indexPath, movie in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieCollectionViewCell.identifier, for: indexPath) as? MovieCollectionViewCell
            if let poster = movie.poster {
                cell?.setDetails(imageURLString: poster, movietTitle: movie.title ?? "Name Unknown.")
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
    
    /// Applying the snapshot with new changes in the movies list
    func applySnapshot(animatingDifferences: Bool = true) {
        DispatchQueue.main.async {
            var snapshot = SnapShot()
            snapshot.appendSections([.main])
            snapshot.appendItems(self.moviesListViewModel.movies)
            self.dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
        }
    }
}

// MARK: - Scroll Delegate
extension MoviesViewController {
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (((scrollView.contentOffset.y + scrollView.frame.size.height) > scrollView.contentSize.height ) && !isLoadingList){
            self.fetchMovies()
        }
    }
}

// MARK: - Collection View Flow Layout Delegate
extension MoviesViewController: UICollectionViewDelegateFlowLayout {
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedRow = indexPath.row
        performSegue(withIdentifier: "MovieDetailsSegue", sender: nil)
    }
    
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

// MARK: - Search Delegates
extension MoviesViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        clearDataFromList()
        searchText = searchBar.text
        hideMessage()
        fetchMovies()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchText = ""
    }
}
