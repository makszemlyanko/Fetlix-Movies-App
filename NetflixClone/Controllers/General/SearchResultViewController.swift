//
//  SearchResultViewController.swift
//  NetflixClone
//
//  Created by Maks Kokos on 02.11.2022.
//

import UIKit

protocol SearchResultViewControllerDelegate: AnyObject {
    func searchResultViewControllerDidTapItem(_ viewModel: MoviePreviewViewModel)
}

class SearchResultViewController: UIViewController {
    
    var movies: [Movie] = [Movie]()
    
    weak var delegate: SearchResultViewControllerDelegate?

    let searchResultCollectionView: UICollectionView = {
       let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width / 3 - 10, height: 200)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(PosterCollectionViewCell.self, forCellWithReuseIdentifier: PosterCollectionViewCell.cellId)
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchResultCollectionView.backgroundColor = .systemBackground
        view.addSubview(searchResultCollectionView)
        
        searchResultCollectionView.delegate = self
        searchResultCollectionView.dataSource = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        searchResultCollectionView.frame = view.bounds
    }


}

extension SearchResultViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PosterCollectionViewCell.cellId, for: indexPath) as? PosterCollectionViewCell else { return UICollectionViewCell() }
        let movie = self.movies[indexPath.item]
        cell.configurePoster(path: movie.poster_path ?? "") 
        return cell
    }
}

extension SearchResultViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        let movie = movies[indexPath.item]
        guard let movieName = movie.name ?? movie.title else { return }
        
        APICaller.shared.getMoviesFromYouTube(with: movieName) { [weak self] result  in
            switch result {
            case .success(let video):
                self?.delegate?.searchResultViewControllerDidTapItem(MoviePreviewViewModel(movie: movieName, youtubeVideo: video, movieOverview: movie.overview ?? ""))
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
